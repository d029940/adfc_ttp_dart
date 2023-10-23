import 'dart:io';

import 'package:adfc_ttp/all_tours.dart';
import 'package:csv/csv.dart';

import 'tour_record.dart';

class ParseCsv {
  static const fieldDelimiter = ';';

  // relevant Fields of the csv file
  static const titleField = 3;
  static const shortDescriptionField = 4;
  static const descriptionField = 5;
  static const startDateField = 11;
  static const startTimeField = 12;
  static const endDateField = 13;

  static const organizerField = 26;
  static const lengthField = 32;
  static const speedField = 33;

  static const difficultyField = 39;
  static const streetField = 40;
  static const cityField = 41;

  // output csv header field names
  static const Map<int, String> headerNames = {
    titleField: 'Titel',
    shortDescriptionField: 'Kurzbeschreibung',
    organizerField: 'Organisator',
    descriptionField: 'Beschreibung',
    startDateField: 'Datum',
    startTimeField: 'Zeit',
    endDateField: 'Ende',
    cityField: 'Stadt',
    streetField: 'Strasse',
    lengthField: 'Länge',
    difficultyField: 'Schwierigkeitsgrad'
  };

  ParseCsv(File file, AllTours tours) {
    List<List<dynamic>> csvDocument =
        const CsvToListConverter(fieldDelimiter: fieldDelimiter)
            .convert(file.readAsStringSync());
    // TODO: Catch XmlException
    // Async version
    // final csvFile = await file.readAsString();
    // List<List<dynamic>> csvDocument = const CsvToListConverter().convert(csvFile);

    bool header = true;
    for (var tour in csvDocument) {
      if (header) {
        header = false;
        continue;
      }
      final tourRecord = TourRecord(
          tour[titleField],
          tour[shortDescriptionField],
          tour[organizerField],
          tour[descriptionField],
          tour[startDateField],
          tour[startTimeField],
          tour[endDateField],
          tour[cityField],
          tour[streetField],
          tour[lengthField],
          tour[speedField],
          tour[difficultyField]);
      tours.add(tourRecord);
    }

    tours.sort();
  }
}
