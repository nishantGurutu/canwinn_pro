import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:task_management/component/permission_denied_dialog.dart';

class LocationHandler {
  static bool locationPermissionDeniedForever = false;
  static Position? position;
  static LatLng? currentPosition;
  static geocoding.Placemark? place;

  static Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    locationPermissionDeniedForever = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Location().requestService();
      determinePosition(context);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationPermissionDeniedForever = true;
      showDialog(
        context: context,
        builder: (_) => const PermissionDeniedDialog(),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    currentPosition = LatLng(position!.latitude, position!.longitude);
    await getPositionOfUser(context);
    return await Geolocator.getCurrentPosition();
  }

  static getCurrentLatlLong() async {
    return await Geolocator.getCurrentPosition();
  }

  static getPositionOfUser(BuildContext context) async {
    if (position?.latitude != null) {
      List<geocoding.Placemark> placeMarks = await geocoding
          .placemarkFromCoordinates(position!.latitude, position!.longitude);
      String? addressLength = "${placeMarks[1]}";
      place = placeMarks[0];
      print("=================================================   $place");
      print(
          "================================================= length  == $addressLength");
      return place;
    }
  }
}
