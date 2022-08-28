//import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'dart:developer';
import 'package:location/location.dart';

class LocationService {
  LocationData? _currentPosition;
  Location location = Location();

  Future<LocationData> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log("service denied");
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        log("permission not granted");
      }
    }

    LocationData currentLocation = await location.getLocation();
    log(currentLocation.toString());
    return currentLocation;
  }

  listenLocationChanges() {
    List<LocationData>? locations;

    StreamSubscription<LocationData> locationStream =
        location.onLocationChanged.listen((LocationData locationData) {
        
    });

    locationStream.onData((data) {
      locations!.add(data);
    });

    log(locations.toString());
  }
}


