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

  @override
  Widget build(BuildContext context) {
    MapLayer backMap = MapLayer(
        latLng: _backLatLng,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _backController = controller;
          });
        },
        onCameraMove: (CameraPosition position) {
          _backLatLng = position.target;
        });
    MapLayer frontMap = MapLayer(
        latLng: _frontLatLng,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _frontController = controller;
          });
        },
        onCameraMove: (CameraPosition position) {
          _frontLatLng = position.target;
          MapLayer.zoom(_backController, position);
        });

    final List<Widget> stackedMaps = <Widget>[
      Opacity(
        opacity: 1.0,
        child: backMap,
      ),
      Opacity(
        opacity: _opacity,
        child: frontMap,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Stack(children: stackedMaps),
      persistentFooterButtons: [
        Slider(
            value: _opacity,
            thumbColor: Theme.of(context).colorScheme.secondary,
            activeColor: const Color.fromARGB(0, 0, 0, 0),
            inactiveColor: const Color.fromARGB(0, 0, 0, 0),
            max: 1.0,
            onChanged: (double opacity) {
              setState(() {
                if (opacity > 0.5 && _opacity <= 0.5) {
                  LatLng z = _frontLatLng;
                  _frontLatLng = _backLatLng;
                  _backLatLng = z;
                  _frontController
                      ?.moveCamera(CameraUpdate.newLatLng(_frontLatLng));
                  _backController
                      ?.moveCamera(CameraUpdate.newLatLng(_backLatLng));
                }
                if (opacity <= 0.5 && _opacity > 0.5) {
                  LatLng z = _frontLatLng;
                  _frontLatLng = _backLatLng;
                  _backLatLng = z;
                  _frontController
                      ?.moveCamera(CameraUpdate.newLatLng(_frontLatLng));
                  _backController
                      ?.moveCamera(CameraUpdate.newLatLng(_backLatLng));
                }
                _opacity = opacity;
              });
            })
      ],
    );
  }
}
