import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmaps/models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

const literals = (
  showTools: 'showTools',
  zoom: 'zoom',
  opacity: 'opacity',
  frontPlace: 'frontPlace',
  backPlace: 'backPlace',
  frontPlaceBoundaryColor: 'frontPlaceBoundaryColor',
  backPlaceBoundaryColor: 'backPlaceBoundaryColor',
);

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
  static double minZoom = 0.0;
  static double maxZoom = 22.0;

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

  final Place _barcelonaPlace = Place.osm(<String, dynamic>{
    'name': barcelonaName,
    'lat': barcelonaLocation.latitude.toString(),
    'lon': barcelonaLocation.longitude.toString(),
    'osm_id': barcelonaOsmId,
    'osm_type': barcelonaOsmType,
  });

  final Place _sydneyPlace = Place.osm(<String, dynamic>{
    'name': sydneyName,
    'lat': sydneyLocation.latitude.toString(),
    'lon': sydneyLocation.longitude.toString(),
    'osm_id': sydneyOsmId,
    'osm_type': sydneyOsmType,
  });

  bool _updateFrontMap = false;
  bool _updateBackMap = false;
  late SharedPreferences _preferences;

  void initPreferences(SharedPreferences data) {
    _preferences = data;
    if ((_preferences.getString(literals.frontPlace) ?? 'none') ==
        'none') {
      showTools = false;
      zoom = defaultZoom;
      opacity = initialOpacity;
      frontPlace = _barcelonaPlace;
      backPlace = _sydneyPlace;
      frontPlaceBoundaryColor = colorRed;
      backPlaceBoundaryColor = colorBlue;
    }
  }

  bool get showTools =>
      _preferences.getBool(literals.showTools) as bool;

  double get zoom =>
      _preferences.getDouble(literals.zoom) as double;

  double get opacity =>
      _preferences.getDouble(literals.opacity) as double;

  Place get frontPlace {
    return Place.deserialize(
        _preferences.getString(literals.frontPlace) as String);
  }

  Place get backPlace {
    return Place.deserialize(
        _preferences.getString(literals.backPlace) as String);
  }

  Color get frontPlaceBoundaryColor =>
      Color(_preferences.getInt(literals.frontPlaceBoundaryColor) as int);

  Color get backPlaceBoundaryColor =>
      Color(_preferences.getInt(literals.backPlaceBoundaryColor) as int);

  bool get updateFrontMap => _updateFrontMap;
  bool get updateBackMap => _updateBackMap;

  set showTools(bool value) {
    _preferences.setBool(literals.showTools, value).then((bool value) {
      notifyListeners();
    });
  }

  set zoom(double value) {
    _preferences
        .setDouble(literals.zoom, value)
        .then((bool value) {
      notifyListeners();
    });
  }

  set opacity(double opacity) {
    _preferences
        .setDouble(literals.opacity, opacity)
        .then((bool value) {
      notifyListeners();
    });
  }

  set frontPlace(Place place) {
    _preferences
        .setString(literals.frontPlace, place.serialize())
        .then((bool value) => notifyListeners());
  }

  set backPlace(Place place) {
    _preferences
        .setString(literals.backPlace, place.serialize())
        .then((bool value) => notifyListeners());
  }

  set frontPlaceBoundaryColor(Color color) {
    _preferences
        .setInt(literals.frontPlaceBoundaryColor, color.value)
        .then((bool value) => notifyListeners());
  }

  set backPlaceBoundaryColor(Color color) {
    _preferences
        .setInt(literals.backPlaceBoundaryColor, color.value)
        .then((bool value) => notifyListeners());
  }

  set updateFrontMap(bool? anyvalue) {
    _updateFrontMap = true;
  }

  set updateBackMap(bool? anyvalue) {
    _updateBackMap = true;
  }

  void switchMaps() {
    Color copyColor = frontPlaceBoundaryColor;
    frontPlaceBoundaryColor = backPlaceBoundaryColor;
    backPlaceBoundaryColor = copyColor;

    Place copyPlace = frontPlace;
    frontPlace = backPlace;
    backPlace = copyPlace;
  }

  void resetUpdateFrontMap() {
    _updateFrontMap = false;
  }

  void resetUpdateBackMap() {
    _updateBackMap = false;
  }
}
