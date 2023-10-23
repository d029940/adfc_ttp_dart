import 'dart:io';

import 'package:adfc_ttp/parse_csv.dart';
import 'package:adfc_ttp/tour_record.dart';
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
    outputTextFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.txt');
    outputHtmlFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.html');
    outputCsvFile = File('$dirname${p.separator}$inputFileWithoutExt-mk.csv');
  }

  void add(TourRecord tour) {
    _tours.add(tour);
  }

  void sort() {
    _tours.sort((TourRecord lhs, TourRecord rhs) {
      final left = lhs.startDate.split('.');
      final right = rhs.startDate.split('.');

      final leftMonth = int.parse(left[1]);
      final rightMonth = int.parse(right[1]);
      final leftDay = int.parse(left[0]);
      final rightDay = int.parse(right[0]);
      final leftVal = leftMonth * 100 + leftDay;
      final rightVal = rightMonth * 100 + rightDay;

      return leftVal - rightVal;
    });
  }

  Future<void> writeCsFile() async {
    var sink = outputCsvFile.openWrite();

    // Write header
    ParseCsv.headerNames.forEach((key, value) {
      sink.write('$value${ParseCsv.fieldDelimiter}');
    });
    sink.writeln('Tourleitung${ParseCsv.fieldDelimiter}Anmeldung');

    for (var tour in _tours) {
      sink.write('${tour.title}${ParseCsv.fieldDelimiter}');
      sink.write(
          '${tour.shortDescription.replaceAll('\n', ' - ')}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.organizer}${ParseCsv.fieldDelimiter}');
      sink.write(
          '${tour.description.replaceAll('\n', ' - ')}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.startDate}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.startTime}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.endDate}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.city}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.street}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.lengthKm}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.difficulty}${ParseCsv.fieldDelimiter}');
      sink.write('${tour.tourGuide}${ParseCsv.fieldDelimiter}');
      sink.writeln('${tour.registration}');
    }

    await sink.flush();
    sink.close();
  }

  Future<void> writeTextFile() async {
    var sink = outputTextFile.openWrite();

    for (var tour in _tours) {
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.titleField]}: ${tour.title}');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.shortDescriptionField]}: ${tour.shortDescription}');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.organizerField]}: ${tour.organizer}');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.descriptionField]}: ${tour.description}');
      sink.writeln('Startzeit: ${tour.startDate} ${tour.startTime}');
      sink.writeln('Treffpunkt: ${tour.city}, ${tour.street}');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.lengthField]}: ${tour.lengthKm}');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.difficultyField]}: ${tour.difficulty}');
      sink.writeln('Tourenleitung: ${tour.tourGuide}');
      sink.writeln('Anmeldung: ${tour.registration}');
      sink.writeln(
          '------------------------------------------------------------------');
    }
    sink.writeln('Anzahl Touren: ${_tours.length}');
    await sink.flush();
    sink.close();
  }

  Future<void> writeHtmlFile() async {
    var sink = outputHtmlFile.openWrite();

    sink.writeln('<!DOCTYPE html>');
    sink.writeln('<html>');
    sink.writeln('<head> <title>ADFC Liste der Touren</title> </head>');
    sink.writeln('<meta charset="utf-8">');
    sink.writeln('<h1>ADFC Liste der Touren</h1>');
    sink.writeln('<body>');

    for (var tour in _tours) {
      sink.writeln('<p>');
      sink.writeln(
          '<b><i>${ParseCsv.headerNames[ParseCsv.titleField]}: ${tour.title}</i></b><br>');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.shortDescriptionField]}: ${tour.shortDescription}<br>');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.organizerField]}: ${tour.organizer}<br>');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.descriptionField]}: ${tour.description}<br>');
      sink.writeln('Startzeit: ${tour.startDate} ${tour.startTime}<br>');
      sink.writeln('Treffpunkt: ${tour.city}, ${tour.street}<br>');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.lengthField]}: ${tour.lengthKm}<br>');
      sink.writeln(
          '${ParseCsv.headerNames[ParseCsv.difficultyField]}: ${tour.difficulty}<br>');
      sink.writeln('Tourenleitung: ${tour.tourGuide}<br>');
      sink.writeln('Anmeldung: ${tour.registration}<br>');
      sink.writeln('</p>');
    }
    sink.writeln('<p><b><i>Anzahl Touren: ${_tours.length}</i></b></p>');
    sink.writeln('</body> \n</html>');

    await sink.flush();
    sink.close();
  }

  void printTours() {
    for (var tourRecord in _tours) {
      tourRecord.printTour();
      print(
          '------------------------------------------------------------------');
    }
    print('Anzahl Touren: ${_tours.length}');
  }
}
