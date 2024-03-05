import 'package:flutter/material.dart';
import 'package:overmaps/models/place.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:overmaps/screens/search_place.dart';
import 'package:overmaps/screens/stacked_maps.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color _rightBoundaryColor = StackedMapsModel.colorBlue;
  final Color _leftBoundaryColor = StackedMapsModel.colorRed;
  late double _opacity = StackedMapsModel.initialOpacity;
  late String _rightName = StackedMapsModel.sydneyName;
  late String _leftName = StackedMapsModel.barcelonaName;

  get isLeftPlaceInFront => _opacity <= StackedMapsModel.halfOpacity;
  get isRightPlaceInFront => _opacity > StackedMapsModel.halfOpacity;

  get rightAlignment =>
      isRightPlaceInFront ? Alignment.topRight : Alignment.topLeft;
  get leftAlignment =>
      isRightPlaceInFront ? Alignment.bottomLeft : Alignment.bottomRight;
  get rightNameText => Text(isRightPlaceInFront ? _rightName : _leftName);
  get leftNameText => Text(isRightPlaceInFront ? _leftName : _rightName);

  get mapNamesRow => Row(children: [
        IconButton(onPressed: searchLeftPlace, icon: const Icon(Icons.search)),
        Expanded(
          child: Column(
            children: [
              Align(alignment: rightAlignment, child: rightNameText),
              Align(alignment: leftAlignment, child: leftNameText),
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

  void setBackPlace(Place place, Color boundaryColor) {
    Provider.of<StackedMapsModel>(context, listen: false).updateBackMap = true;
    Provider.of<StackedMapsModel>(context, listen: false).backPlace = place;
    Provider.of<StackedMapsModel>(context, listen: false)
        .backPlaceBoundaryColor = boundaryColor;
  }

  void setFrontPlace(Place place, Color boundaryColor) {
    Provider.of<StackedMapsModel>(context, listen: false).updateFrontMap = true;
    Provider.of<StackedMapsModel>(context, listen: false).frontPlace = place;
    Provider.of<StackedMapsModel>(context, listen: false)
        .frontPlaceBoundaryColor = boundaryColor;
  }

  searchPlaceScreen(Function selectedPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPlace(selectedPlace: selectedPlace)),
    );
  }

  searchLeftPlace() {
    searchPlaceScreen((Place place) {
      setState(() {
        if (isLeftPlaceInFront) {
          setFrontPlace(place, _leftBoundaryColor);
        } else {
          setBackPlace(place, _leftBoundaryColor);
        }
        _leftName = place.name;
      });
      Navigator.pop(context);
    });
  }

  searchRightPlace() {
    searchPlaceScreen((Place place) {
      setState(() {
        if (isRightPlaceInFront) {
          setFrontPlace(place, _rightBoundaryColor);
        } else {
          setBackPlace(place, _rightBoundaryColor);
        }
        _rightName = place.name;
      });
      Navigator.pop(context);
    });
  }

  sliderMoved(double opacity) {
    setState(() {
      Provider.of<StackedMapsModel>(context, listen: false).opacity = opacity;
      _opacity = opacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overmap'),
        ),
        body: const StackedMaps(),
        persistentFooterButtons: [
          Column(
            children: [mapNamesRow, sliderRow],
          )
        ]);
  }
}
