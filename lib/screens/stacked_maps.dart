import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/widgets/map.dart';
import 'package:overmap/models/map_model.dart';
import 'package:provider/provider.dart';

class StackedMaps extends StatefulWidget {
  final double frontMapLatitude;
  final double frontMapLongitude;
  final double backMapLatitude;
  final double backMapLongitude;

  const StackedMaps(
      {super.key,
      required this.frontMapLatitude,
      required this.frontMapLongitude,
      required this.backMapLatitude,
      required this.backMapLongitude});

  @override
  State createState() => _StackedMapsState();
}

class _StackedMapsState extends State<StackedMaps> {
  late double _opacity = 0.0;

  late GoogleMapController _frontController;
  late GoogleMapController _backController;

  late CameraPosition _frontCameraPosition =
      CameraPosition(target: LatLng(widget.frontMapLatitude, widget.frontMapLongitude));
  late CameraPosition _backCameraPosition =
      CameraPosition(target: LatLng(widget.backMapLatitude, widget.backMapLongitude));

  get backMap =>
      MapLayer(latLng: _backCameraPosition.target, onMapCreated: backMapCreated(), onCameraMove: backCameraMove());

  get frontMap =>
      MapLayer(latLng: _frontCameraPosition.target, onMapCreated: frontMapCreated(), onCameraMove: frontCameraMove());

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
      MapLayer.zoom(_backController, position);
    };
  }

  switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    MapLayer.setCameraPosition(_frontController, _frontCameraPosition);
    MapLayer.setCameraPosition(_backController, _backCameraPosition);
  }

  stackedMaps(frontMap, backMap) => [
        Opacity(opacity: 1.0, child: backMap),
        Opacity(opacity: (_opacity > 0.5 ? _opacity : 1.0 - _opacity), child: frontMap)
      ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MapModel>(builder: (context, map, child) {
      if ((_opacity > 0.5 && map.opacity <= 0.5) || (_opacity <= 0.5 && map.opacity > 0.5)) {
        switchMaps();
      }
      _opacity = map.opacity;
      return Stack(children: stackedMaps(frontMap, backMap));
    });
  }
}
