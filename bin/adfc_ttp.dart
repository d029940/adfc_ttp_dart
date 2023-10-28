import 'dart:io';
import 'package:adfc_ttp/all_tours.dart';
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
  await tours.printTours();

  exit(0);
}
