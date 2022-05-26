import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../app_scaffold.dart';
import '../../common/layout_service.dart';
import '../../common/mapbox/mapbox_draw_service.dart';
import './meditators.dart';

class MeditateMap extends StatefulWidget {
  double mapHeight;
  MeditateMap({ this.mapHeight = double.infinity });
  @override
  _MeditateMapState createState() => _MeditateMapState();
}

class _MeditateMapState extends State<MeditateMap> {
  LayoutService _layoutService = LayoutService();
  MapboxDrawService _mapboxDrawService = MapboxDrawService();

  var _meditatorLngLats = [];

  MapboxMap? _map;
  bool _mapReady = false;
  late MapboxMapController _mapController;
  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(8.993036, -79.574983),
    zoom: 1,
  );
  CameraPosition _position = _initialPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.mapHeight;
    if (widget.mapHeight == double.infinity) {
      // Subtract header height.
      height = MediaQuery.of(context).size.height - _layoutService.headerHeight - 1;
    }

    _map = MapboxMap(
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
      //styleString: MapboxStyles.SATELLITE,
      onMapCreated: onMapCreated,
      onStyleLoadedCallback: () => onStyleLoaded(),
      initialCameraPosition: _initialPosition,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: height,
          child: _map,
        ),
        SizedBox(height: 10),
        Meditators(),
        SizedBox(height: 10),
      ]
    );
  }

  void onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  void onStyleLoaded() {
    _mapReady = true;
    getMeditatorLngLats();
  }

  void getMeditatorLngLats() {
    _meditatorLngLats = [
      [-77.031952, 38.913184],
      [-122.413682, 37.775408],
      [102.0, 0.5],
    ];
    setMeditatorPoints(_meditatorLngLats);
  }

  void setMeditatorPoints(lngLats) async {
    //Map<String, dynamic> geojsonData = {
    //  'type': 'FeatureCollection',
    //  'features': [],
    //};
    //for (int ii = 0; ii < lngLats.length; ii++) {
    //  geojsonData['features'].add({
    //    'type': 'Feature',
    //    'geometry': {
    //      'type': 'Point',
    //      'coordinates': lngLats[ii],
    //    },
    //    'properties': {
    //      'marker-color': '#3bb2d0',
    //      'marker-size': 'large',
    //      'marker-symbol': 'rocket'
    //    },
    //    'id': 'meditator_${ii.toString()}',
    //  });
    //}
    //String id = 'id1';
    //print ('geojson ${geojsonData}');
    //_mapController.addGeoJsonSource(id, geojsonData);
    for (int ii = 0; ii < lngLats.length; ii++) {
      LatLng latLng = _mapboxDrawService.coordinateToLatLng(lngLats[ii]);
      var circle = await _mapboxDrawService.drawPolygonCircle(latLng, _mapController);
    }
  }
}
