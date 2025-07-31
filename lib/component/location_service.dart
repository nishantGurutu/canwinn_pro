import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:task_management/helper/storage_helper.dart';

class LocationService {
  static late Location location;
  static late LocationData locationData;
  static late bool serviceEnabled;
  static late PermissionStatus permissionStatus;

  static initialize() async {
    location = Location();
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    if (StorageHelper.getUserLocationName() == null) {
      if (locationData.latitude != null && locationData.longitude != null) {
        List<geocode.Placemark> placemarks =
            await geocode.placemarkFromCoordinates(
                locationData.latitude!, locationData.longitude!);
        StorageHelper.setUserLocationName(placemarks[0].subLocality ?? '');
      }
    }
  }

  static Future<bool> requestLocationService() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionStatus = await location.requestPermission();
    if (permissionStatus == PermissionStatus.granted) {
      locationData = await location.getLocation();
      return true;
    } else {
      return false;
    }
  }
}
