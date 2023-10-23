import 'dart:io';
import 'package:adfc_ttp/all_tours.dart';
import 'package:adfc_ttp/parse_csv.dart';
// import 'package:adfc_ttp/parse_xml.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  if (arguments.length != 1) {
    stderr
        .writeln('Aufruf: dart ${p.basename(Platform.script.path)} csv-Datei');
    exit(1);
  }

  File file = File(arguments.first);
  // final ParseXml parseXml = ParseXml(file);

  AllTours tours = AllTours(file);

  final ParseCsv parseCsv = ParseCsv(file, tours);
  tours.printTours();
  await tours.writeCsFile();
  await tours.writeTextFile();
  await tours.writeHtmlFile();

  exit(0);
}
