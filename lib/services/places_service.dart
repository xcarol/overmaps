import 'dart:convert';
import 'package:overmaps/models/place.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

const String _osmSearchPlace =
    'https://nominatim.openstreetmap.org/search?format=json&q={SEARCH}';

const String _osmSearchDetails =
    'https://nominatim.openstreetmap.org/lookup?format=json&osm_ids={OSM_ID}&polygon_kml=1';

class PlacesService {
  Future<dynamic> searchPlaces(
    String search,
  ) async {
    final response = await http.get(Uri.parse(
      _osmSearchPlace.replaceFirst('{SEARCH}', search),
    ));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Error: ${response.statusCode} for a request of a place search');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(
    String osmId,
  ) async {
    final response = await http.get(Uri.parse(
      _osmSearchDetails.replaceFirst('{OSM_ID}', osmId),
    ));

    if (response.statusCode == 200) {
      List places = json.decode(response.body);
      if (places.length == 1) {
        return places.firstOrNull;
      } else {
        return <String, dynamic>{};
      }
    } else {
      throw Exception(
        'Error: ${response.statusCode} for a request of a place details',
      );
    }
  }

  List<String> getPlacePolygon(
    Map<String, dynamic> poligon,
  ) {
    List<String> polygonCoordinates = [];

    XmlDocument geokml =
        XmlDocument.parse(poligon['geokml'] ?? '<root></root>');

    for (XmlElement element in geokml.findAllElements('coordinates')) {
      polygonCoordinates.add(element.innerText);
    }

    return polygonCoordinates;
  }

  Future<List<String>> getPlaceBoundaryPolygons(
    Place place,
  ) async {
    return getPlacePolygon(await getPlaceDetails(place.placeId));
  }
}
