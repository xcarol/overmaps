import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:overmaps/models/place.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

const String _osmSearchPlace =
    'https://nominatim.openstreetmap.org/search?format=json&accept-language={LANG}&q={SEARCH}&limit=10';

const String _osmSearchDetails =
    'https://nominatim.openstreetmap.org/lookup?format=json&osm_ids={OSM_ID}&polygon_kml=1';

class PlacesService {
  String acceptedLanguages(String currentLocale) {
    String languages = '$currentLocale,';
    List<Locale> locales = AppLocalizations.supportedLocales;

    for (Locale locale in locales) {
      languages += '${locale.languageCode};q=0.5,';
    }

    return languages;
  }

  Future<dynamic> searchPlaces(
    String search,
    String currentLocale,
  ) async {
    if (search.trim().isEmpty) {
      return [];
    }

    Uri searchPlaceUri = Uri.parse(
      _osmSearchPlace
          .replaceFirst('{LANG}', acceptedLanguages(currentLocale))
          .replaceFirst('{SEARCH}', search),
    );
    final response = await http.get(searchPlaceUri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Exception exception = Exception(
        [
          'searchPlaces',
          'Error: ${response.statusCode} for the request of a place search :[${searchPlaceUri.toString()}]',
        ],
      );
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: exception));
      throw exception;
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(
    String osmId,
  ) async {
    Uri placeDetailsUri = Uri.parse(
      _osmSearchDetails.replaceFirst('{OSM_ID}', osmId),
    );
    final response = await http.get(placeDetailsUri);

    if (response.statusCode == 200) {
      List places = json.decode(response.body);
      if (places.length == 1) {
        return places.firstOrNull;
      } else {
        return <String, dynamic>{};
      }
    } else {
      Exception exception = Exception(
        [
          'getPlaceDetails',
          'Error: ${response.statusCode} for the request of a place details: [${placeDetailsUri.toString()}]',
        ],
      );
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: exception));
      throw exception;
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
