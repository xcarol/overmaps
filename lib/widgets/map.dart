import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:overmap/models/stacked_maps_model.dart';

class Map extends StatefulWidget {
  final LatLng latLng;
  final Function onCameraMove, onMapCreated;

  const Map({super.key, required this.latLng, required this.onMapCreated, required this.onCameraMove});

  @override
  State createState() => _MapState();

  static zoom(GoogleMapController? controller, CameraPosition position) {
    controller?.getZoomLevel().then((zoom) => {
          if (zoom != position.zoom) {controller.moveCamera(CameraUpdate.zoomTo(position.zoom))}
        });
  }

  static setCameraPosition(GoogleMapController? controller, CameraPosition position) {
    controller?.moveCamera(CameraUpdate.newCameraPosition(position));
  }
}

class _MapState extends State<Map> {
  late GoogleMapController _mapController;

  Widget get unsupportedPlatformWidget => Center(
          child: Column(children: [
        const Text('Android is the only platform currently supported.\n'),
        const Text('Coordinates\n'),
        Text('Latitude: ${widget.latLng.latitude}'),
        Text('Longitude: ${widget.latLng.longitude}'),
      ]));

  Widget get mapWidget => GoogleMap(
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: widget.latLng,
        zoom: StackedMapsModel.defaultZoom,
      ));

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"featureType": "administrative","elementType": "geometry","stylers": [{"visibility": "off"}]},{"featureType": "poi","stylers": [{"visibility": "off"}]},{"featureType": "road","elementType": "labels.icon","stylers": [{"visibility": "off"}]},{"featureType": "transit","stylers": [{"visibility": "off"}]}]');
    _mapController = controller;
    widget.onMapCreated(_mapController);
  }

  void _onCameraMove(CameraPosition position) {
    widget.onCameraMove(position);
  }

  @override
  Widget build(BuildContext context) {
    late Widget childWidget;

    // Check first if it's running on a Web Browser because dart:io Platform class is not implemented in this case.
    if (kIsWeb || Platform.isAndroid == false) {
      childWidget = unsupportedPlatformWidget;
    } else {
      childWidget = mapWidget;
    }

    return childWidget;
  }
}
