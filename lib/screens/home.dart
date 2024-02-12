import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/models/place.dart';
import 'package:overmap/models/stacked_maps_model.dart';
import 'package:overmap/screens/search_place.dart';
import 'package:overmap/screens/stacked_maps.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _opacity = StackedMapsModel.halfOpacity;
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

  void setBackPlace(Place place) {
    double latitude = place.lat;
    double longitude = place.lng;
    String name = place.name;

    Provider.of<StackedMapsModel>(context, listen: false).backPlaceLocation =
        LatLng(latitude, longitude);
    Provider.of<StackedMapsModel>(context, listen: false).backPlaceName = name;
    Provider.of<StackedMapsModel>(context, listen: false)
        .updateBackMapLocation = true;
  }

  void setFrontPlace(Place place) {
    double latitude = place.lat;
    double longitude = place.lng;
    String name = place.name;

    Provider.of<StackedMapsModel>(context, listen: false).frontPlaceLocation =
        LatLng(latitude, longitude);
    Provider.of<StackedMapsModel>(context, listen: false).frontPlaceName = name;
    Provider.of<StackedMapsModel>(context, listen: false)
        .updateFrontMapLocation = true;
  }

  searchPlace(Function selectedPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPlace(selectedPlace: selectedPlace)),
    );
  }

  searchLeftPlace() {
    searchPlace((Place place) {
      setState(() {
        if (isLeftPlaceInFront) {
          setFrontPlace(place);
          _leftName = place.name;
        } else {
          setBackPlace(place);
          _leftName = place.name;
        }
      });
      Navigator.pop(context);
    });
  }

  searchRightPlace() {
    searchPlace((Place place) {
      setState(() {
        if (isRightPlaceInFront) {
          setFrontPlace(place);
          _rightName = place.name;
        } else {
          setBackPlace(place);
          _rightName = place.name;
        }
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
