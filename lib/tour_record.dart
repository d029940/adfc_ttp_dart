import 'dart:io';

import 'global_constants.dart';

class TourRecord {
  String _tourGuide = "";
  String _registration = "nein";

  DateTime get startDate => _startDate;
  late DateTime _startDate;

  late DateTime _endDate;
  String _isMultipleDaysTour = "nein";

  final List<String> _tour = [];
  List<String> get tour => _tour;

  TourRecord(List<String> line) {
    for (int i = 0; i < line.length; ++i) {
      if (Csv.headerNamesCsvInput.containsKey(i)) {
        // Process relevant input fields
        _tour.add(line[i]);
      }
    }

    _postProcessing();
  }

  void _postProcessing() {
    List<String> date = _tour[OutFields.startDate.index].split('.');
    int day = int.parse(date[0]);
    int month = int.parse(date[1]);
    int year = int.parse(date[2]);
    _startDate = DateTime(year, month, day);

    date = _tour[OutFields.endDate.index].split('.');
    day = int.parse(date[0]);
    month = int.parse(date[1]);
    year = int.parse(date[2]);
    _endDate = DateTime(year, month, day);

    _findRegistration();
    _findTourGuide();
    _multipleDaysTour();
  }

  void _findRegistration() {
    if (_tour[OutFields.description.index].contains("Anmeldung")) {
      _registration = 'ja';
    }
  }

  void _findTourGuide() {
    _tourGuide = _tour[OutFields.organizer.index];
    if (_tourGuide.compareTo(defaultTourGuide) == 0) {
      final lines = _tour[OutFields.description.index].split('\n');
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
    for (int i = 0; i < Csv.headerNamesCsvOutput.length - 1; ++i) {
      if (i == OutFields.title.index) {
        _printText(
          Csv.headerNamesCsvOutput[i],
          _tour[OutFields.title.index],
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
          bold: true,
        );
      } else if (i == OutFields.shortDescription.index) {
        _printText(
          Csv.headerNamesCsvOutput[i],
          _tour[OutFields.shortDescription.index],
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
          replaceNewLines: true,
        );
      } else if (i == OutFields.startDate.index) {
        var weekday = _startDate.weekday;
        _printText(
            Csv.headerNamesCsvOutput[i], _tour[OutFields.startDate.index],
            csvSink: csvSink, consoleOutput: false);
        _printText(
          Csv.headerNamesCsvOutput[i],
          '${_tour[OutFields.startDate.index]} (${nameOfWeekDays[weekday - 1]})',
          txtSink: txtSink,
          htmlSink: htmlSink,
        );
      } else if (i == OutFields.tourGuide.index) {
        _printText(
          Csv.headerNamesCsvOutput[i],
          _tourGuide,
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
        );
      } else if (i == OutFields.registration.index) {
        _printText(
          Csv.headerNamesCsvOutput[i],
          _registration,
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
        );
      } else if (i == OutFields.multipleDays.index) {
        _printText(
          Csv.headerNamesCsvOutput[i],
          _isMultipleDaysTour,
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
          lastField: true,
        );
      } else if (i < tour.length && i != OutFields.organizer.index) {
        // special treatment for Organizer: do not output
        _printText(
          Csv.headerNamesCsvOutput[i],
          _tour[i],
          txtSink: txtSink,
          htmlSink: htmlSink,
          csvSink: csvSink,
        );
      }
    }

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
