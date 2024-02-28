class PlaceAttributes {
  static const literals = (
    lat: 'lat',
    lon: 'lon',
    name: 'name',
    type: 'osm_type',
    id: 'osm_id',
  );

  String name = '';
  double lat = 0.0;
  double lon = 0.0;
  String placeId = '';
}
