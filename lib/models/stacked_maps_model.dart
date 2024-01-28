import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StackedMapsModel extends ChangeNotifier {
  static LatLng barcelonaLocation = const LatLng(-33.85999989127037, 151.1999999731779);
  static LatLng sydneyLocation = const LatLng(41.447178768107136, 2.1920866146683693);
  static String barcelonaName = "Barcelona";
  static String sydneyName = "Sydney";
  static double halfOpacity = 0.5;
  static double opaque = 1.0;
  static double defaultZoom = 11.0;

  bool updateFrontMapLocation = false;
  bool updateBackMapLocation = false;

  double _opacity = halfOpacity;
  LatLng _frontPlaceLocation = sydneyLocation;
  LatLng _backPlaceLocation = barcelonaLocation;
  String _frontPlaceName = sydneyName;
  String _backPlaceName = barcelonaName;

  double get opacity => _opacity;
  LatLng get frontPlaceLocation => _frontPlaceLocation;
  LatLng get backPlaceLocation => _backPlaceLocation;
  String get frontPlaceName => _frontPlaceName;
  String get backPlaceName => _backPlaceName;

  set opacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }

  set frontPlaceLocation(LatLng location) {
    _frontPlaceLocation = location;
    notifyListeners();
  }

  set backPlaceLocation(LatLng location) {
    _backPlaceLocation = location;
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
