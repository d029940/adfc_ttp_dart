/**
All global constants which describe what

- input fields are relevant
- output fields are used for cvs output
- output fields are used for text and html output

*/

/// "Name" of tour guide, if no real one is given
const String defaultTourGuide = 'ADFC Garbsen/Seelze';

// Characteristics of a tour
const int speedThreshold = 18; // up to 18km/h normal, above fast
const List<String> normalSpeed = ['15 - 18 km/h'];
const int altitudeThreshold = 300; // up to 300Hm normal, above mountainous
const List<String> mountainous = ["hügelig", "bergig"];

// TODO: replace CSV class with Enum

enum CsvInputFields {
  titleField(3, 'Titel'),
  shortDescriptionField(4, 'Kurzbeschreibung'),
  descriptionField(5, 'Beschreibung'),
  startDateField(11, 'Beginndatum'),
  startTimeField(12, 'Beginnzeit'),
  endDateField(13, 'Endedatum'),
  tourGuideField(26, 'Tourguide'),
  lengthField(32, 'Länge'),
  speedField(33, 'Geschwindigkeit'),
  altitudeDescField(35, 'Höhenbewertung'),
  speedDescField(37, 'Geschwindigkeitsbereich'),
  difficultyField(39, 'Schwierigkeitsgrad'),
  streetField(40, 'Strasse'),
  cityField(41, 'Stadt'),
  nextStreetField(67, 'Zwischenstation 1 - Strasse'),
  nextCityField(68, 'Zwischenstation 1 - Stadt');

  final int number;
  final String text;
  const CsvInputFields(this.number, this.text);
}

/// All related constants for parsing csv file
class Csv {
  static const fieldDelimiter = ';';

  // relevant Fields of the input csv file
  static const titleField = 3; // Titel
  static const shortDescriptionField = 4; // Kurzbeschreibung
  static const descriptionField = 5; // Beschreibung
  static const startDateField = 11; // Beginndatum
  static const startTimeField = 12; // Zeit
  static const endDateField = 13; // Endedatum
  static const tourGuideField = 26; // Organisator
  static const lengthField = 32; // Länge
  static const speedField = 33; // Geschwindigkeit
  static const altitudeDescField = 34; // Höhenbewertung
  static const altitudeField = 35; // Höhenmeter
  static const speedDescField = 37; // Geschwindigkeitsbereich
  static const difficultyField = 39; // Schwierigkeitsgrad
  static const streetField = 40; // Strasse
  static const cityField = 41; // Stadt
  static const nextStreetField = 67; // Zwischenstation 1 - Strasse
  static const nextCityField = 68; // Zwischenstation 1 - Stadt

  // Process relevant input fields
  static const List<(int, String)> csvInputDescription = [
    (titleField, 'Titel'),
    (shortDescriptionField, 'Kurzbeschreibung'),
    (descriptionField, 'Beschreibung'),
    (startDateField, 'Beginndatum'),
    (startTimeField, 'Beginnzeit'),
    (endDateField, 'Endedatum'),
    (tourGuideField, 'Tourguide'),
    (lengthField, 'Länge'),
    (speedField, 'Geschwindigkeit'),
    (altitudeDescField, 'Höhenbewertung'),
    (altitudeField, 'Höhenmeter'),
    (speedDescField, 'Geschwindigkeitsbereich'),
    (difficultyField, 'Schwierigkeitsgrad'),
    (cityField, 'Stadt'),
    (streetField, 'Strasse'),
    (nextStreetField, 'Zwischenstation 1 - Strasse'),
    (nextCityField, 'Zwischenstation 1 - Stadt'),
  ];

  // additional fields calculated from input fields in
  // tour_record._postProcessing()   // look also for enum AdditionalFields
  static const List<String> additionalFields = [
    'Anmeldung',
    'Mehrtagestour',
    'Tourguideabk.',
    'Highlight',
  ];

  // fields for text and html output
  static const List<String> textOutput = [
    'Titel',
    'Kurzbeschreibung',
    'Beschreibung',
    'Start',
    'Treffpunkt',
    '2. Treffpunkt',
    'Tourenleitung',
    'Länge',
    'Geschwindigkeit',
    'Geschwindigkeitsbereich',
    'Bergig',
    'Höhenbewertung',
    'Schwierigkeit',
    'Anmeldung',
    'Mehrtagestour',
    'Ende'
  ];
}

enum AdditionalFields { registration, multidayTour, tourGuideAbbrev, highlight }

// Tour guides ADFC Garbsen/Seelze
const Map<String, String> tourGuidesAbbrev = {
  'Bastian Moll': 'BM',
  'Karl-Heinz Giese': 'KG',
  'Jürgen Oschlies': 'JO',
  'Manfred Kern': ' MKe',
  'Monika Unger': 'MU',
  'Fam. Münkel': 'MUE',
  'Familie Münkel': 'MUE',
  'Silvia Rohrsen-Münkel': 'MUE',
  'Peter Germeroth': 'PG',
  'Roswitha Gockeln': 'RG',
  'Siegfried Tönnies': 'ST',
  'Werner Meyer': 'WM'
};

enum FileType { csv, txt, html, console }

const List<String> nameOfWeekDays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
