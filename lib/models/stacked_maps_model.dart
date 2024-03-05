import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/models/place.dart';

class StackedMapsModel extends ChangeNotifier {
  static LatLng barcelonaLocation = const LatLng(41.3828939, 2.1774322);
  static String barcelonaName = 'Barcelona';
  static String barcelonaOsmId = '347950';
  static String barcelonaOsmType = 'relation';

  static LatLng sydneyLocation = const LatLng(-33.8698439, 151.2082848);
  static String sydneyName = 'Sydney';
  static String sydneyOsmId = '5750005';
  static String sydneyOsmType = 'relation';

  static Color colorBlue = Colors.blue;
  static Color colorRed = Colors.red;
  static double defaultZoom = 11.0;
  static double halfOpacity = 0.5;
  static double initialOpacity = 0.3;
  static double opaque = 1.0;

  static PolylineId frontPlacePolylineId = const PolylineId(
    'frontPlacePolylineId',
  );
  static PolylineId backPlacePolylineId = const PolylineId(
    'backPlacePolylineId',
  );

  static MarkerId frontPlaceMarkerId = const MarkerId(
      'frontPlaceMarkerId',
  );
  static MarkerId backPlaceMarkerId = const MarkerId(
      'backPlaceMarkerId',
  );

  double _opacity = initialOpacity;
  bool _updateFrontMap = false;
  bool _updateBackMap = false;
  Color _frontPlaceBoundaryColor = colorRed;
  Color _backPlaceBoundaryColor = colorBlue;

  Place frontPlace = Place(<String, dynamic>{
    'name': barcelonaName,
    'lat': barcelonaLocation.latitude.toString(),
    'lon': barcelonaLocation.longitude.toString(),
    'osm_id': barcelonaOsmId,
    'osm_type': barcelonaOsmType,
  });

  Place backPlace = Place(<String, dynamic>{
    'name': sydneyName,
    'lat': sydneyLocation.latitude.toString(),
    'lon': sydneyLocation.longitude.toString(),
    'osm_id': sydneyOsmId,
    'osm_type': sydneyOsmType,
  });

  double get opacity => _opacity;
  bool get updateFrontMap => _updateFrontMap;
  bool get updateBackMap => _updateBackMap;
  Color get frontPlaceBoundaryColor => _frontPlaceBoundaryColor;
  Color get backPlaceBoundaryColor => _backPlaceBoundaryColor;

  set updateFrontMap(bool? anyvalue) {
    _updateFrontMap = true;
  }
  set updateBackMap(bool? anyvalue) => _updateBackMap = true;

  set opacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }

  set frontPlaceBoundaryColor(Color color) {
    _frontPlaceBoundaryColor = color;
    notifyListeners();
  }

  set backPlaceBoundaryColor(Color color) {
    _backPlaceBoundaryColor = color;
    notifyListeners();
  }

  resetUpdateFrontMap() {
    _updateFrontMap = false;
  }

  resetUpdateBackMap() {
    _updateBackMap = false;
  }
}
