import 'dart:io';

import 'package:adfc_ttp/global_constants.dart';
import 'package:adfc_ttp/tour_record.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;

class AllTours {
  final File file;
  late final File outputTextFile;
  late final File outputHtmlFile;
  late final File outputCsvFile;
  final List<TourRecord> _tours = [];

  AllTours(this.file) {
    final dirname = p.dirname(file.path);
    final inputFileWithoutExt = p.basenameWithoutExtension(file.path);

    // Parse CSV file and create internal representation of the tours
    List<List<dynamic>> csvDocument =
        const CsvToListConverter(fieldDelimiter: Csv.fieldDelimiter)
            .convert(file.readAsStringSync());
    // Async version
    // final csvFile = await file.readAsString();
    // List<List<dynamic>> csvDocument = const CsvToListConverter().convert(csvFile);

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

    outputTextFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.txt');
    outputHtmlFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.html');
    outputCsvFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.csv');
  }

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

  Future<void> printTours() async {
    // opening steps for csv output
    var csvSink = outputCsvFile.openWrite();
    // Write header
    for (int i = 0; i < Csv.headerNamesCsvOutput.length - 1; ++i) {
      if (OutFields.values[i] != OutFields.organizer) {
        // special treatment for Organizer: do not output
        csvSink.write('${Csv.headerNamesCsvOutput[i]}${Csv.fieldDelimiter}');
      }
    }
    csvSink
        .writeln(Csv.headerNamesCsvOutput[Csv.headerNamesCsvOutput.length - 1]);

    // opening steps for html output
    var htmlSink = outputHtmlFile.openWrite();
    // write header
    htmlSink.writeln('<!DOCTYPE html>');
    htmlSink.writeln('<html>');
    htmlSink.writeln('<head> <title>ADFC Liste der Touren</title> </head>');
    htmlSink.writeln('<meta charset="utf-8">');
    htmlSink.writeln('<h1>ADFC Liste der Touren</h1>');
    htmlSink.writeln('<body>');

    // opening steps for text output
    var txtSink = outputTextFile.openWrite();

    // printing tour
    for (var tourRecord in _tours) {
      tourRecord.printTour(
          txtSink: txtSink, htmlSink: htmlSink, csvSink: csvSink);
    }

    // closing steps for console output
    print('Anzahl Touren: ${_tours.length}');

    // closing steps for text output
    txtSink.writeln('Anzahl Touren: ${_tours.length}');
    await txtSink.flush();
    txtSink.close();

    // closing steps for html output
    htmlSink.writeln('<p><b><i>Anzahl Touren: ${_tours.length}</i></b></p>');
    htmlSink.writeln('</body> \n</html>');

    await htmlSink.flush();
    htmlSink.close();

    // closing steps for csv output
    await csvSink.flush();
    csvSink.close();
  }
}
