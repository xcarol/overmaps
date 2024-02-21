import 'dart:convert';
import 'dart:developer';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _googleMapsSearchUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input={SEARCH}&key={KEY}';
  static const String _googleMapsPlaceUrl =
      'https://maps.googleapis.com/maps/api/place/details/json?placeid={PLACE_ID}&key={KEY}';

  static const String _osmReverse =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat={LAT}&lon={LON}';

  static const String _osmSearch =
      'https://nominatim.openstreetmap.org/search?format=json&{TYPE}={SEARCH}&polygon_kml=1';

  static const response = (status: 'status', result: 'result', ok: 'OK');

  final String googleMapsApiKey;

  PlacesService({required this.googleMapsApiKey});

  Future<dynamic> searchPlaces(String search) async {
    try {
      final response = await http.get(Uri.parse(_googleMapsSearchUrl
          .replaceFirst('{SEARCH}', search)
          .replaceFirst('{KEY}', googleMapsApiKey)));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la sol·licitud: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e \nIt might be due to CORS with Web Browser');
    }
  }

  Future<dynamic> getPlaceDetails(String placeId) async {
    final response = await http.get(Uri.parse(_googleMapsPlaceUrl
        .replaceFirst('{PLACE_ID}', placeId)
        .replaceFirst('{KEY}', googleMapsApiKey)));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la sol·licitud: ${response.statusCode}');
    }
  }

  List<String> getPolygonFromPlace(Map<String, dynamic> poligon) {
    if (poligon['geokml'] != null) {
      List<String> polygonCoordinates = [];

      XmlDocument geokml = XmlDocument.parse(poligon['geokml']);
      Iterable<XmlElement> coordinatesElements =
          geokml.findAllElements('coordinates');

      for (XmlElement element in coordinatesElements) {
        polygonCoordinates.add(element.innerText);
      }

      return polygonCoordinates;
    }

    return [];
  }

  Future<Map<String, dynamic>> getPlaceByMunicipality(String place,
      String municipality, double latitude, double longitude) async {
    final response = await http.get(Uri.parse(_osmSearch
        .replaceFirst('{TYPE}', municipality)
        .replaceFirst('{SEARCH}', place)));

    if (response.statusCode == 200) {
      List places = json.decode(response.body);
      if (places.length == 1) {
        var x = places.firstOrNull;
        return x;
      } else {
        Map<String, dynamic> tentativePlace;
        String latstr = latitude.toString();
        String lngstr = longitude.toString();
        for (tentativePlace in places) {
          if (tentativePlace['lat'] == latstr &&
              tentativePlace['lon'] == lngstr) {
            return tentativePlace;
          }
          if (tentativePlace['boundingbox'] != null &&
              tentativePlace['boundingbox'].runtimeType == List &&
              tentativePlace['boundingbox'].length == 4) {
            if (double.parse(latstr) >=
                    double.parse(tentativePlace['boundingbox'][0]) &&
                double.parse(latstr) <=
                    double.parse(tentativePlace['boundingbox'][1]) &&
                double.parse(lngstr) >=
                    double.parse(tentativePlace['boundingbox'][2]) &&
                double.parse(lngstr) <=
                    double.parse(tentativePlace['boundingbox'][3])) {
              return tentativePlace;
            }
          }
        }
        return <String, dynamic>{};
      }
    } else {
      throw Exception('Error en la sol·licitud: ${response.statusCode}');
    }
  }

  String getPlaceMunicipality(String placeName, Map<String, dynamic> address) {
    MapEntry entry;
    List municipalities = ['town', 'city', 'county'];

    for (entry in address.entries) {
      String municipality = entry.key;
      String name = entry.value;

      if (municipalities.contains(municipality) && name.contains(placeName)) {
        return municipality;
      }
    }

    return '';
  }

  Future<Map<String, dynamic>> getPlaceFromCoordinates(
      String place, double lat, double lng) async {
    var client = http.Client();

    final response = await client.get(Uri.parse(_osmReverse
        .replaceFirst('{LAT}', lat.toString())
        .replaceFirst('{LON}', lng.toString())));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la sol·licitud: ${response.statusCode}');
    }
  }

  Future<List<String>> getPlaceBoundaryPolygons(
      String place, double lat, double lng) async {
    Map<String, dynamic> placeData =
        await getPlaceFromCoordinates(place, lat, lng);

    String municipality = getPlaceMunicipality(place, placeData['address']);

    if (municipality.isNotEmpty) {
      Map<String, dynamic> poligon =
          await getPlaceByMunicipality(place, municipality, lat, lng);
      return getPolygonFromPlace(poligon);
    }

    return [];
  }
}
