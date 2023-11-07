import 'dart:io';

import 'package:adfc_ttp/all_tours.dart';

import 'global_constants.dart';

/// Everything about a single tour
class TourRecord {
  // processing date comparison
  late DateTime _startDate;
  late DateTime _endDate;

  // Characteristics of a tour
  final String _registration = "nein";
  String _isMultipleDaysTour = '';
  String _isHighLight = ''; // should tour be highlighted? ("x" or "")

  // a single tour with a list of (relevant) fields
  final List<String> _tour = [];

  /// Process a single tour ans save it internally (tour)
  TourRecord(List<String> line) {
    for (int i = 0; i < line.length; ++i) {
      if (_isCsvInputColRelevant(i)) {
        // Process relevant input fields
        _tour.add(line[i]);
      }
    }
    _postProcessing();
  }

  DateTime get startDate => _startDate;

  List<String> get tour => _tour;

  /// output a single tour to a csv file
  void printCsvLine(IOSink csvSink) {
    // input fields, which are directly copied to output fields
    int lastField = Csv.csvInputDescription.length;

    for (int i = 0; i < lastField; ++i) {
      // INFO: // No new lines in csv output fields
      // Can be optimized to only replace description and short description
      csvSink.write(_tour[i].replaceAll('\n', ' - '));
      csvSink.write(Csv.fieldDelimiter);
    }

    // Additional fields
    for (int i = 0; i < Csv.additionalFields.length - 1; ++i) {
      csvSink.write(_tour[lastField + i]);
      csvSink.write(Csv.fieldDelimiter);
    }
    // Last field
    csvSink.writeln(_tour[lastField + Csv.additionalFields.length - 1]);
  }

