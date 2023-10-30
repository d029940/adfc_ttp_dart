const String defaultTourGuide = 'ADFC Garbsen/Seelze';

// Characteristics of a tour
const int speedThreshold = 18; // up to 18km/h normal, above fast
const List<String> normalSpeed = ['15 - 18 km/h'];
const int altitudeThreshold = 300; // up to 300Hm normal, above mountainous
const List<String> mountainous = ["hügelig", "bergig"];

class Csv {
  static const fieldDelimiter = ';';

  // relevant Fields of the input csv file
  static const titleField = 3; // Titel
  static const shortDescriptionField = 4; // Kurzbeschreibung
  static const descriptionField = 5; // Beschreibung
  static const startDateField = 11; // Beginndatum
  static const startTimeField = 12; // Zeit
  static const endDateField = 13; // Endedatum
  static const organizerField = 26; // Organisator
  static const lengthField = 32; // Länge
  static const speedField = 33; // Geschwindigkeit
  static const altitudeDescField = 34; // Höhenbewertung
  static const altitudeField = 35; // Höhenmeter
  static const speedDescField = 37; // Geschwindigkeitsbereich
  static const difficultyField = 39; // Schwierigkeitsgrad
  static const streetField = 40; // Strasse
  static const cityField = 41; // Stadt

  // Process relevant input fields
  static const List<int> headerNamesCsvInput = [
    titleField,
    shortDescriptionField,
    descriptionField,
    startDateField,
    startTimeField,
    endDateField,
    organizerField,
    lengthField,
    speedField,
    altitudeDescField,
    altitudeField,
    speedDescField,
    difficultyField,
    cityField,
    streetField,
  ];

  // Output csv field
  static const List<String> headerNamesCsvOutput = [
    'Titel',
    'Kurzbeschreibung',
    'Beschreibung',
    'Beginn Datum',
    'Beginn Zeit',
    'Ende Datum',
    'Tourenleitung',
    'Länge',
    'Geschwindigkeit',
    'Geschwindigkeitsbereich',
    'Bergig',
    'Höhenbewertung',
    'Schwierigkeit',
    'Stadt',
    'Strasse',
    'Anmeldung',
    'Mehrtagestour'
  ];
}

// Tourguides ADFC Garbsen/Seeze
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
