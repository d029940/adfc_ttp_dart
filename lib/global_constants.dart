const String defaultTourGuide = 'ADFC Garbsen/Seelze';

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
  static const difficultyField = 39;
  static const streetField = 40;
  static const cityField = 41;

  // Process relevant input fields
  static const Map<int, String> headerNamesCsvInput = {
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

  // Output csv field
  static const List<String> headerNamesCsvOutput = [
    'Titel',
    'Kurzbeschreibung',
    'Beschreibung',
    'Beginn Datum',
    'Beginn Zeit',
    'Ende Datum',
    // 'Ende Zeit',
    'Organisator',
    'Länge',
    'Schwierigkeit',
    'Strasse',
    'Stadt',
    'Tourenleitung',
    'Anmeldung',
    'Mehrtagestour',
    'Beginn Wochentag',
    'Ende Wochentag'
  ];
}

// Output csv field
enum OutFields {
  title,
  shortDescription,
  description,
  startDate,
  startTime,
  endDate,
  //    EndTime,
  organizer,
  length,
  difficulty,
  street,
  city,
  tourGuide,
  registration,
  multipleDays,
  startDay,
  endDay // NOTE: Update tour::printProcess if last field has been changed
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
