import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MapLayer extends StatefulWidget {
  final double longitude, latitude;
  final double opacity;

  const MapLayer(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.opacity});

  @override
  State createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    late Widget childWidget;

    //Check first if it's running on a Web Browser
    // because dart:io Platform class doesn't implement
    // 'operatingSystem' attribute on this device type.
    if (!kIsWeb && Platform.isAndroid) {
      childWidget = GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 11.0,
        ),
      );
    } else {
      childWidget = Center(
          child: Column(children: [
        const Text('Android is the only platform currently supported.\n'),
        const Text('Coordinates\n'),
        Text('Latitude: ${widget.latitude}'),
        Text('Longitude: ${widget.longitude}'),
      ]));
    }

    return Opacity(
      opacity: widget.opacity,
      child: childWidget,
    );
  }
}
