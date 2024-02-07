import 'package:flutter/material.dart';

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
      child: const Column(),
    );
  }
}
