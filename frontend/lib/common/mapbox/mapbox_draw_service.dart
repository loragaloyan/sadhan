import 'package:mapbox_gl/mapbox_gl.dart';

import '../colors_service.dart';

class MapboxDrawService {
  MapboxDrawService._privateConstructor();
  static final MapboxDrawService _instance = MapboxDrawService._privateConstructor();
  factory MapboxDrawService() {
    return _instance;
  }

  ColorsService _colorsService = ColorsService();

  LatLng coordinateToLatLng(coordinate) {
    LatLng latLng = LatLng(
      coordinate[1],   // lat
      coordinate[0],   // lon
    );
    return latLng;
  }

  Future<Line> drawPolygonEdgeLine(List<LatLng> latLngs, MapboxMapController controller, 
    {String color = 'red'}) async {
    return controller.addLine(
      LineOptions(
        lineBlur: 0,
        lineGapWidth: 0,
        lineOpacity: 1,
        lineWidth: 2,
        lineOffset: 0,
        geometry: latLngs,
        lineColor: _colorsService.colorsStr[color],
      ),
    ); 
  }

  Future<Circle> drawPolygonCircle(LatLng latLng, MapboxMapController controller,
    {String color = 'magenta'}) async {
    return controller.addCircle(
      CircleOptions(
        geometry: latLng,
        draggable: false,  //TODO: Lines move with vertex when it is dragged
        circleOpacity: 1,
        circleRadius: 8,
        circleBlur: 0,
        circleStrokeOpacity: 0,
        circleStrokeWidth: 0,
        circleColor: _colorsService.colorsStr[color],
        circleStrokeColor: _colorsService.colorsStr[color],
      ),
    );
  }

  Future<Fill> drawPolygonFill(List<List<LatLng>> latLngs, MapboxMapController controller,
    { String color = 'magentaTransparent' }) async {
    return controller.addFill(
      FillOptions(
        geometry: latLngs,
        draggable: false,  //TODO: Lines move with vertex when it is dragged
        fillOpacity: 1,
        fillColor: _colorsService.colorsStr[color],
        fillOutlineColor: _colorsService.colorsStr[color],
      ),
    );
  }

  Future<String> drawPolygon(List<dynamic> coordinates, MapboxMapController controller,
    { bool drawFill = false }) async {
    int count = 0;
    LatLng? prevLatLng = null;
    List<LatLng> latLngs = [];
    for (var coordinate in coordinates) {
      LatLng currentLatLng = coordinateToLatLng(coordinate);
      if (count > 0) {
        Line line = await drawPolygonEdgeLine([prevLatLng!, currentLatLng], controller, color: 'greyDark');
      }
      prevLatLng = currentLatLng;
      latLngs.add(currentLatLng);
      count += 1;
    }
    if (drawFill) {
      Fill fill = await drawPolygonFill([latLngs], controller, color: 'greyTransparent');
    }
    return '';
  }
}
