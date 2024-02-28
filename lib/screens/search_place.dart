import 'package:flutter/material.dart';
import 'package:overmap/models/place.dart';
import 'package:overmap/services/places_service.dart';

class SearchPlace extends StatefulWidget {
  final Function selectedPlace;

  const SearchPlace({super.key, required this.selectedPlace});

  @override
  State createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  final PlacesService _service = PlacesService(
      googleMapsApiKey: const String.fromEnvironment("MAPS_API_KEY"));
  late List placesListItems = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Column(
        children: <Widget>[
          placesEditBox(),
          const SizedBox(height: 10.0),
          placesListBox()
        ],
      ),
    );
  }

  selectPlace(Place place) {
    // _service.getPlaceDetails(place.placeId).then((response) {
        widget.selectedPlace(place);
    // });
  }

  void setPlacesListItems(places) {
    setState(() {
      placesListItems = places;
    });
  }

  void inputChanged(String value) async {
    final places = await _service.searchPlaces(value);
    setPlacesListItems(places);
  }

  placesEditBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Introduir text...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (text) {
          inputChanged(text);
        },
      ),
    );
  }

  placesListBox() {
    return Expanded(
      child: ListView.builder(
        itemCount: placesListItems.length,
        itemBuilder: (context, index) {
          var place = placesListItems.elementAt(index);
          return ListTile(
            // title: Text(place['description']),
            title: Text(place['display_name']),
            onTap: () {
              selectPlace(Place(place));
            },
          );
        },
      ),
    );
  }
}
