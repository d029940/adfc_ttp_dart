import 'dart:io';

import 'package:adfc_ttp/global_constants.dart';
import 'package:adfc_ttp/tour_record.dart';
import 'package:csv/csv.dart';
import 'package:dart_date/dart_date.dart';
import 'package:path/path.dart' as p;

/// Everything related to a all tours
class AllTours {
  // Input csv field mapping index:
  // - Need to match the sequence of fields in input csv
  static final Map<int, int> _csvInputFields2TourFields = {};

  // tour numbers, which should be highlighted in the output
  static final Set<int> _highlightedTours = {};
  static Map<int, int> get csvInputFields2TourFields =>
      _csvInputFields2TourFields;

  final File csvInputFile;
  final File? highlightFile;

  late final File outputTextFile;
  late final File outputHtmlFile;
  late final File outputCsvFile;

  final List<TourRecord> _tours = [];

  /// reads tours from the csv file, process and sort them into internal var.
  /// Creates the names of the output files
  AllTours(this.csvInputFile, {this.highlightFile}) {
    // map csv input fields to the fields in the tour record.
    // needed for accessing specific field in the tour record
    // by the field number of the csv input file
    for (int i = 0; i < Csv.csvInputDescription.length; ++i) {
      _csvInputFields2TourFields[Csv.csvInputDescription[i].$1] = i;
    }

    final dirname = p.dirname(csvInputFile.path);
    final inputFileWithoutExt = p.basenameWithoutExtension(csvInputFile.path);

    // Parse CSV file and create internal representation of the tours
    List<List<dynamic>> csvDocument =
        const CsvToListConverter(fieldDelimiter: Csv.fieldDelimiter)
            .convert(csvInputFile.readAsStringSync());

    bool isHeader = true;
    for (var line in csvDocument) {
      if (isHeader) {
        // skip the field headers in the first line
        isHeader = false;
        continue;
      }
      // parse tour for relevant output field
      _tours.add(TourRecord(line.cast<String>()));
    }
    _sort();

    final dateStr = DateTime.now().format('_yyyy-MM-dd', 'de_DE');
    // final dateStr = '_${now.year}-${now.month}-${now.day}';
    outputTextFile =
        File('$dirname${p.separator}$inputFileWithoutExt$dateStr.txt');
    outputHtmlFile =
        File('$dirname${p.separator}$inputFileWithoutExt$dateStr.html');
    outputCsvFile =
        File('$dirname${p.separator}$inputFileWithoutExt$dateStr.csv');
  }

  /// Print header, tours and footer from the internal ar
  Future<void> printTours() async {
    // open output files
    var csvSink = outputCsvFile.openWrite(encoding: SystemEncoding());
    var htmlSink = outputHtmlFile.openWrite();
    var txtSink = outputTextFile.openWrite(encoding: SystemEncoding());

    // print header
    _printHeader(csvSink, htmlSink);

    // Tours which are marked highlighted get special treatment in html file
    await processHighlightedTours(highlightFile);

    // printing tour
    for (var tourRecord in _tours) {
      tourRecord.printCsvLine(csvSink);
      tourRecord.printTextLine(txtSink, htmlSink);
    }

    // print footer
    _printFooter(htmlSink, txtSink);

    // closing files
    await txtSink.flush();
    txtSink.close();
    await htmlSink.flush();
    htmlSink.close();
    await csvSink.flush();
    csvSink.close();
  }

  /// reads the highlighted tours and saves them in internal var.
  Future<void> processHighlightedTours(File? highlightFile) async {
    if (highlightFile == null) {
      return;
    }

    // Read the file with the highlighted tours
    try {
      final contents = await highlightFile.readAsString();
      RegExp exp = RegExp(r'[0-9]+');

      Iterable<RegExpMatch> numbers = exp.allMatches(contents);
      for (final num in numbers) {
        final tour = int.parse(num[0].toString()) -
            1; // -1, because numbering starts with 2 in the csv file.
        // first line is the header line in csv file
        _highlightedTours.add(tour);
      }
    } catch (e) {
      print(e.toString());
      return;
    }

    // mark the highlighted tours in the tour record
    _markHighlightedTours();
  }

  void _markHighlightedTours() {
    for (int i = 0; i < _tours.length; ++i) {
      if (AllTours._highlightedTours.contains(i + 1)) {
        TourRecord tour = _tours[i];
        tour.setIsHighLight("X");
      }
    }
  }

  /// prints a footer to the csv, text and html file after outputting the tours
  void _printFooter(IOSink htmlSink, IOSink txtSink) {
    print('Anzahl Touren: ${_tours.length}');
    txtSink.writeln('Anzahl Touren: ${_tours.length}');

    htmlSink.writeln('<p><b><i>Anzahl Touren: ${_tours.length}</i></b></p>');
    htmlSink.writeln('</body> \n</html>');
  }

  /// write headers to csv, text and html file before outputting the tours
  _printHeader(IOSink csvSink, IOSink htmlSink) {
    // CSV file
    for (var fieldDescription in Csv.csvInputDescription) {
      csvSink.write('${fieldDescription.$2}${Csv.fieldDelimiter}');
    }

    // additional fields in csv
    for (int i = 0; i < Csv.additionalFields.length - 1; ++i) {
      csvSink.write('${Csv.additionalFields[i]}${Csv.fieldDelimiter}');
    }
    // Last field
    csvSink.writeln(Csv.additionalFields[Csv.additionalFields.length - 1]);

    // HTML file
    htmlSink.writeln('<!DOCTYPE html>');
    htmlSink.writeln('<html>');
    htmlSink.writeln('<head> <title>ADFC Liste der Touren</title> </head>');
    htmlSink.writeln('<meta charset="utf-8">');
    htmlSink.writeln('<h1>ADFC Liste der Touren</h1>');
    htmlSink.writeln('<body>');
  }

  /// sort all tours according to the start date
  void _sort() {
    _tours.sort((TourRecord lhs, TourRecord rhs) {
      final left = lhs.startDate;
      final right = rhs.startDate;

      if (left.isBefore(right)) {
        return -1;
      } else if (left.isAfter(right)) {
        return 1;
      } else {
        return 0;
      }
    });
  }
}
