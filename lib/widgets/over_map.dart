import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:overmap/models/stacked_maps_model.dart';

class OverMap extends StatefulWidget {
  final String place;
  final LatLng coordinates;
  final Set<Polyline> boundaries;
  final Set<Marker> markers;
  final Function onCameraMove, onMapCreated;

  const OverMap({
    super.key,
    required this.place,
    required this.coordinates,
    required this.boundaries,
    required this.markers,
    required this.onMapCreated,
    required this.onCameraMove,
  });

  @override
  State createState() => _OverMapState();

  static zoom(GoogleMapController? controller, CameraPosition position) {
    controller?.getZoomLevel().then((zoom) => {
          if (zoom != position.zoom)
            {controller.moveCamera(CameraUpdate.zoomTo(position.zoom))}
        });
  }

  static setCameraPosition(
      GoogleMapController? controller, CameraPosition position) {
    controller?.moveCamera(CameraUpdate.newCameraPosition(position));
  }
}

class _OverMapState extends State<OverMap> {
  Widget get unsupportedPlatformWidget => Center(
        child: Column(
          children: [
            const Text(
                'Android & Web are the only platform currently supported.\n'),
            const Text('Coordinates\n'),
            Text('Latitude: ${widget.coordinates.latitude}'),
            Text('Longitude: ${widget.coordinates.longitude}'),
          ],
        ),
      );

  Widget get mapWidget => GoogleMap(
        onMapCreated: onMapCreated,
        onCameraMove: onCameraMove,
        zoomControlsEnabled: false,
        polylines: widget.boundaries,
        markers: widget.markers,
        style: '['
            '  {"featureType": "poi","stylers": [{"visibility": "off"}]},'
            '  {"featureType": "road","elementType": "labels.icon","stylers": [{"visibility": "off"}]},'
            '  {"featureType": "transit","stylers": [{"visibility": "off"}]}'
            ']',
        initialCameraPosition: CameraPosition(
          target: widget.coordinates,
          zoom: StackedMapsModel.defaultZoom,
        ),
      );

  void onMapCreated(GoogleMapController controller) async {
    widget.onMapCreated(controller);
  }

  void onCameraMove(CameraPosition position) {
    widget.onCameraMove(position);
  }

  @override
  Widget build(BuildContext context) {
    // Check first if it's running on a Web Browser
    // because dart:io Platform class is not implemented in this case.
    if (kIsWeb || Platform.isAndroid) {
      return mapWidget;
    }

    return unsupportedPlatformWidget;
  }
}
