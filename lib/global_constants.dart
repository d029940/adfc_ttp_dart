const String defaultTourGuide = 'ADFC Garbsen/Seelze';

// Characteristics of a tour
const int speedThreshold = 18; // up to 18km/h normal, above fast
const List<String> normalSpeed = ['15 - 18 km/h'];
const int altitudeThreshold = 300; // up to 300Hm normal, above mountainous
const List<String> mountainous = ["hügelig", "bergig"];

class Csv {
  static const fieldDelimiter = ';';

  // relevant Fields of the input csv file
  static const titleField = 3;
  static const shortDescriptionField = 4;
  static const descriptionField = 5;
  static const startDateField = 11;
  static const startTimeField = 12;
  static const endDateField = 13;
  static const organizerField = 26;
  static const lengthField = 32;
  static const speedField = 33;
  static const int altitudeDescField = 34;
  static const altitudeField = 35;
  static const int speedDescField = 37;
  static const difficultyField = 39;
  static const streetField = 40;
  static const cityField = 41;

  // Process relevant input fields
  static const List<int> headerNamesCsvInput = [
    titleField, // Titel
    shortDescriptionField, // Kurzbeschreibung
    descriptionField, // Beschreibung
    startDateField, // Datum
    startTimeField, // Zeit
    endDateField, // Ende'
    organizerField, // Organisator
    lengthField, // Länge
    speedField, // Geschwindigkeit
    altitudeDescField, // "öhenbewertung
    altitudeField, // Höhenmeter
    speedDescField, // Geschwindigkeitsbereich
    difficultyField, // Schwierigkeitsgrad
    cityField, // Stadt
    streetField, // Strasse
  ];

  // Output csv field
  static const List<String> headerNamesCsvOutput = [
    'Titel',
    'Kurzbeschreibung',
    'Beschreibung',
    'Beginn Datum',
    'Beginn Zeit',
    'Ende Datum',
    'Organisator',
    'Länge',
    'Geschwindigkeit',
    'Höhenbewertung',
    'Bergig',
    'Geschwindigkeitsbereich',
    'Schwierigkeit',
    'Strasse',
    'Stadt',
    'Tourenleitung',
    'Anmeldung',
    'Mehrtagestour',
    // 'Beginn Wochentag',
    // 'Ende Wochentag'
  ];
}

// Output csv field: sequence must match csv output fields
enum OutFields {
  title,
  shortDescription,
  description,
  startDate,
  startTime,
  endDate,
  organizer,
  length,
  speed,
  altitudeDescr,
  altitude,
  speedDescField,
  difficulty,
  street,
  city,
  tourGuide,
  registration,
  multipleDays,
  // NOTE: Update tour::printProcess if last field has been changed
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
