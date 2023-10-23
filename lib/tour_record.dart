import 'package:adfc_ttp/parse_csv.dart';

class TourRecord {
  final String title;
  final String shortDescription;
  final String organizer;
  final String description;
  final String startDate;
  final String startTime;
  final String endDate;
  final String city;
  final String street;
  final String lengthKm;
  final String speed;
  final String difficulty;

  String? tourGuide;
  String? registration;
  static const String defaultTourGuide = 'ADFC Garbsen/Seelze';

  TourRecord(
      this.title,
      this.shortDescription,
      this.organizer,
      this.description,
      this.startDate,
      this.startTime,
      this.endDate,
      this.city,
      this.street,
      this.lengthKm,
      this.speed,
      this.difficulty,
      {this.tourGuide,
      this.registration}) {
    _findRegistration();
    _findTourGuide();
  }

  void _findRegistration() {
    if (description.contains("Anmeldung")) {
      registration = 'ja';
    } else {
      registration = 'nein';
    }
  }

  void _findTourGuide() {
    tourGuide = organizer;
    if (organizer.compareTo(defaultTourGuide) == 0) {
      final lines = description.split('\n');
      for (var line in lines) {
        if (line.contains('Tourenleit') || line.contains('Tourleit')) {
          tourGuide = line;
          return;
        }
      }
    }
  }

  void printTour() {
    print('${ParseCsv.headerNames[ParseCsv.titleField]}: $title');
    print(
        '${ParseCsv.headerNames[ParseCsv.shortDescriptionField]}: $shortDescription');
    print('${ParseCsv.headerNames[ParseCsv.organizerField]}: $organizer');
    print('${ParseCsv.headerNames[ParseCsv.descriptionField]}: $description');
    print('Startzeit: $startDate $startTime');
    print('Treffpunkt: $city,  $street');
    print('${ParseCsv.headerNames[ParseCsv.lengthField]}: $lengthKm');
    print('${ParseCsv.headerNames[ParseCsv.difficultyField]}: $difficulty');
    print('Tourenleitung: $tourGuide');
    print('Anmeldung: $registration');
  }
}
