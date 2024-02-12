import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _googleMapsSearchUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input={SEARCH}&key={KEY}';
  static const String _googleMapsPlaceUrl =
      'https://maps.googleapis.com/maps/api/place/details/json?placeid={PLACE_ID}&key={KEY}';

  static const String _osmReverse =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat={LAT}&lon={LON}&polygon_kml=1';

  static const String _osmSearch =
      'https://nominatim.openstreetmap.org/search?{TYPE}={SEARCH}&format=json&polygon_kml=1';

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

  Future<dynamic> getPlacePolygon(double lat, double lng) async {
    final response = await http.get(Uri.parse(_osmReverse
        .replaceFirst('{LAT}', lat.toString())
        .replaceFirst('{LON}', lng.toString())));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la sol·licitud: ${response.statusCode}');
    }
  }
}
