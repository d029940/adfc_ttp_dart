import 'dart:io';
import 'package:adfc_ttp/all_tours.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import 'tour_record.dart';

class ParseXml {
  ParseXml(File file) {
    final AllTours _tours = AllTours(file);
    final contentAsXml = XmlDocument.parse(file.readAsStringSync());

    // TODO: Catch XmlException
    // Async version
    // final contentAsString = await file.readAsString();
    // final contentAsXml = XmlDocument.parse(contentAsString);

    final tours =
        contentAsXml.xpath('/ExportEventItemList/EventItems/ExportEventItem');
    for (var tour in tours) {
      final title = tour.getElement('Title')?.innerText ?? '*** No Title ***';
      final description =
          tour.getElement('Description')?.innerText ?? '*** No Description ***';
      final shortDescription =
          tour.getElement('CShortDescription')?.innerText ??
              '*** No CShortDescription ***';
      final organizer =
          tour.getElement('Organizer')?.innerText ?? '*** No Organizer ***';
      final lengthKm = tour.getElement('CTourLengthKm')?.innerText ??
          '*** No CTourLengthKm ***';
      final speed = tour.getElement('CTourSpeedKmh')?.innerText ??
          '*** No CTourSpeedKmh ***';
      final difficulty = tour.getElement('CTourDifficulty')?.innerText ??
          '*** No CTourDifficulty ***';
      DateTime? beginning;
      String endDate = '';
      String city = "";
      String street = "";

      final departure = tour.getElement('CDeparture')?.childElements ?? [];
      for (var element in departure) {
        switch (element.name.toString()) {
          case 'Beginning':
            beginning = DateTime.parse(element.innerText);
          case 'EndDate':
            endDate = element.innerText;
          case 'City':
            city = element.innerText;
          case 'Street':
            street = element.innerText;
        }
      }

      String startDate = "00.00.0000";
      String startTime = "00.00";
      if (beginning != null) {
        startDate = '${beginning.day}.${beginning.month}.${beginning.year}';
        startTime = ' ${beginning.hour + 2}:${beginning.minute}';
      }

      final tourRecord = TourRecord(
          title,
          shortDescription,
          organizer,
          description,
          startDate,
          startTime,
          endDate,
          city,
          street,
          lengthKm,
          speed,
          difficulty);
      tourRecord.printTour();
      _tours.add(tourRecord);
    }
  }
}
