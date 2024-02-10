Command line app which extracts information from a previously downloaded csv file from the ADFC-Termin und Tourenportal (TTP).
```
Usage: ttp <csv file from TTP> (<txt file for highlighting tours>)
```

Following data of a tour is  provided:
- title
- short description
- description
- begin date and end date of a tour
- tour guide
- length
- speed
- speed description
- altitude description
- altitude
- difficulty
- registration flag
- multi-day-tour flag

The information is provided as
- a html file
- a text file
- csv file (separated by colons)


The txt file indication the tours to be highlighted, consists of number of tours (starting from 2, since 1 is reserved for the csv heading). The tour numbers are separated by ```,```. Every indicated tour will be highlighted in the html output. 

-------------- German version -------------------------

Kommandozeilenprogramm, welches Informationen aus einer zuvor aus dem ADFC Termin- und Tourenportal (TTP( heruntergeladene CSV-Datei extrahiert.

```
Aufruf: ttp  <CSV-Datei aus dem TTP> (<Txt-Datei zum Hervorheben von Touren>)
```

Folgende Informationen pro Tour werden in eine Semikolon-separierte Liste ausgegeben:

- Name der Tour
- Kurzbeschreibung
- Beschreibung
- Beginn und Ende der Tour
- Tourleiter / Organisators
- Länge
- Geschwindigkeit
- Geschwindigkeitsklassifizierung
- Höhenbewertung
- Höhenmeter
- Schwierigkeitsgrad
- Anmeldung-Kz
- Mehrtagestour-Kz

Die Informationen werden Semikolon-separiert in eine CVS Datei mit dem gleichen Dateinamen geschrieben. Der Ausgabedateiname enthält die Endung "csv". Ebenso wird eine Textdatei mit der Endung "txt" und eine HTML-Datei erstellt.


Die Txt-Datei, um Touren hervorzuben, besteht aus einer Datei, die Touren-Nr. 
(von 2 beginnend - Zeile 1 ist die Überschrift - bis zur Anzahl der Touren) enthält.
Die Tourennummern werden durch Komma, Semikolon bzw. Leerzeichen voneinander getrennt.
Jede mit der Nr. identifizierte Tour wird in der html-Datei hervorgehoben.
