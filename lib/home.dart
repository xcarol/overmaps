import 'package:flutter/material.dart';
import 'package:overmap/stacked_maps.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _opacity = 0.5;
  final String _backName = "Sydney", _frontName = "Barcelona";

  get mapNames => Row(children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: _opacity >= 0.5 ? Alignment.topRight : Alignment.topLeft,
                child: Text(_opacity >= 0.5 ? _backName : _frontName),
              ),
              Align(
                alignment: _opacity >= 0.5 ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(_opacity >= 0.5 ? _frontName : _backName),
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
            frontMapLatitude: 0, frontMapLongitude: 0, backMapLatitude: 0, backMapLongitude: 0, opacity: _opacity),
        persistentFooterButtons: [
          Column(
            children: [slider, mapNames],
          )
        ]);
  }
}
