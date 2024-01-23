import 'package:flutter/material.dart';

class MapModel extends ChangeNotifier {
  double _opacity = 0.5;

  double get opacity => _opacity;

  set opacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }
}
