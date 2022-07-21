import 'dart:async';
import 'dart:developer' as log_value;
import 'dart:math';
import 'package:erp_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/session.dart';

class MapScreen extends StatefulWidget {
  final List<dynamic>? sessions;
  final List<Session>? sessionList;
  final DateTime? date;
  const MapScreen({Key? key, this.sessions, this.sessionList, this.date})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markerList = [];
  List<LatLng> locationCoordinates = [];
  final Set<Polyline> _polyline = {};
  final Completer<GoogleMapController> _controller = Completer();
  int index = 0;

  setMarkerList() {
    int totalSessions = widget.sessionList!.length;
    List<Session>? filteredSessions = widget.sessionList!
        .where((e) => DateTime.parse(e.date!) == widget.date)
        .toList();
    List<dynamic>? locations = filteredSessions.map((e) {
      return e.locationChanges;
    }).toList();
    log_value.log("location: ${locations.toString()}");
    locations.forEach((point) {
      for (var i in point) {
        i = i.toString();
        List<double> coordinates = stringToCoordinates(i);
        locationCoordinates.add(LatLng(coordinates[0], coordinates[1]));

        Marker marker = Marker(
            markerId: MarkerId(UtilityHelper.generatePassword()),
            infoWindow:
                InfoWindow(title: "Location ${locations.indexOf(point)}"),
            position: LatLng(
              coordinates[0],
              coordinates[1],
            ));
        markerList.add(marker);
      }
    });
    iterateMarkers(locationCoordinates);
    log_value.log("coordinates: ${locationCoordinates.toSet()}");
  }

  List<double> stringToCoordinates(String location) {
    List<String> latlong = location.split(",");
    double latitude = double.parse((latlong[0].split("("))[1]);
    double longitude = double.parse((latlong[1].split(")"))[0]);
    List<double> points = [latitude, longitude];
    log_value.log("location points: ${points.toString()}");
    return points;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  iterateMarkers(List<LatLng> locations) {
    double distance = 0;
    List<LatLng> locationSet = locations.toSet().toList();

    for (int index = 0; index < locationSet.length - 1; index++) {
      distance = distance +
          calculateDistance(
              locationSet[index].latitude,
              locationSet[index].longitude,
              locationSet[index + 1].latitude,
              locationSet[index + 1].longitude);
    }
    log_value.log("distance: $distance");
  }

  @override
  void initState() {
    setMarkerList();
    log_value.log(markerList.toSet().length.toString());
    _polyline.add(Polyline(
        color: Colors.blueAccent,
        width: 5,
        polylineId: PolylineId(UtilityHelper.generatePassword()),
        points: locationCoordinates));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: markerList.toSet(),
              polylines: _polyline,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: locationCoordinates[0],
                zoom: 6,
              ),
              mapType: MapType.hybrid,
            ),
            Positioned(
              left: 10.0,
              top: 20.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
