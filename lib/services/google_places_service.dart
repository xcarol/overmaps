import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  static const String _searchUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input={SEARCH}&key={KEY}';
  static const String _placeUrl =
      'https://maps.googleapis.com/maps/api/place/details/json?placeid={PLACE_ID}&key={KEY}';
  static const response = (status: 'status', result: 'result', ok: 'OK');

  final String mapsApiKey;

  GooglePlacesService({required this.mapsApiKey});

  Future<dynamic> searchPlaces(String search) async {
    try {
      final response =
          await http.get(Uri.parse(_searchUrl.replaceFirst('{SEARCH}', search).replaceFirst('{KEY}', mapsApiKey)));

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
    final response =
        await http.get(Uri.parse(_placeUrl.replaceFirst('{PLACE_ID}', placeId).replaceFirst('{KEY}', mapsApiKey)));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la sol·licitud: ${response.statusCode}');
    }
  }
}
