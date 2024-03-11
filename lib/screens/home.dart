import 'package:flutter/material.dart';
import 'package:overmaps/models/place.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:overmaps/screens/search_place.dart';
import 'package:overmaps/screens/stacked_maps.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Provider.of<StackedMapsModel>(context, listen: false).preferences = prefs;
    });
  }

  final IconData showToolsIcon = Icons.arrow_drop_up;
  final IconData hideToolsIcon = Icons.arrow_drop_down;
  final Color _rightBoundaryColor = StackedMapsModel.colorBlue;
  final Color _leftBoundaryColor = StackedMapsModel.colorRed;
  late String _rightName = Provider.of<StackedMapsModel>(context, listen: false).backPlace.name;
  late String _leftName = Provider.of<StackedMapsModel>(context, listen: false).frontPlace.name;
  late IconData _showHideToolsIcon = showToolsIcon;

  get isLeftPlaceInFront => Provider.of<StackedMapsModel>(context, listen: false).opacity <= StackedMapsModel.halfOpacity;
  get isRightPlaceInFront => Provider.of<StackedMapsModel>(context, listen: false).opacity > StackedMapsModel.halfOpacity;

  get rightAlignment =>
      isRightPlaceInFront ? Alignment.topRight : Alignment.topLeft;
  get leftAlignment =>
      isRightPlaceInFront ? Alignment.bottomLeft : Alignment.bottomRight;
  get rightNameText => Text(isRightPlaceInFront ? _rightName : _leftName);
  get leftNameText => Text(isRightPlaceInFront ? _leftName : _rightName);

  get toolsRow => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 24,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: IconButton(
                onPressed: showHideTools,
                icon: Icon(_showHideToolsIcon),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      );

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
      value: Provider.of<StackedMapsModel>(context, listen: false).opacity,
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

  showHideTools() {
    setState(() {
      if (_showHideToolsIcon == showToolsIcon) {
        _showHideToolsIcon = hideToolsIcon;
        Provider.of<StackedMapsModel>(context, listen: false).showTools = true;
      } else {
        _showHideToolsIcon = showToolsIcon;
        Provider.of<StackedMapsModel>(context, listen: false).showTools = false;
      }
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overmaps'),
        ),
        body: const StackedMaps(),
        persistentFooterButtons: [
          Column(
            children: [
              toolsRow,
              mapNamesRow,
              sliderRow,
            ],
          )
        ]);
  }
}
