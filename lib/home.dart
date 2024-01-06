import 'package:flutter/material.dart';
import 'package:overmap/map.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: const Stack(children: <Widget>[
        MapLayer(latitude: -33.86, longitude: 151.20, opacity: 1.0),
        MapLayer(latitude: 41.4471787, longitude: 2.1920866, opacity: 0.5)
      ]),
    );
  }
}
