import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/widgets/map.dart';
import 'package:overmap/models/stacked_maps_model.dart';
import 'package:provider/provider.dart';

class StackedMaps extends StatefulWidget {
  const StackedMaps({super.key});

  @override
  State createState() => _StackedMapsState();
}

class _StackedMapsState extends State<StackedMaps> {
  late double _opacity = 0.0;

  GoogleMapController? _frontController;
  GoogleMapController? _backController;

  late CameraPosition _frontCameraPosition = CameraPosition(target: StackedMapsModel.sydneyLocation);
  late CameraPosition _backCameraPosition = CameraPosition(target: StackedMapsModel.barcelonaLocation);

  get backMap =>
      Map(latLng: _backCameraPosition.target, onMapCreated: backMapCreated(), onCameraMove: backCameraMove());

  get frontMap =>
      Map(latLng: _frontCameraPosition.target, onMapCreated: frontMapCreated(), onCameraMove: frontCameraMove());

  double get frontMapOpacity =>
      (_opacity > StackedMapsModel.halfOpacity ? _opacity : StackedMapsModel.opaque - _opacity);

  stackedMaps(frontMap, backMap) =>
      [Opacity(opacity: StackedMapsModel.opaque, child: backMap), Opacity(opacity: frontMapOpacity, child: frontMap)];

  bool needSwitchMaps(StackedMapsModel map) {
    return (_opacity > StackedMapsModel.halfOpacity && map.opacity <= StackedMapsModel.halfOpacity) ||
        (_opacity <= StackedMapsModel.halfOpacity && map.opacity > StackedMapsModel.halfOpacity);
  }

  backMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        _backController = controller;
      });
    };
  }

  backCameraMove() {
    return (CameraPosition position) {
      _backCameraPosition = position;
    };
  }

  frontMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        _frontController = controller;
      });
    };
  }

  frontCameraMove() {
    return (CameraPosition position) {
      _frontCameraPosition = position;
      Map.zoom(_backController, position);
    };
  }

  CameraPosition updateCameraLocation(GoogleMapController? controller, CameraPosition cameraPosition, LatLng location) {
    return CameraPosition(
        target: location, bearing: cameraPosition.bearing, tilt: cameraPosition.tilt, zoom: cameraPosition.zoom);
  }

  updateMap(GoogleMapController controller, CameraPosition position) {
    Map.setCameraPosition(controller, position);
  }

  switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    Map.setCameraPosition(_frontController, _frontCameraPosition);
    Map.setCameraPosition(_backController, _backCameraPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StackedMapsModel>(builder: (context, map, child) {
      if (needSwitchMaps(map)) {
        switchMaps();
      }

      if (map.updateFrontMapLocation) {
        _frontCameraPosition = updateCameraLocation(_frontController, _frontCameraPosition, map.frontPlaceLocation);
        updateMap(_frontController!, _frontCameraPosition);
        map.updateFrontMapLocation = false;
      }

      if (map.updateBackMapLocation) {
        _backCameraPosition = updateCameraLocation(_backController, _backCameraPosition, map.backPlaceLocation);
        updateMap(_backController!, _backCameraPosition);
        map.updateBackMapLocation = false;
      }

      _opacity = map.opacity;
      return Stack(children: stackedMaps(frontMap, backMap));
    });
  }
}
