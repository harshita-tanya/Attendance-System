import 'dart:math';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erp_app/Models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/session.dart';

class LocationRepository{
  double? totalDistance;

  double? getDistance(List<Session>? sessionList, DateTime date){
    setMarkerList(sessionList, date);
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

  setMarkerList(List<Session>? sessionList, DateTime date){
    List<LatLng> locationCoordinates = [];
    int totalSessions = sessionList!.length;
    List<Session>? filteredSessions = sessionList
        .where((e) => DateTime.parse(e.date!) == date)
        .toList();
    List<List<GeoPoint>?> locations = filteredSessions.map((e) {
      return e.locationChanges;
    }).toList();
    //log("location: ${locations.toString()}");
    
    locations.forEach((point) {
      for (var i in point!) {
        locationCoordinates.add(LatLng(i.latitude, i.longitude));
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

  List<Session?> getSessionList(String date, Employee employee){
    dev.log(date.toString());
    List<Session?>? finalSessionList = [];
    List<Session?> sessions = employee.sessions!.map((session){
       if(session.date == date){
         return session;
       }
    }).toList();
    for(var session in sessions){
      if(![null].contains(session)){
        finalSessionList.add(session);
      }
    }
    dev.log(finalSessionList.toString());
    return finalSessionList;
  }
}