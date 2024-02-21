import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/services/places_service.dart';
import 'package:overmap/widgets/over_map.dart';
import 'package:overmap/models/stacked_maps_model.dart';
import 'package:provider/provider.dart';

class StackedMaps extends StatefulWidget {
  const StackedMaps({super.key});

  @override
  State createState() => _StackedMapsState();
}

class _StackedMapsState extends State<StackedMaps> {
  late double _opacity = 0.0;

  GoogleMapController? _frontController;
  GoogleMapController? _backController;

  Set<Polyline>? _frontPlacePolyline;
  Set<Polyline>? _backPlacePolyline;

  late CameraPosition _frontCameraPosition =
      CameraPosition(target: StackedMapsModel.barcelonaLocation);
  late CameraPosition _backCameraPosition =
      CameraPosition(target: StackedMapsModel.sydneyLocation);

  frontMap(StackedMapsModel map) => OverMap(
      place: map.frontPlaceName,
      coordinates: _frontCameraPosition.target,
      boundaries: _frontPlacePolyline ??
          {Polyline(polylineId: StackedMapsModel.frontPlacePolylineId)},
      onMapCreated: frontMapCreated(),
      onCameraMove: frontCameraMove());

  backMap(StackedMapsModel map) => OverMap(
      place: map.backPlaceName,
      coordinates: _backCameraPosition.target,
      boundaries: _backPlacePolyline ??
          {Polyline(polylineId: StackedMapsModel.backPlacePolylineId)},
      onMapCreated: backMapCreated(),
      onCameraMove: backCameraMove());

  double get frontMapOpacity => (_opacity > StackedMapsModel.halfOpacity
      ? _opacity
      : StackedMapsModel.opaque - _opacity);

  stackedMaps(frontMap, backMap) => [
        Opacity(opacity: StackedMapsModel.opaque, child: backMap),
        Opacity(opacity: frontMapOpacity, child: frontMap)
      ];

  bool needSwitchMaps(StackedMapsModel map) {
    return (_opacity > StackedMapsModel.halfOpacity &&
            map.opacity <= StackedMapsModel.halfOpacity) ||
        (_opacity <= StackedMapsModel.halfOpacity &&
            map.opacity > StackedMapsModel.halfOpacity);
  }

  backMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        _backController = controller;
      });
    };
  }

  backCameraMove() {
    return (CameraPosition position) {
      _backCameraPosition = position;
    };
  }

  frontMapCreated() {
    return (GoogleMapController controller) {
      setState(() {
        _frontController = controller;
      });
    };
  }

  frontCameraMove() {
    return (CameraPosition position) {
      _frontCameraPosition = position;
      OverMap.zoom(_backController, position);
    };
  }

  CameraPosition updateCameraLocation(
    CameraPosition cameraPosition,
    LatLng location,
  ) {
    return CameraPosition(
        target: location,
        bearing: cameraPosition.bearing,
        tilt: cameraPosition.tilt,
        zoom: cameraPosition.zoom);
  }

  updateMap(GoogleMapController? controller, CameraPosition position) {
    OverMap.setCameraPosition(controller, position);
  }

  switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    OverMap.setCameraPosition(_frontController, _frontCameraPosition);
    OverMap.setCameraPosition(_backController, _backCameraPosition);

    Set<Polyline>? copyPlacePolyline = _backPlacePolyline;
    _backPlacePolyline = _frontPlacePolyline;
    _frontPlacePolyline = copyPlacePolyline;
  }

  void setFrontMapBoundary(StackedMapsModel map) async {
    var value = await getMapBoundary(map.frontPlaceName, map.frontPlaceLocation,
        StackedMapsModel.frontPlacePolylineId);
    setState(() {
      _frontPlacePolyline = value;
    });
  }

  void setBackMapBoundary(StackedMapsModel map) async {
    var value = await getMapBoundary(map.backPlaceName, map.backPlaceLocation,
        StackedMapsModel.backPlacePolylineId);
    setState(() {
      _backPlacePolyline = value;
    });
  }

  Future<Set<Polyline>> getMapBoundary(
      String place, LatLng coordinates, PolylineId polylineId) async {
    PlacesService placesService = PlacesService(
        googleMapsApiKey: const String.fromEnvironment("MAPS_API_KEY"));

    List<String> polygons = await placesService.getPlaceBoundaryPolygons(
        place, coordinates.latitude, coordinates.longitude);

    return Future(() => getBoundaries(polygons));
  }

  Set<Polyline> getBoundaries(List<String> polygons) {
    Set<Polyline> boundaries = {};
    
    for (String polygon in polygons) {
      List<LatLng> polylinePoints = List.empty(growable: true);
      List<String> coordinates = polygon.split(' ');

      for (String coordinatePair in coordinates) {
        List<String> latLng = coordinatePair.split(',');
        if (latLng.length == 2) {
          polylinePoints.add(LatLng(double.parse(latLng[1]), double.parse(latLng[0])));
        }
      }

      if (polylinePoints.isNotEmpty) {
        boundaries.add(Polyline(
            polylineId: PolylineId(DateTime.now().toString()),
            points: polylinePoints,
            width: 1,
            color: Colors.red));
      }
    }
    
    return boundaries;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StackedMapsModel>(builder: (context, map, child) {
      if (_frontPlacePolyline == null) {
        setFrontMapBoundary(map);
      }
      if (_backPlacePolyline == null) {
        setBackMapBoundary(map);
      }

      if (needSwitchMaps(map)) {
        switchMaps();
      }

      if (map.updateFrontMap) {
        _frontCameraPosition =
            updateCameraLocation(_frontCameraPosition, map.frontPlaceLocation);

        updateMap(_frontController, _frontCameraPosition);
        setFrontMapBoundary(map);

        map.resetUpdateFrontMap();
      }

      if (map.updateBackMap) {
        _backCameraPosition =
            updateCameraLocation(_backCameraPosition, map.backPlaceLocation);

        updateMap(_backController, _backCameraPosition);
        setBackMapBoundary(map);

        map.resetUpdateBackMap();
      }

      _opacity = map.opacity;

      return Stack(children: stackedMaps(frontMap(map), backMap(map)));
    });
  }
}
