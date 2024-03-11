// This class is based on Nomatim attributes documentation
// https://nominatim.org/release-docs/develop/api/Overview/

import 'dart:convert';

class PlaceAttributes {
  static const literals = (
    latitude: 'lat',
    longitude: 'lon',
    name: 'name',
    osmId: 'osm_id',
    osmType: 'osm_type',
    placeId: 'place_id',
    displayName: 'display_name',
  );

  String name = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String placeId = '';

  PlaceAttributes();
  PlaceAttributes.fromMap(Map attr) {
    name = attr['name'] ?? '';
    latitude = double.parse(attr['latitude'] ?? '');
    longitude = double.parse(attr['longitude'] ?? '');
    placeId = attr['placeId'] ?? '';
  }

  copyFrom(PlaceAttributes attributtes) {
    name = attributtes.name;
    latitude = attributtes.latitude;
    longitude = attributtes.longitude;
    placeId = attributtes.placeId;
  }

  //TODO: Use dart:convert library json methods
  String encode() {
    return '{'
        '  "name": "$name",'
        '  "latitude": "$latitude",'
        '  "longitude": "$longitude",'
        '  "place_id": "$placeId"'
        '}';
  }

  static decode(String encodedPlace) {
    return PlaceAttributes.fromMap(json.decode(encodedPlace));
  }
}
