import 'package:flutter/material.dart';
import 'package:overmap/map.dart';

class Home extends StatelessWidget {
  Home({super.key}) {
    stackedMaps.add(backMap);
    stackedMaps.add(frontMap);
  }

  final MapLayer frontMap =
      const MapLayer(latitude: 41.4471787, longitude: 2.1920866, opacity: 0.5);
  final MapLayer backMap =
      const MapLayer(latitude: -33.86, longitude: 151.20, opacity: 1.0);
  final List<Widget> stackedMaps = const <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Stack(children: stackedMaps)
    );
  }
}
