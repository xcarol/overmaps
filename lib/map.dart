import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLayer extends StatefulWidget {
  final double longitude, latitude;
  final double opacity;

  const MapLayer({super.key, required this.latitude, required this.longitude, required this.opacity});

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
    return Opacity(
      opacity: widget.opacity,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 11.0,
        ),
      ),
    );
  }
}
