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
    name = attr[PlaceAttributes.literals.name] ?? '';
    latitude = double.parse(attr[PlaceAttributes.literals.latitude] ?? '');
    longitude = double.parse(attr[PlaceAttributes.literals.longitude] ?? '');
    placeId = attr[PlaceAttributes.literals.placeId] ?? '';
  }

  copyFrom(PlaceAttributes attributtes) {
    name = attributtes.name;
    latitude = attributtes.latitude;
    longitude = attributtes.longitude;
    placeId = attributtes.placeId;
  }

  String encode() {
    return '{'
        '  "${PlaceAttributes.literals.name}": "$name",'
        '  "${PlaceAttributes.literals.latitude}": "$latitude",'
        '  "${PlaceAttributes.literals.longitude}": "$longitude",'
        '  "${PlaceAttributes.literals.placeId}": "$placeId"'
        '}';
  }

  static decode(String encodedPlace) {
    return PlaceAttributes.fromMap(json.decode(encodedPlace));
  }
}
