import 'dart:io';

import 'package:adfc_ttp/all_tours.dart';

import 'global_constants.dart';

class TourRecord {
  String _tourGuide = "";
  String _registration = "nein";

  DateTime get startDate => _startDate;
  late DateTime _startDate;

  late DateTime _endDate;
  String _isMultipleDaysTour = "nein";

  // Characteristics of a tour
  String _isFastTour = 'normal';
  String _isMountainous = 'nein';

  final List<String> _tour = [];

  List<String> get tour => _tour;

  TourRecord(List<String> line) {
    for (int i = 0; i < line.length; ++i) {
      if (Csv.headerNamesCsvInput.contains(i)) {
        // Process relevant input fields
        _tour.add(line[i]);
      }
    }

    _postProcessing();
  }

  void _postProcessing() {
    try {
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

      _findRegistration();
      _findTourGuide();
      _multipleDaysTour();

      // Characteristics of a tour
      _isFastTour = int.parse(
                  _tour[AllTours.csvInputFields2TourFields[Csv.speedField]!]) >
              altitudeThreshold
          ? 'schnell'
          : 'normal';

      var altitude = int.parse(
          _tour[AllTours.csvInputFields2TourFields[Csv.altitudeField]!]
              .replaceAll(RegExp(r'[="]'), ''));
      _isMountainous = altitude > altitudeThreshold ? 'ja' : 'nein';
    } on FormatException catch (e) {
      print(e.message);
    }
  }

  void _findRegistration() {
    if (_tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!]
        .contains("Anmeldung")) {
      _registration = 'ja';
    }
  }

  void _findTourGuide() {
    _tourGuide = _tour[AllTours.csvInputFields2TourFields[Csv.organizerField]!];
    if (_tourGuide.compareTo(defaultTourGuide) == 0) {
      final lines =
          _tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!]
              .split('\n');
      for (var line in lines) {
        if (line.contains('Tourenleit') || line.contains('Tourleit')) {
          _tourGuide = line;
          return;
        }
      }
    }
  }

  void _multipleDaysTour() {
    _isMultipleDaysTour =
        (_startDate.isAtSameMomentAs(_endDate)) ? 'nein' : 'ja';
  }

  void _printText(String fieldName, String text,
      {IOSink? txtSink,
      IOSink? htmlSink,
      IOSink? csvSink,
      bool bold = false,
      bool replaceNewLines = false,
      bool lastField = false,
      bool consoleOutput = true}) {
    if (consoleOutput) {
      _printRecord(FileType.console, fieldName, text,
          bold: bold, replaceNewLines: replaceNewLines);
    }
    if (txtSink != null) {
      _printRecord(FileType.txt, fieldName, text,
          sink: txtSink, bold: false, replaceNewLines: replaceNewLines);
    }
    if (htmlSink != null) {
      _printRecord(FileType.html, fieldName, text,
          sink: htmlSink, bold: bold, replaceNewLines: replaceNewLines);
    }
    if (csvSink != null) {
      _printRecord(FileType.csv, fieldName, text,
          sink: csvSink,
          bold: false,
          replaceNewLines: true,
          appendNewLine: lastField);
    }
  }

  void printTour({IOSink? txtSink, IOSink? htmlSink, IOSink? csvSink}) {
    if (htmlSink != null) {
      htmlSink.writeln('<p>');
    }

    int outputField = 0;

    // title
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.titleField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
      bold: true,
    );
    outputField++;

    // short description
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.shortDescriptionField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
      replaceNewLines: true,
    );
    outputField++;

    // description
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.descriptionField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
      replaceNewLines: true,
    );
    outputField++;

    // start date
    var weekday = _startDate.weekday;
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.startDateField]!],
      csvSink: csvSink,
      consoleOutput: false,
    );
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      '${_tour[AllTours.csvInputFields2TourFields[Csv.startDateField]!]} (${nameOfWeekDays[weekday - 1]})',
      txtSink: txtSink,
      htmlSink: htmlSink,
    );
    outputField++;

    // start time
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.startTimeField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // end date
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.endDateField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // tour guide
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tourGuide,
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // length
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.lengthField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // Speed
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _isFastTour,
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // speed description
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.speedDescField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // mountainous
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _isMountainous,
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // mountain characteristic
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.altitudeDescField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

// difficulty
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.difficultyField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // street
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.streetField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // city
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _tour[AllTours.csvInputFields2TourFields[Csv.cityField]!],
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // registration
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _registration,
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
    );
    outputField++;

    // multi day tour
    _printText(
      Csv.headerNamesCsvOutput[outputField],
      _isMultipleDaysTour,
      txtSink: txtSink,
      htmlSink: htmlSink,
      csvSink: csvSink,
      lastField: true,
    );
    outputField++;

    // print separator markers after each tour
    print('------------------------------------------------------------------');
    if (txtSink != null) {
      txtSink.writeln(
          '------------------------------------------------------------------');
    }
    if (htmlSink != null) {
      htmlSink.writeln('</p>');
    }
  }

  void _printRecord(FileType type, String colName, String text,
      {IOSink? sink,
      bool bold = false,
      bool appendNewLine = true,
      bool replaceNewLines = false}) {
    switch (type) {
      case FileType.csv:
        sink?.write(text.replaceAll('\n', ' - '));
        break;
      case FileType.html:
        sink?.writeln(
            '${bold ? '<b>' : ''}<i>$colName</i>: ${replaceNewLines ? text.replaceAll('\n', ' ') : text.replaceAll('\n', '<br>')}${bold ? '</b>' : ''}');
        break;
      case FileType.txt:
        sink?.writeln(
            '$colName: ${replaceNewLines ? text.replaceAll('\n', ' - ') : text}');
        break;
      case FileType.console:
        print(
            '$colName: ${replaceNewLines ? text.replaceAll('\n', ' - ') : text}');
        break;
    }

    if (appendNewLine) {
      switch (type) {
        case FileType.csv:
          sink?.writeln();
          break;
        case FileType.html:
          sink?.writeln('<br>');
          break;
        // case FileType.txt:
        //   sink?.writeln();
        //   break;
        default:
      }
    } else {
      switch (type) {
        case FileType.csv:
          sink?.write(Csv.fieldDelimiter);
          break;
        default:
      }
    }
  }
}
