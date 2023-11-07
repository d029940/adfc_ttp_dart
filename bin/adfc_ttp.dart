import 'dart:io';
import 'package:adfc_ttp/all_tours.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  if (arguments.length > 2) {
    stderr.writeln(
        'Aufruf: dart ${p.basename(Platform.script.path)} <CSV-Datei vom TPP> (<Txt-Highlight-Datei>)');
    exit(1);
  }

  // CSV file
  File csvFile = File(arguments.first);
  // File with tour numbers to be highlighted
  File? highlightFile;
  if (arguments.length == 2) {
    highlightFile = File(arguments[1]);
  }
  // final ParseXml parseXml = ParseXml(file);

  AllTours tours = AllTours(csvFile, highlightFile: highlightFile);
  await tours.printTours();

  exit(0);
}
