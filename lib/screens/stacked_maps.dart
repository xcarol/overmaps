import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmap/models/place.dart';
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

  Set<Polyline> _frontPlacePolyline = {};
  Set<Polyline> _backPlacePolyline = {};

  Set<Marker> _frontPlaceMarker = {};
  Set<Marker> _backPlaceMarker = {};

  late CameraPosition _frontCameraPosition = CameraPosition(
    target: StackedMapsModel.barcelonaLocation,
  );
  late CameraPosition _backCameraPosition = CameraPosition(
    target: StackedMapsModel.sydneyLocation,
  );

  frontMap(StackedMapsModel map) => OverMap(
      place: map.frontPlace.name,
      coordinates: _frontCameraPosition.target,
      boundaries: _frontPlacePolyline,
      markers: _frontPlaceMarker,
        onMapCreated: frontMapCreated,
        onCameraMove: frontCameraMove,
      );

  backMap(StackedMapsModel map) => OverMap(
      place: map.backPlace.name,
      coordinates: _backCameraPosition.target,
      boundaries: _backPlacePolyline,
      markers: _backPlaceMarker,
        onMapCreated: backMapCreated,
        onCameraMove: backCameraMove,
      );

  double get frontMapOpacity => (_opacity > StackedMapsModel.halfOpacity
      ? _opacity
      : StackedMapsModel.opaque - _opacity);

  stackedMaps(frontMap, backMap) => [
        Opacity(opacity: StackedMapsModel.opaque, child: backMap),
        Opacity(opacity: frontMapOpacity, child: frontMap),
      ];

  bool needSwitchMaps(StackedMapsModel map) {
    return (_opacity > StackedMapsModel.halfOpacity &&
            map.opacity <= StackedMapsModel.halfOpacity) ||
        (_opacity <= StackedMapsModel.halfOpacity &&
            map.opacity > StackedMapsModel.halfOpacity);
  }

  Function get backMapCreated {
    return (GoogleMapController controller) {
      setState(() {
        _backController = controller;
      });
    };
  }

  Function get backCameraMove {
    return (CameraPosition position) {
      _backCameraPosition = position;
    };
  }

  Function get frontMapCreated {
    return (GoogleMapController controller) {
      setState(() {
        _frontController = controller;
      });
    };
  }

  Function get frontCameraMove {
    return (CameraPosition position) {
      _frontCameraPosition = position;
      OverMap.zoom(_backController, position);
    };
  }

  Future<Set<Polyline>> getMapBoundary(
    Place place,
    PolylineId polylineId,
    Color boundaryColor,
  ) async {
    PlacesService placesService = PlacesService();

    List<String> polygons = await placesService.getPlaceBoundaryPolygons(place);
    Set<Polyline> boundaries = {};

    for (String polygon in polygons) {
      List<LatLng> polylinePoints = List.empty(growable: true);
      List<String> coordinates = polygon.split(' ');

      for (String coordinatePair in coordinates) {
        List<String> latLng = coordinatePair.split(',');
        if (latLng.length == 2) {
          polylinePoints
              .add(LatLng(double.parse(latLng[1]), double.parse(latLng[0])));
        }
      }

      if (polylinePoints.isNotEmpty) {
        boundaries.add(Polyline(
            polylineId: PolylineId(DateTime.now().toString()),
            points: polylinePoints,
            width: 2,
            color: boundaryColor));
      }
    }

    return boundaries;
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

  void setCameraPosition(
    GoogleMapController? controller, CameraPosition position) {
    OverMap.setCameraPosition(controller, position);
  }

  void switchMaps() {
    CameraPosition copyCameraPosition = _frontCameraPosition;
    _frontCameraPosition = _backCameraPosition;
    _backCameraPosition = copyCameraPosition;

    OverMap.setCameraPosition(_frontController, _frontCameraPosition);
    OverMap.setCameraPosition(_backController, _backCameraPosition);

    Set<Polyline>? copyPlacePolyline = _backPlacePolyline;
    _backPlacePolyline = _frontPlacePolyline;
    _frontPlacePolyline = copyPlacePolyline;

    Set<Marker>? copyPlaceMarker = _backPlaceMarker;
    _backPlaceMarker = _frontPlaceMarker;
    _frontPlaceMarker = copyPlaceMarker;
  }

  void setFrontMapBoundary(StackedMapsModel map) async {
    Set<Polyline> boundary = await getMapBoundary(
      map.frontPlace,
      StackedMapsModel.frontPlacePolylineId,
      map.frontPlaceBoundaryColor,
    );
    setState(() {
      _frontPlacePolyline = boundary;
    });
  }

  void setBackMapBoundary(StackedMapsModel map) async {
    Set<Polyline> boundary = await getMapBoundary(
      map.backPlace,
      StackedMapsModel.backPlacePolylineId,
      map.backPlaceBoundaryColor,
    );
    setState(() {
      _backPlacePolyline = boundary;
    });
  }

  void setFrontMapMarker(StackedMapsModel map) async {
    Future(
      () => setState(() {
        _frontPlaceMarker = {
          Marker(
            markerId: StackedMapsModel.frontPlaceMarkerId,
            position: LatLng(map.frontPlace.lat, map.frontPlace.lon),
          )
        };
      }),
    );
  }

  void setBackMapMarker(StackedMapsModel map) {
    Future(
      () => setState(() {
        _backPlaceMarker = {
          Marker(
            markerId: StackedMapsModel.backPlaceMarkerId,
            position: LatLng(map.backPlace.lat, map.backPlace.lon),
          )
        };
      }),
    );
  }

  void updateBackMap(StackedMapsModel map) {
    _backCameraPosition = updateCameraLocation(
      _backCameraPosition,
      LatLng(map.backPlace.lat, map.backPlace.lon),
    );

    setCameraPosition(_backController, _backCameraPosition);
    setBackMapBoundary(map);
    setBackMapMarker(map);

    map.resetUpdateBackMap();
  }

  void updateFrontMap(StackedMapsModel map) {
    _frontCameraPosition = updateCameraLocation(
      _frontCameraPosition,
      LatLng(map.frontPlace.lat, map.frontPlace.lon),
    );

    setCameraPosition(_frontController, _frontCameraPosition);
    setFrontMapBoundary(map);
    setFrontMapMarker(map);

    map.resetUpdateFrontMap();
  }

    void update(map) {
      if (_frontPlacePolyline.isEmpty) {
        setFrontMapBoundary(map);
      }

      if (_backPlacePolyline.isEmpty) {
        setBackMapBoundary(map);
      }

      if (_frontPlaceMarker.isEmpty) {
        setFrontMapMarker(map);
      }

      if (_backPlaceMarker.isEmpty) {
        setBackMapMarker(map);
      }

      if (needSwitchMaps(map)) {
        switchMaps();
      }

      if (map.updateFrontMap) {
        updateFrontMap(map);
      }

      if (map.updateBackMap) {
        updateBackMap(map);
      }
    }

  @override
  Widget build(BuildContext context) {
    return Consumer<StackedMapsModel>(builder: (context, map, child) {
      update(map);

      _opacity = map.opacity;

      return Stack(
        children: stackedMaps(
          frontMap(map),
          backMap(map),
        ),
      );
    });
  }
}