  /// output a single tour to a text and html file
  void printTextLine(IOSink txtSink, IOSink htmlSink) {
    // Print header for each tour
    print('---------------------------------------------------------');
    txtSink
        .writeln('---------------------------------------------------------');
    if (_isHighLight.isNotEmpty) {
      htmlSink.writeln('<h4 style="background-color:powderblue;">');
    } else {
      htmlSink.writeln('<p>');
    }

    // Print tour
    int outputField = 0;

    // title
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.titleField]!],
      bold: true,
    );
    outputField++;

    // short description
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.shortDescriptionField]!],
    );
    outputField++;

    // description
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!],
    );
    outputField++;

    // start
    final day = _tour[AllTours.csvInputFields2TourFields[Csv.startDateField]!];
    final time = _tour[AllTours.csvInputFields2TourFields[Csv.startTimeField]!];
    final weekday = nameOfWeekDays[_startDate.weekday - 1];
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      '$day ($weekday), $time',
    );
    outputField++;

    // meeting point
    String meetingPoint =
        '${_tour[AllTours.csvInputFields2TourFields[Csv.cityField]!]}, '
        '${_tour[AllTours.csvInputFields2TourFields[Csv.streetField]!]}';
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      meetingPoint,
    );
    outputField++;

    // meeting point 2
    final String nextCity =
        _tour[AllTours.csvInputFields2TourFields[Csv.nextCityField]!];
    if (nextCity.isNotEmpty) {
      meetingPoint =
          '${_tour[AllTours.csvInputFields2TourFields[Csv.nextCityField]!]}, '
          '${_tour[AllTours.csvInputFields2TourFields[Csv.nextStreetField]!]}';
      _printRecord(
        txtSink,
        htmlSink,
        Csv.textOutput[outputField],
        meetingPoint,
      );
    }
    outputField++;

    // tour guide
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.tourGuideField]!],
    );
    outputField++;

    // length
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.lengthField]!],
    );
    outputField++;

    // Speed
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.speedField]!],
    );
    outputField++;

    // speed description
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.speedDescField]!],
    );
    outputField++;

    // mountainous
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.altitudeField]!],
    );
    outputField++;

    // mountain characteristic
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.altitudeDescField]!],
    );
    outputField++;

    // difficulty
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.difficultyField]!],
    );
    outputField++;

    // registration
    _printRecord(
      txtSink,
      htmlSink,
      Csv.textOutput[outputField],
      _registration,
    );
    outputField++;

    // multi day tour
    if (_isMultipleDaysTour.isNotEmpty) {
      _printRecord(
        txtSink,
        htmlSink,
        Csv.textOutput[outputField],
        _isMultipleDaysTour,
      );
      outputField++;

      // end
      _printRecord(
        txtSink,
        htmlSink,
        Csv.textOutput[outputField],
        _tour[AllTours.csvInputFields2TourFields[Csv.endDateField]!],
      );
      outputField++;
    }
    // footer for each tour
    if (_isHighLight.isNotEmpty) {
      htmlSink.writeln('</h4>');
    } else {
      htmlSink.writeln('</p>');
    }
  }

  /// checks if a tour should be highlighted (in html output)
  void setIsHighLight(String newIsHighLight) {
    _isHighLight = newIsHighLight;
    _tour[Csv.csvInputDescription.length + AdditionalFields.highlight.index] =
        newIsHighLight;
  }

  /// checks if the tour needs registration
  void _findRegistration() {
    if (_tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!]
        .contains("Anmeldung")) {
      _tour.add('ja');
    } else {
      _tour.add('nein');
    }
  }

  /// checks if a given input column is relevant for further processing
  bool _isCsvInputColRelevant(int col) {
    for (var field in Csv.csvInputDescription) {
      if (field.$1 == col) {
        return true;
      }
    }
    return false;
  }

  /// checks whether a tour spans multiple days
  void _multipleDaysTour() {
    _isMultipleDaysTour = (_startDate.isAtSameMomentAs(_endDate)) ? '' : 'ja';
    _tour.add(_isMultipleDaysTour);
  }

  /// Process a single tour for additional fields and special treatments
  /// highly dependant on the order of files
  void _postProcessing() {
    try {
      // Convert dates
      List<String> date =
          _tour[AllTours.csvInputFields2TourFields[Csv.startDateField]!]
              .split('.');
      int day = int.parse(date[0]);
      int month = int.parse(date[1]);
      int year = int.parse(date[2]);
      _startDate = DateTime(year, month, day);

      date = _tour[AllTours.csvInputFields2TourFields[Csv.endDateField]!]
          .split('.');
      day = int.parse(date[0]);
      month = int.parse(date[1]);
      year = int.parse(date[2]);
      _endDate = DateTime(year, month, day);

      // Tour guide
      _replaceTourGuide();

      // Registration
      _findRegistration();

      // Multiple days tour
      _multipleDaysTour();

      // find tour guide's initials
      _tourGuideAbbrev();

      // create room for the field "highlighted"
      _tour.add(_isHighLight);

      // Characteristics of a tour
      final RegExp regExp = RegExp(r'[="\\]');
      final speedStr =
          _tour[AllTours.csvInputFields2TourFields[Csv.speedField]!];
      final replacedSpeedStr = speedStr.replaceAll(regExp, '');
      final isFastTour = int.parse(replacedSpeedStr) > altitudeThreshold
          ? 'schnell'
          : 'normal';
      _tour[AllTours.csvInputFields2TourFields[Csv.speedField]!] = isFastTour;

      final altitudeStr =
          _tour[AllTours.csvInputFields2TourFields[Csv.altitudeField]!];
      final replacedAltitudeStr = altitudeStr.replaceAll(regExp, '');

      var altitude = int.parse(replacedAltitudeStr);
      tour[AllTours.csvInputFields2TourFields[Csv.altitudeField]!] =
          altitude > altitudeThreshold ? 'ja' : 'nein';
    } on FormatException catch (e) {
      print(e.message);
    }
  }

  /// prints a single tour record to a text and html file
  void _printRecord(
    IOSink txtSink,
    IOSink htmlSink,
    String colName,
    String text, {
    bool bold = false,
  }) {
    print('$colName: $text');
    txtSink.writeln('$colName: $text');
    htmlSink.writeln(
        '${bold ? '<b>' : ''}<i>$colName</i>: ${text.replaceAll('\n', '<br>')}${bold ? '</b>' : ''}<br>');
  }

  /// Take a hint to the tour guide from the description field, if no
  /// tour guide is mentioned explicitly in the tour guide field
  void _replaceTourGuide() {
    // tour guide from tour guide / organizer field
    String tourGuide =
        _tour[AllTours.csvInputFields2TourFields[Csv.tourGuideField]!];
    if (tourGuide.compareTo(defaultTourGuide) == 0) {
      // tour guide from description field extracted
      final lines =
          _tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!]
              .split('\n');
      for (var line in lines) {
        if (line.contains('Tourenleit') || line.contains('Tourleit')) {
          tourGuide = line;
          break;
        }
      }
    }
    _tour[AllTours.csvInputFields2TourFields[Csv.tourGuideField]!] = tourGuide;
  }

  /// Map tour guide names to their initials
  void _tourGuideAbbrev() {
    String tourGuideAbbrev = 'NN';
    String tourGuide =
        _tour[AllTours.csvInputFields2TourFields[Csv.tourGuideField]!];

    // Abbreviations of tour guide
    tourGuidesAbbrev.forEach((guide, abbrev) {
      if (tourGuide.compareTo(guide) == 0) {
        tourGuideAbbrev = abbrev;
        return;
      }
    });
    _tour.add(tourGuideAbbrev);
  }
}
