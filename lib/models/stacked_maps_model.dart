import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/models/place.dart';

class StackedMapsModel extends ChangeNotifier {
  static LatLng sydneyLocation = const LatLng(-33.8698439, 151.2082848);
  static LatLng barcelonaLocation = const LatLng(41.3828939, 2.1774322);
  static String barcelonaName = 'Barcelona';
  static String sydneyName = 'Sydney';
  static double initialOpacity = 0.3;
  static double halfOpacity = 0.5;
  static double opaque = 1.0;
  static double defaultZoom = 11.0;
  static Color colorRed = Colors.red;
  static Color colorBlue = Colors.blue;
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
  Color _frontPlaceBoundaryColor = colorRed;
  Color _backPlaceBoundaryColor = colorBlue;
  Place _frontPlace = Place(<String, dynamic>{
    'name': barcelonaName,
    'lat': barcelonaLocation.latitude.toString(),
    'lon': barcelonaLocation.longitude.toString(),
    'osm_id': '347950',
    'osm_type': 'relation',
  });
  Place _backPlace = Place(<String, dynamic>{
    'name': sydneyName,
    'lat': sydneyLocation.latitude.toString(),
    'lon': sydneyLocation.longitude.toString(),
    'osm_id': '5750005',
    'osm_type': 'relation',
  });

  bool get updateFrontMap => _updateFrontMap;
  bool get updateBackMap => _updateBackMap;
  double get opacity => _opacity;
  LatLng get frontPlaceLocation => LatLng(_frontPlace.lat, _frontPlace.lng);
  LatLng get backPlaceLocation => LatLng(_backPlace.lat, _backPlace.lng);
  String get frontPlaceName => _frontPlace.name;
  String get backPlaceName => _backPlace.name;
  Color get frontPlaceBoundaryColor => _frontPlaceBoundaryColor;
  Color get backPlaceBoundaryColor => _backPlaceBoundaryColor;
  Place get frontPlace => _frontPlace;
  Place get backPlace => _backPlace;

  set frontPlace(Place place) => _frontPlace = place;
  set backPlace(Place place) => _backPlace = place;

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

  set frontPlaceBoundaryColor(Color color) {
    _frontPlaceBoundaryColor = color;
    notifyListeners();
  }

  set backPlaceBoundaryColor(Color color) {
    _backPlaceBoundaryColor = color;
    notifyListeners();
  }
}
