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

    _frontController?.moveCamera(CameraUpdate.newCameraPosition(_frontCameraPosition));
    _backController?.moveCamera(CameraUpdate.newCameraPosition(_backCameraPosition));
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
    const opaque = 1.0;
    final thumbColor = Theme.of(context).colorScheme.secondary;
    const activeColor = Color.fromARGB(0, 0, 0, 0);
    const inactiveColor = Color.fromARGB(0, 0, 0, 0);

    final MapLayer backMap =
        MapLayer(latLng: _backCameraPosition.target, onMapCreated: backMapCreated(), onCameraMove: backCameraMove());
    final MapLayer frontMap =
        MapLayer(latLng: _frontCameraPosition.target, onMapCreated: frontMapCreated(), onCameraMove: frontCameraMove());

    final List<Widget> stackedMaps = <Widget>[
      Opacity(opacity: 1.0, child: backMap),
      Opacity(opacity: (_opacity > 0.5 ? _opacity : 1.0 - _opacity), child: frontMap)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Stack(children: stackedMaps),
      persistentFooterButtons: [
        Slider(
            value: _opacity,
            thumbColor: thumbColor,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            max: opaque,
            onChanged: sliderMoved)
      ],
    );
  }
}
