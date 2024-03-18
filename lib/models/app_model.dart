import 'package:flutter/material.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const literals = (
  leftPlaceName: 'leftPlaceName',
  rightPlaceName: 'rightPlaceName',
);

class AppModel extends ChangeNotifier {
  late SharedPreferences _preferences;

  void initPreferences(SharedPreferences data) {
    _preferences = data;
    if ((_preferences.getString(literals.leftPlaceName) ?? 'none') == 'none') {
      leftPlaceName = StackedMapsModel.barcelonaName;
      rightPlaceName = StackedMapsModel.sydneyName;
    }
  }

  String get leftPlaceName =>
      _preferences.getString(literals.leftPlaceName) as String;

  String get rightPlaceName =>
      _preferences.getString(literals.rightPlaceName) as String;

  set leftPlaceName(String leftPlaceName) {
    _preferences
        .setString(literals.leftPlaceName, leftPlaceName)
        .then((bool value) {
      notifyListeners();
    });
  }

  set rightPlaceName(String rightPlaceName) {
    _preferences
        .setString(literals.rightPlaceName, rightPlaceName)
        .then((bool value) {
      notifyListeners();
    });
  }
}
