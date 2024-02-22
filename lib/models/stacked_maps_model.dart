import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StackedMapsModel extends ChangeNotifier {
  static LatLng sydneyLocation = const LatLng(-33.8698439, 151.2082848);
  static LatLng barcelonaLocation = const LatLng(41.3828939, 2.1774322);
  static String barcelonaName = 'Barcelona';
  static String sydneyName = 'Sydney';
  static double initialOpacity = 0.3;
  static double halfOpacity = 0.5;
  static double opaque = 1.0;
  static double defaultZoom = 11.0;
  static PolylineId frontPlacePolylineId =
      const PolylineId('frontPlacePolylineId');
  static PolylineId backPlacePolylineId =
      const PolylineId('backPlacePolylineId');

  bool _updateFrontMap = false;
  bool _updateBackMap = false;

  double _opacity = initialOpacity;
  LatLng _frontPlaceLocation = barcelonaLocation;
  LatLng _backPlaceLocation = sydneyLocation;
  String _frontPlaceName = barcelonaName;
  String _backPlaceName = sydneyName;

  bool get updateFrontMap => _updateFrontMap;
  bool get updateBackMap => _updateBackMap;
  double get opacity => _opacity;
  LatLng get frontPlaceLocation => _frontPlaceLocation;
  LatLng get backPlaceLocation => _backPlaceLocation;
  String get frontPlaceName => _frontPlaceName;
  String get backPlaceName => _backPlaceName;

  resetUpdateFrontMap() {
    _updateFrontMap = false;
  }

  resetUpdateBackMap() {
    _updateBackMap = false;
  }

  set opacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }

  set frontPlaceLocation(LatLng location) {
    _frontPlaceLocation = location;
    _updateFrontMap = true;
    notifyListeners();
  }

  set backPlaceLocation(LatLng location) {
    _backPlaceLocation = location;
    _updateBackMap = true;
    notifyListeners();
  }

  set frontPlaceName(String name) {
    _frontPlaceName = name;
    notifyListeners();
  }

  set backPlaceName(String name) {
    _backPlaceName = name;
    notifyListeners();
  }
}
