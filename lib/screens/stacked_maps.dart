import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overmaps/helpers/snack_bar.dart';
import 'package:overmaps/models/place.dart';
import 'package:overmaps/services/places_service.dart';
import 'package:overmaps/widgets/bearing_slider.dart';
import 'package:overmaps/widgets/opacity_slider.dart';
import 'package:overmaps/widgets/over_map.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:overmaps/widgets/tilt_slider.dart';
import 'package:overmaps/widgets/zoom_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: constant_identifier_names
const MAX_POLYGONS = 10000;
// ignore: constant_identifier_names
const MIN_COORDINATES = 100;

class StackedMaps extends StatefulWidget {
  const StackedMaps({super.key});

  @override
  State createState() => _StackedMapsState();
}

class _StackedMapsState extends State<StackedMaps> {
  late double _opacity =
      Provider.of<StackedMapsModel>(context, listen: false).opacity;
  late double _zoom =
      Provider.of<StackedMapsModel>(context, listen: false).zoom;
  late double _tilt =
      Provider.of<StackedMapsModel>(context, listen: false).tilt;
  late double _bearing =
      Provider.of<StackedMapsModel>(context, listen: false).bearing;

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

  get tools => Opacity(
      opacity: 1.0,
      child: Row(
        children: [
          TiltSlider(
            Provider.of<StackedMapsModel>(context, listen: false),
            context,
            (double tilt) {
              setState(() {
                Provider.of<StackedMapsModel>(context, listen: false).tilt =
                    tilt;
                _tilt = tilt;
              });
              OverMap.tilt(_frontController, _frontCameraPosition, _tilt);
              OverMap.tilt(_backController, _backCameraPosition, _tilt);
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BearingSlider(
                    Provider.of<StackedMapsModel>(context, listen: false),
                    context, (double bearing) {
                  setState(() {
                    Provider.of<StackedMapsModel>(context, listen: false)
                        .bearing = bearing;
                    _bearing = bearing;
                  });
                  OverMap.bearing(
                      _frontController, _frontCameraPosition, _bearing);
                  OverMap.bearing(
                      _backController, _backCameraPosition, _bearing);
                }),
                OpacitySlider(
                    Provider.of<StackedMapsModel>(context, listen: false),
                    context, (double opacity) {
                  setState(() {
                    Provider.of<StackedMapsModel>(context, listen: false)
                        .opacity = opacity;
                  });
                }),
              ],
            ),
          ),
          ZoomSlider(
            Provider.of<StackedMapsModel>(context, listen: false),
            context,
            (double zoom) {
              setState(() {
                Provider.of<StackedMapsModel>(context, listen: false).zoom =
                    zoom;
                _zoom = zoom;
              });
              OverMap.zoom(_frontController, _zoom);
              OverMap.zoom(_backController, _zoom);
            },
          ),
        ],
      ));

  frontMap(StackedMapsModel map) => OverMap(
        place: map.frontPlace.name,
        coordinates: LatLng(map.frontPlace.lat, map.frontPlace.lon),
        boundaries: _frontPlacePolyline,
        markers: _frontPlaceMarker,
        mapZoom: _zoom,
        mapTilt: _tilt,
        mapBearing: _bearing,
        onMapCreated: frontMapCreated,
        onCameraMove: frontCameraMove,
      );

  backMap(StackedMapsModel map) => OverMap(
        place: map.backPlace.name,
        coordinates: LatLng(map.backPlace.lat, map.backPlace.lon),
        boundaries: _backPlacePolyline,
        markers: _backPlaceMarker,
        mapZoom: _zoom,
        mapTilt: _tilt,
        mapBearing: _bearing,
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
      setState(() {
        _backCameraPosition = position;
      });
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
      setState(() {
        Provider.of<StackedMapsModel>(context, listen: false).zoom =
            position.zoom;
        _frontCameraPosition = position;
      });
      OverMap.zoomByCameraPosition(_backController, position);
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

    for (int n = 0; n < polygons.length; n++) {
      List<LatLng> polylinePoints = List.empty(growable: true);
      List<String> coordinates = polygons[n].split(' ');

      // Problem: When the map boundary has lot of polygons an out of memory crash occurs.
      // Solution: Omit small polygons when the map boundary has too many polygons.
      //
      // Note: Open Street Map Lookup API call has a 'polygon_threshold' parameter to simplify 
      // the returned polygons but this is not enough when the location has too many polygons.
      if (polygons.length > MAX_POLYGONS && coordinates.length < MIN_COORDINATES) {
        continue;
      }

      for (String coordinatePair in coordinates) {
        List<String> latLng = coordinatePair.split(',');
        if (latLng.length == 2) {
          polylinePoints
              .add(LatLng(double.parse(latLng[1]), double.parse(latLng[0])));
        }
      }

      if (polylinePoints.isNotEmpty) {
        boundaries.add(Polyline(
            polylineId: PolylineId('${polylineId.value}-$n'),
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

    if (_backPlacePolyline.isNotEmpty) {
      Set<Polyline>? copyPlacePolyline = _backPlacePolyline;
      _backPlacePolyline = _frontPlacePolyline;
      _frontPlacePolyline = copyPlacePolyline;
    }

    if (_backPlaceMarker.isNotEmpty) {
      Set<Marker>? copyPlaceMarker = _backPlaceMarker;
      _backPlaceMarker = _frontPlaceMarker;
      _frontPlaceMarker = copyPlaceMarker;
    }

    Provider.of<StackedMapsModel>(context, listen: false).switchMaps();
  }

  void setFrontMapBoundary(StackedMapsModel map) async {
    _frontPlacePolyline = <Polyline>{
      Polyline(
        polylineId: StackedMapsModel.frontPlacePolylineId,
        points: const <LatLng>[],
      ),
    };

    Set<Polyline> boundary = await getMapBoundary(
      map.frontPlace,
      StackedMapsModel.frontPlacePolylineId,
      map.frontPlaceBoundaryColor,
    ).catchError((error) {
      SnackMessage.autoHideSnackBar(
          context, AppLocalizations.of(context)!.errorRetrieveBoundaries);
      return Future(() => _frontPlacePolyline);
    });
    setState(() {
      _frontPlacePolyline = boundary;
    });
  }

  void setBackMapBoundary(StackedMapsModel map) async {
    _backPlacePolyline = <Polyline>{
      Polyline(
        polylineId: StackedMapsModel.backPlacePolylineId,
        points: const <LatLng>[],
      ),
    };

    Set<Polyline> boundary = await getMapBoundary(
      map.backPlace,
      StackedMapsModel.backPlacePolylineId,
      map.backPlaceBoundaryColor,
    ).catchError((error) {
      SnackMessage.autoHideSnackBar(
          context, AppLocalizations.of(context)!.errorRetrieveBoundaries);
      return Future(() => _backPlacePolyline);
    });
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
    return Consumer<StackedMapsModel>(builder: (context, stackedMap, child) {
      update(stackedMap);

      _opacity = stackedMap.opacity;

      List<Widget> children = stackedMaps(
        frontMap(stackedMap),
        backMap(stackedMap),
      );

      if (stackedMap.showTools == true) {
        children.add(tools);
      }

      return Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: children,
            ),
          )
        ],
      );
    });
  }
}
