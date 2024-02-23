import 'package:overmap/helpers/place_attributes.dart';

class Place {
  final Map<String, dynamic> details;
  final PlaceAttributes _placeAttributes = PlaceAttributes();

  Place({required this.details}) {
    _placeAttributes.id = details[PlaceAttributes.literals.placeId];

    _placeAttributes.name = details[PlaceAttributes.literals.name] ??
        'ERROR: Retrieving place for placeId: ${details[PlaceAttributes.literals.placeId]}';

    var location = details[PlaceAttributes.literals.geometry]
            ?[PlaceAttributes.literals.location] ??
        {PlaceAttributes.literals.lat: 0.0, PlaceAttributes.literals.lng: 0.0};

    _placeAttributes.location.lat = location['lat'];
    _placeAttributes.location.lng = location['lng'];
  }

  get lat => _placeAttributes.location.lat;
  get lng => _placeAttributes.location.lng;
  get name => _placeAttributes.name;
}
