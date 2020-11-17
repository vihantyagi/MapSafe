import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'search.dart';

class Routing extends StatelessWidget {
  // Use _context only within the scope of this widget.
  BuildContext _context;
  HereMapController _hereMapController;
  List<MapPolyline> _mapPolylines = [];
  RoutingEngine _routingEngine;
  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();
  Search p;
  double ln, la;
  String lOne;


  @override
  Widget build(BuildContext context) {
    _context = context;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            HereMap(onMapCreated: _onMapCreated),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: RawMaterialButton(
                    onPressed: () {
                      addRoute();
                    },
                    elevation: 2.0,
                    fillColor: Colors.blue.shade900,
                    child: Icon (
                      Icons.directions,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 80, 10),
                  child: Container(

                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                        border: new Border.all(
                        color: Colors.black54,
                        width: 1.0
                        ),
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller:  startAddressController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.blue.shade900,
                        ),
                        labelText: 'Starting point',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,100, 0,0),
                  child: RawMaterialButton(
                    onPressed: () {
                      clearMap();
                    },
                    elevation: 2.0,
                    fillColor: Colors.blue.shade900,
                    child: Icon (
                      Icons.clear,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 100, 80, 0),
                  child: Container(
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                          color: Colors.black54,
                          width: 1.0
                      ),
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller:  destinationAddressController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.blue.shade900,
                        ),
                        labelText: 'Destination',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 0, 10),
                      child: RawMaterialButton(
                        onPressed: () {
                          getCurrentLocation();
                        },
                        elevation: 2.0,
                        fillColor: Colors.blue.shade900,
                        child:  Icon(
                          Icons.my_location,
                          size: 40 ,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
            (MapError error) {
          if (error == null) {
            RoutingExample(_context, hereMapController);
          } else {
            print("Map scene not loaded. MapError: " + error.toString());
          }
        });
  }

  getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double distanceToEarthInMeters = 1000;
    _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(position.latitude , position.longitude), distanceToEarthInMeters);
  }

  // A helper method to add a button on top of the HERE map.
  Align button(String buttonLabel, Function callbackFunction) {
    return Align(
      alignment: Alignment.topCenter,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        textColor: Colors.white,
        onPressed: () => callbackFunction(),
        child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  RoutingExample(BuildContext context, HereMapController hereMapController) {
    _context = context;
    _hereMapController = hereMapController;

    double distanceToEarthInMeters = 10000;
    _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(28.450755, 77.584128), distanceToEarthInMeters);

    _routingEngine = new RoutingEngine();
  }

  Future<void> addRoute() async {
    var startGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var destinationGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);

    List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
            (RoutingError routingError, List<here.Route> routeList) async {
          if (routingError == null) {
            here.Route route = routeList.first;
            _showRouteDetails(route);
            _showRouteOnMap(route);
          } else {
            var error = routingError.toString();
            _showDialog('Error', 'Error while calculating a route: $error');
          }
        });
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  void _showRouteDetails(here.Route route) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;

    String routeDetails = 'Travel Time: ' +
        _formatTime(estimatedTravelTimeInSeconds) +
        ', Length: ' +
        _formatLength(lengthInMeters);

    _showDialog('Route Details', '$routeDetails');
  }

  String _formatTime(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    return '$hours:$minutes min';
  }

  String _formatLength(int meters) {
    int kilometers = meters ~/ 1000;
    int remainingMeters = meters % 1000;

    return '$kilometers.$remainingMeters km';
  }

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);

    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));

    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  GeoCoordinates _createRandomGeoCoordinatesInViewport() {
    GeoBox geoBox = _hereMapController.camera.boundingBox;
    if (geoBox == null) {
      // Happens only when map is not fully covering the viewport.
      return GeoCoordinates(52.530932, 13.384915);
    }

    GeoCoordinates northEast = geoBox.northEastCorner;
    GeoCoordinates southWest = geoBox.southWestCorner;

    double minLat = southWest.latitude;
    double maxLat = northEast.latitude;
    double lat = _getRandom(minLat, maxLat);

    double minLon = southWest.longitude;
    double maxLon = northEast.longitude;
    double lon = _getRandom(minLon, maxLon);

    return new GeoCoordinates(lat, lon);
  }

  double _getRandom(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
