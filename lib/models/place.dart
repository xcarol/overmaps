import 'dart:developer';

import 'package:overmap/helpers/place_attributes.dart';

// This class is based on Nomatim attributes documentation
// https://nominatim.org/release-docs/develop/api/Overview/

// https://nominatim.org/release-docs/develop/api/Lookup/

class Place {
  late Map<String, dynamic> details = <String, dynamic>{};
  final PlaceAttributes _placeAttributes = PlaceAttributes();

  Place(this.details) {
    _placeAttributes.name = details[PlaceAttributes.literals.name] ?? '';
    _placeAttributes.lat =
        double.parse(details[PlaceAttributes.literals.lat] ?? '0.0');
    _placeAttributes.lon =
        double.parse(details[PlaceAttributes.literals.lon] ?? '0.0');
    _placeAttributes.placeId = getPlaceId(details);
  }

  get lat => _placeAttributes.lat;
  get lng => _placeAttributes.lon;
  get name => _placeAttributes.name;
  get placeId => _placeAttributes.placeId;

  String getPlaceId(Map<String, dynamic> details) {
    if (details[PlaceAttributes.literals.id] == null) {
      return '';
    }

    String prefix = '';

    var x = {
      'way': 'W',
      'node': 'N',
      'relation': 'R',
    };

    x.forEach((key, value) {
      if (details[PlaceAttributes.literals.type] == key) {
        prefix = value;
      }
    });

    // switch (details[PlaceAttributes.literals.type] ?? '') {
    //   case "WAY":
    //     prefix = 'W';
    //   case "NODE":
    //     prefix = 'N';
    //   case "RELATION":
    //     prefix = 'R';
    // }

    return prefix + details[PlaceAttributes.literals.id];
  }
}
