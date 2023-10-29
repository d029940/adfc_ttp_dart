Command line app which extracts information from a previously downloaded csv file from the ADFC-Termin und Tourenportal (TTP).

Usage: ttp <csv file>

Following data of a tour is  provided:
- title
- short description
- description
- begin date
- end date
- tour guide
- registration
- multi-day-tour

The information is provided as
- a html file
- a text file
- csv file (separated by colons)

Kommandozeilenprogramm, welches Informationen aus einer zuvor aus dem ADFC Termin- und Tourenportal (TTP( heruntergeladene CSV-Datei extrahiert.

Aufruf: ttp <CSV Datei>

Folgende Informationen pro Tour werden in eine Semikolon-separierte Liste ausgegeben:

Name der Tour
Beginn und Ende der Tour
Beschreibung
Tourleiter / Organisators
Länge
Schwierigkeitsgrad
Die Informationen werden Semikolon-separiert in eine CVS Datei mit dem gleichen Dateinamen geschrieben. Der Ausgabedateiname enthält die Endung "csv". Ebenso wird eine Textdatei mit der Endung "txt" und eine HTML-Datei erstellt.
