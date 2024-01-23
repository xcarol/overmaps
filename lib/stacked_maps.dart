import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/map.dart';

class StackedMaps extends StatefulWidget {
  final double frontMapLatitude;
  final double frontMapLongitude;
  final double backMapLatitude;
  final double backMapLongitude;
  final double opacity;

  final Completer<GoogleMapController> _frontController = Completer<GoogleMapController>();
  final Completer<GoogleMapController> _backController = Completer<GoogleMapController>();

  static double _opacity = 0.5;

  StackedMaps(
      {super.key,
      required this.frontMapLatitude,
      required this.frontMapLongitude,
      required this.backMapLatitude,
      required this.backMapLongitude,
      required this.opacity}) {
    // if ((opacity > 0.5 && _opacity <= 0.5) || (opacity <= 0.5 && _opacity > 0.5)) {
    //   switchMaps();
    // }
    StackedMaps._opacity = opacity;
  }

  // switchMaps() {
  //   CameraPosition copyCameraPosition = _frontCameraPosition;
  //   _frontCameraPosition = _backCameraPosition;
  //   _backCameraPosition = copyCameraPosition;

  //   MapLayer.setCameraPosition(widget._frontController, _frontCameraPosition);
  //   MapLayer.setCameraPosition(widget._backController, _backCameraPosition);
  // }

  @override
  State createState() => _StackedMapsState();
}

class _StackedMapsState extends State<StackedMaps> {
  late CameraPosition _frontCameraPosition =
      CameraPosition(target: LatLng(widget.frontMapLatitude, widget.frontMapLatitude));
  late CameraPosition _backCameraPosition =
      CameraPosition(target: LatLng(widget.backMapLatitude, widget.backMapLatitude));

  get backMap =>
      MapLayer(latLng: _backCameraPosition.target, onMapCreated: backMapCreated(), onCameraMove: backCameraMove());

  get frontMap =>
      MapLayer(latLng: _frontCameraPosition.target, onMapCreated: frontMapCreated(), onCameraMove: frontCameraMove());

  backMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        widget._backController.complete(controller);
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
        widget._frontController.complete(controller);
      });
    };
  }

  frontCameraMove() {
    return (CameraPosition position) {
      _frontCameraPosition = position;
      widget._backController.future.then((controller) => MapLayer.zoom(controller, position));
    };
  }

  switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    widget._frontController.future.then((controller) => MapLayer.setCameraPosition(controller, _frontCameraPosition));
    widget._backController.future.then((controller) => MapLayer.setCameraPosition(controller, _backCameraPosition));
  }

  stackedMaps(frontMap, backMap) => [
        Opacity(opacity: 1.0, child: backMap),
        Opacity(opacity: (widget.opacity > 0.5 ? widget.opacity : 1.0 - widget.opacity), child: frontMap)
      ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: stackedMaps(frontMap, backMap));
  }
}
