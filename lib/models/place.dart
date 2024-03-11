import 'package:overmaps/helpers/place_attributes.dart';

// This class is based on Nomatim
// https://nominatim.org/release-docs/develop/api/Overview/
//
// It mostly relies on this API, so name, lat, lon, osm_id & osm_tye as defined
// in place_attributes.dart are assumed to be always set.

// Follow prefixes are defined in the API at
// https://nominatim.org/release-docs/develop/api/Lookup/

var preffixes = {
  'way': 'W',
  'node': 'N',
  'relation': 'R',
};

class Place {
  final PlaceAttributes _attributes = PlaceAttributes();

  Place(PlaceAttributes attributes) {
    _attributes.copyFrom(attributes);
  }

  Place.osm(Map<String, dynamic> osmDetails) {
    _attributes.name = osmDetails[PlaceAttributes.literals.name] ?? '';
    _attributes.latitude =
        double.parse(osmDetails[PlaceAttributes.literals.latitude] ?? '0.0');
    _attributes.longitude =
        double.parse(osmDetails[PlaceAttributes.literals.longitude] ?? '0.0');
    _attributes.placeId = getPlaceId(osmDetails);
  }

  String serialize() {
    return _attributes.encode();
  }

  static Place deserialize(String serializedPlace) {
    return Place(PlaceAttributes.decode(serializedPlace));
  }

  String getPlaceId(Map<String, dynamic> osmDetails) {
    if (osmDetails[PlaceAttributes.literals.osmId] == null) {
      return '';
    }

    String prefix = '';
    preffixes.forEach((key, value) {
      if (osmDetails[PlaceAttributes.literals.osmType] == key) {
        prefix = value;
      }
    });

    return prefix + osmDetails[PlaceAttributes.literals.osmId].toString();
  }

  get lat => _attributes.latitude;
  get lon => _attributes.longitude;
  get name => _attributes.name;
  get placeId => _attributes.placeId;

  set lat(lat) => _attributes.latitude = lat;
  set lon(lon) => _attributes.longitude = lon;
  set name(name) => _attributes.name = name;
  set placeId(placeId) => _attributes.placeId = placeId;
}
