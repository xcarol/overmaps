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
  late GoogleMapController? _backController;

  @override
  Widget build(BuildContext context) {
    MapLayer backMap = MapLayer(
        latitude: -33.86,
        longitude: 151.20,
        opacity: 1.0,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _backController = controller;
          });
        },
        onCameraMove: (CameraPosition position) {});
    MapLayer frontMap = MapLayer(
        latitude: 41.4471787,
        longitude: 2.1920866,
        opacity: _opacity,
        onMapCreated: (GoogleMapController controller) {},
        onCameraMove: (CameraPosition position) {
          MapLayer.zoom(_backController, position);
        });
    final List<Widget> stackedMaps = <Widget>[backMap, frontMap];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Stack(children: stackedMaps),
      persistentFooterButtons: [
        Slider(
            value: _opacity,
            max: 1.0,
            onChanged: (double value) {
              setState(() {
                _opacity = value;
              });
            })
      ],
    );
  }
}
