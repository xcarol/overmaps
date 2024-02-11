import 'package:flutter/material.dart';
import 'package:overmap/helpers/place_attributes.dart';
import 'package:overmap/helpers/place_details.dart';
import 'package:overmap/services/google_places_service.dart';

class SearchPlace extends StatefulWidget {
  final Function selectedPlace;

  const SearchPlace({super.key, required this.selectedPlace});

  @override
  State createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  final GooglePlacesService _service = GooglePlacesService(mapsApiKey: const String.fromEnvironment("MAPS_API_KEY"));
  late List placesListItems = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Column(
        children: <Widget>[placesEditBox(), const SizedBox(height: 10.0), placesListBox()],
      ),
    );
  }

  selectPlace(place) {
    _service.getPlaceDetails(place['place_id']).then((response) {
      String status = response[GooglePlacesService.response.status];

      if (status == GooglePlacesService.response.ok) {
        Map<String, dynamic> placeData = response[GooglePlacesService.response.result];

        var location = placeData[PlaceAttributes.geometry]?[PlaceAttributes.location] ??
            {PlaceAttributes.lat: 0.0, PlaceAttributes.lng: 0.0};

        PlaceDetails placeDetails = PlaceDetails(
          lat: location[PlaceAttributes.lat],
          lng: location[PlaceAttributes.lng],
          name: placeData[PlaceAttributes.name] ?? 'ERROR: Retrieving place for placeId: ${place['place_id']}',
        );

        widget.selectedPlace(placeDetails);
      }
    });
  }

  void setPlacesListItems(places) {
    setState(() {
      placesListItems = places;
    });
  }

  void inputChanged(String value) async {
    final places = await _service.searchPlaces(value);
    setPlacesListItems(places['predictions']);
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
            title: Text(place['description']),
            onTap: () {
              selectPlace(place);
            },
          );
        },
      ),
    );
  }
}
