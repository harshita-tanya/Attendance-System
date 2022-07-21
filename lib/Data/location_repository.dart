import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/session.dart';

class LocationRepository{
  double? totalDistance;

  double? getDistance(){
    return totalDistance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  } 

   List<double> stringToCoordinates(String location) {
    List<String> latlong = location.split(",");
    double latitude = double.parse((latlong[0].split("("))[1]);
    double longitude = double.parse((latlong[1].split(")"))[0]);
    List<double> points = [latitude, longitude];
    return points;
  }

  setMarkerList(List<Session>? sessionList, DateTime date){
    List<LatLng> locationCoordinates = [];
    int totalSessions = sessionList!.length;
    List<Session>? filteredSessions = sessionList
        .where((e) => DateTime.parse(e.date!) == date)
        .toList();
    List<dynamic>? locations = filteredSessions.map((e) {
      return e.locationChanges;
    }).toList();
    //log("location: ${locations.toString()}");
    locations.forEach((point) {
      for (var i in point) {
        i = i.toString();
        List<double> coordinates = stringToCoordinates(i);
        locationCoordinates.add(LatLng(coordinates[0], coordinates[1]));
      }
    });
    
    iterateMarkers(locationCoordinates);
    //log("coordinates: ${locationCoordinates.toSet()}");
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

    totalDistance = distance;
  }
}