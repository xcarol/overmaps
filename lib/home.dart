import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _opacity = 0.5;
  late GoogleMapController? _frontController, _backController;
  late CameraPosition _frontCameraPosition = const CameraPosition(target: LatLng(41.4471787, 2.1920866));
  late CameraPosition _backCameraPosition = const CameraPosition(target: LatLng(-33.86, 151.20));
  final String _backName = "Sydney", _frontName = "Barcelona";

  get mapNames => Row(children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: _opacity >= 0.5 ? Alignment.topRight : Alignment.topLeft,
                child: Text(_opacity >= 0.5 ? _frontName : _backName),
              ),
              Align(
                alignment: _opacity >= 0.5 ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(_opacity >= 0.5 ? _backName : _frontName),
              ),
            ],
          ),
        ),
      ]);

  get slider => Slider(
      value: _opacity,
      thumbColor: Theme.of(context).colorScheme.secondary,
      activeColor: const Color.fromARGB(0, 0, 0, 0),
      inactiveColor: const Color.fromARGB(0, 0, 0, 0),
      max: 1.0,
      onChanged: sliderMoved);

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

  stackedMaps(frontMap, backMap) => [
        Opacity(opacity: 1.0, child: backMap),
        Opacity(opacity: (_opacity > 0.5 ? _opacity : 1.0 - _opacity), child: frontMap)
      ];

  switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    MapLayer.setCameraPosition(_frontController, _frontCameraPosition);
    MapLayer.setCameraPosition(_backController, _backCameraPosition);
  }

  sliderMoved(double opacity) {
    setState(() {
      if ((opacity > 0.5 && _opacity <= 0.5) || (opacity <= 0.5 && _opacity > 0.5)) {
        switchMaps();
      }
      _opacity = opacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overmap'),
        ),
        body: Stack(children: stackedMaps(frontMap, backMap)),
        persistentFooterButtons: [
          Column(
            children: [slider, mapNames],
          )
        ]);
  }
}
