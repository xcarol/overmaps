// This class is based on Nomatim attributes documentation
// https://nominatim.org/release-docs/develop/api/Overview/

class PlaceAttributes {
  static const literals = (
    latitude: 'lat',
    longitude: 'lon',
    name: 'name',
    id: 'osm_id',
    type: 'osm_type',
  );

  String name = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String placeId = '';
  String osmId = '';
  String osmType = '';
}
