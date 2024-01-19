import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MapLayer extends StatefulWidget {
  final LatLng latLng;
  final Function onCameraMove, onMapCreated;

  const MapLayer(
      {super.key,
      required this.latLng,
      required this.onMapCreated,
      required this.onCameraMove});

  @override
  State createState() => _MapLayerState();

  static zoom(GoogleMapController? controller, CameraPosition position) {
    controller?.getZoomLevel().then((value) => {
          if (value != position.zoom)
            {controller.moveCamera(CameraUpdate.zoomTo(position.zoom))}
        });
  }
}

class _MapLayerState extends State<MapLayer> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.onMapCreated(_mapController);
  }

  void _onCameraMove(CameraPosition position) {
    widget.onCameraMove(position);
  }

  @override
  Widget build(BuildContext context) {
    late Widget childWidget;

    // Check first if it's running on a Web Browser
    // because dart:io Platform class doesn't implement
    // 'operatingSystem' attribute on this device type.
    if (!kIsWeb && Platform.isAndroid) {
      childWidget = GoogleMap(
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: widget.latLng,
        ),
      );
    } else {
      childWidget = Center(
          child: Column(children: [
        const Text('Android is the only platform currently supported.\n'),
        const Text('Coordinates\n'),
        Text('Latitude: ${widget.latLng.latitude}'),
        Text('Longitude: ${widget.latLng.longitude}'),
      ]));
    }

    return childWidget;
  }
}
