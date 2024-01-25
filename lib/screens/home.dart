import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:overmap/models/map_model.dart';
import 'package:overmap/screens/search.dart';
import 'package:overmap/screens/stacked_maps.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _opacity = 0.4;
  late double _rightLatitude = -33.86, _rightLongitude = 151.20;
  late double _leftLatitude = 41.4471787, _leftLongitude = 2.1920866;
  late String _leftName = "left", _rightName = "right";

  get mapNamesRow => Row(children: [
        IconButton(onPressed: searchLeftPlace, icon: const Icon(Icons.search)),
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: _opacity >= 0.5 ? Alignment.topRight : Alignment.topLeft,
                child: Text(_opacity >= 0.5 ? _rightName : _leftName),
              ),
              Align(
                alignment: _opacity >= 0.5 ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(_opacity >= 0.5 ? _leftName : _rightName),
              ),
            ],
          ),
        ),
        IconButton(onPressed: searchRightPlace, icon: const Icon(Icons.search)),
      ]);

  get sliderRow => Slider(
      value: _opacity,
      thumbColor: Theme.of(context).colorScheme.secondary,
      activeColor: const Color.fromARGB(0, 0, 0, 0),
      inactiveColor: const Color.fromARGB(0, 0, 0, 0),
      max: 1.0,
      onChanged: sliderMoved);

  searchPlace(Function selectedPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPlace(selectedPlace: selectedPlace)),
    );
  }

  searchLeftPlace() {
    searchPlace((Prediction place) {
      setState(() {
        _leftLatitude = double.parse(place.lat ?? "41.4471787");
        _leftLongitude = double.parse(place.lng ?? "2.1920866");
        _leftName = place.structuredFormatting?.mainText ?? "Barcelona";
      });
      Navigator.pop(context);
    });
  }

  searchRightPlace() {
    searchPlace((Prediction place) {
      setState(() {
        _rightLatitude = double.parse(place.lat ?? "-33.86");
        _rightLongitude = double.parse(place.lng ?? "151.20");
        _rightName = place.structuredFormatting?.mainText ?? "Sydney";
      });
      Navigator.pop(context);
    });
  }

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
            frontMapLatitude: _leftLatitude,
            frontMapLongitude: _leftLongitude,
            backMapLatitude: _rightLatitude,
            backMapLongitude: _rightLongitude),
        persistentFooterButtons: [
          Column(
            children: [sliderRow, mapNamesRow],
          )
        ]);
  }
}
