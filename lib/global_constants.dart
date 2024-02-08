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

enum CsvInputField {
  title(3, 'Titel'),
  shortDescription(4, 'Kurzbeschreibung'),
  description(5, 'Beschreibung'),
  startDate(11, 'Beginndatum'),
  startTime(12, 'Beginnzeit'),
  endDate(13, 'Endedatum'),
  tourGuide(26, 'Tourguide'),
  length(32, 'Länge'),
  speed(33, 'Geschwindigkeit'),
  altitudeDesc(34, 'Höhenbewertung'),
  altitude(35, 'Höhenmeter'),
  speedDesc(37, 'Geschwindigkeitsbereich'),
  difficulty(39, 'Schwierigkeitsgrad'),
  street(40, 'Strasse'),
  city(41, 'Stadt'),
  nextStreet(67, 'Zwischenstation 1 - Strasse'),
  nextCity(68, 'Zwischenstation 1 - Stadt');

  final int number;
  final String text;
  const CsvInputField(this.number, this.text);
}

/// All related constants for parsing csv file
class Csv {
  static const fieldDelimiter = ';';

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
