import 'package:overmap/helpers/place_attributes.dart';

// This class is based on Nomatim attributes documentation
// https://nominatim.org/release-docs/develop/api/Overview/
//
// It mostly rely on this API, so name, lat, lon, osm_id & osm_tye as defined
// in place_attributes.dart are assumed to be always set.

// Prefixes are defined in the API at
// https://nominatim.org/release-docs/develop/api/Lookup/

var preffixes = {
  'way': 'W',
  'node': 'N',
  'relation': 'R',
};

class Place {
  late Map<String, dynamic> details = <String, dynamic>{};
  final PlaceAttributes _placeAttributes = PlaceAttributes();

  Place(this.details) {
    _placeAttributes.name = details[PlaceAttributes.literals.name] ?? '';
    _placeAttributes.latitude =
        double.parse(details[PlaceAttributes.literals.latitude] ?? '0.0');
    _placeAttributes.longitude =
        double.parse(details[PlaceAttributes.literals.longitude] ?? '0.0');
    _placeAttributes.placeId = getPlaceId(details);
  }

  get lat => _placeAttributes.latitude;
  get lng => _placeAttributes.longitude;
  get name => _placeAttributes.name;
  get placeId => _placeAttributes.placeId;

  set lat(lat) => _placeAttributes.latitude = lat;
  set lng(lng) => _placeAttributes.longitude = lng;
  set name(name) => _placeAttributes.name = name;
  set placeId(placeId) => _placeAttributes.placeId = placeId;

  String getPlaceId(Map<String, dynamic> details) {
    if (details[PlaceAttributes.literals.id] == null) {
      return '';
    }

    String prefix = '';
    preffixes.forEach((key, value) {
      if (details[PlaceAttributes.literals.type] == key) {
        prefix = value;
      }
    });

    return prefix + details[PlaceAttributes.literals.id].toString();
  }
}
