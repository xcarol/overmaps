import 'package:flutter/material.dart';
import 'package:overmap/models/map_model.dart';
import 'package:overmap/screens/stacked_maps.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _opacity = 0.5;
  final double _barcelonaLatitude = -33.86, _barcelonaLongitude = 151.20;
  final double _sydneyLatitude = 41.4471787, _sydneyLongitude = 2.1920866;
  final String _sydneyName = "Sydney", _barcelonaName = "Barcelona";

  get mapNames => Row(children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: _opacity >= 0.5 ? Alignment.topRight : Alignment.topLeft,
                child: Text(_opacity >= 0.5 ? _sydneyName : _barcelonaName),
              ),
              Align(
                alignment: _opacity >= 0.5 ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(_opacity >= 0.5 ? _barcelonaName : _sydneyName),
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ]);

  get slider => Slider(
      value: _opacity,
      thumbColor: Theme.of(context).colorScheme.secondary,
      activeColor: const Color.fromARGB(0, 0, 0, 0),
      inactiveColor: const Color.fromARGB(0, 0, 0, 0),
      max: 1.0,
      onChanged: sliderMoved);

  sliderMoved(double opacity) {
    setState(() {
      Provider.of<MapModel>(context, listen: false).opacity = opacity;
      _opacity = opacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overmap'),
        ),
        body: StackedMaps(
            frontMapLatitude: _sydneyLatitude,
            frontMapLongitude: _sydneyLongitude,
            backMapLatitude: _barcelonaLatitude,
            backMapLongitude: _barcelonaLongitude),
        persistentFooterButtons: [
          Column(
            children: [slider, mapNames],
          )
        ]);
  }
}
