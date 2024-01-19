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
  late LatLng _backLatLng = const LatLng(-33.86, 151.20);
  late LatLng _frontLatLng = const LatLng(41.4471787, 2.1920866);

  backMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        _backController = controller;
      });
    };
  }

  backCameraMove() {
    return (CameraPosition position) {
      _backLatLng = position.target;
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
      _frontLatLng = position.target;
      MapLayer.zoom(_backController, position);
    };
  }

  switchMaps() {
    LatLng copyFrontLatLng = _frontLatLng;
    _frontLatLng = _backLatLng;
    _backLatLng = copyFrontLatLng;

    _frontController?.moveCamera(CameraUpdate.newLatLng(_frontLatLng));
    _backController?.moveCamera(CameraUpdate.newLatLng(_backLatLng));
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
        MapLayer(latLng: _backLatLng, onMapCreated: backMapCreated(), onCameraMove: backCameraMove());
    final MapLayer frontMap =
        MapLayer(latLng: _frontLatLng, onMapCreated: frontMapCreated(), onCameraMove: frontCameraMove());

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
