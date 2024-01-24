import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchPlace extends StatelessWidget {
  final Function selectedPlace;
  final TextEditingController controller = TextEditingController();

  SearchPlace({super.key, required this.selectedPlace});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overmap'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            placesAutoCompleteTextField(),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        containerHorizontalPadding: 10,
        googleAPIKey: "",
        isCrossBtnShown: true,
        seperatedBuilder: const Divider(),
        textEditingController: controller,
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        getPlaceDetailWithLatLng: (Prediction prediction) {
          selectedPlace(prediction);
        },
        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description?.length ?? 0));
        },
      ),
    );
  }
}
