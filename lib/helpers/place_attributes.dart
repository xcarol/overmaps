class PlaceLocation {
  double lat = 0.0;
  double lng = 0.0;
}

class PlaceAttributes {
  static const literals = (
    lat: 'lat',
    lng: 'lng',
    name: 'name',
    geometry: 'geometry',
    location: 'location',
    placeId: 'place_id',
  );

  String id = '';
  String name = '';
  PlaceLocation location = PlaceLocation();
}
