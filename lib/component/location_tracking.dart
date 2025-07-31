// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart' as perm;
// import 'package:geocoding/geocoding.dart' as geocode;
// import 'package:task_management/constant/custom_toast.dart';
// import 'package:task_management/helper/db_helper.dart';
// import 'package:task_management/service/location_tracking_service.dart';

// class LocationTrackerService {
//   static final Location _location = Location();
//   static final DatabaseHelper _dbHelper = DatabaseHelper.instance;
//   static final LocationTrackingService _trackingService =
//       LocationTrackingService();
//   static Timer? _syncTimer;

//   static Future<bool> initialize() async {
//     try {
//       print('Initializing LocationTrackerService...');
//       print('DatabaseHelper instance: $_dbHelper');
//       print('Location instance: $_location');
//       print('LocationTrackingService instance: $_trackingService');

//       bool serviceEnabled = await _location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await _location.requestService();
//         if (!serviceEnabled) {
//           print('Location service is disabled.');
//           return false;
//         }
//       }

//       PermissionStatus permissionGranted = await _location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await _location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted &&
//             permissionGranted != PermissionStatus.grantedLimited) {
//           print('Location permission denied.');
//           return false;
//         }
//       }

//       startPeriodicSync();

//       return true;
//     } catch (e) {
//       print('Error initializing location service: $e');
//       return false;
//     }
//   }

//   static void startPeriodicSync() {
//     _syncTimer?.cancel();
//     _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
//       try {
//         print('Attempting periodic sync at ${DateTime.now()}');
//         var connectivityResult = await Connectivity().checkConnectivity();
//         if (connectivityResult == ConnectivityResult.none) {
//           print('No network available, skipping sync.');
//           return;
//         }
//         await _trackingService.syncLocationsToApi();
//       } catch (e) {
//         print('Error in periodic sync: $e');
//       }
//     });
//   }

//   static void stopPeriodicSync() {
//     _syncTimer?.cancel();
//     _syncTimer = null;
//     print('Periodic sync stopped.');
//   }

//   Future<LocationData?> getCurrentLocation() async {
//     try {
//       await _getLocation();
//       return _currentPosition;
//     } catch (e) {
//       print('Error getting current location: $e');
//       return null;
//     }
//   }

//   static Future<bool> enableBackgroundMode() async {
//     try {
//       bool hasPermissions = await _requestLocationPermissions();
//       if (!hasPermissions) {
//         print('Required permissions not granted for background mode.');
//         return false;
//       }

//       bool isBackgroundEnabled = await _location.isBackgroundModeEnabled();
//       if (!isBackgroundEnabled) {
//         await _location.enableBackgroundMode(enable: true);
//         print('Background mode enabled.');
//       }
//       return true;
//     } catch (e) {
//       print('Error enabling background location: $e');
//       return false;
//     }
//   }

//   static Future<bool> _requestLocationPermissions() async {
//     try {
//       Map<perm.Permission, perm.PermissionStatus> statuses = await [
//         perm.Permission.location,
//         perm.Permission.locationWhenInUse,
//         perm.Permission.locationAlways,
//       ].request();

//       bool isLocationGranted = statuses[perm.Permission.location]!.isGranted ||
//           statuses[perm.Permission.locationWhenInUse]!.isGranted;
//       bool isBackgroundGranted =
//           statuses[perm.Permission.locationAlways]!.isGranted;

//       if (!isLocationGranted) {
//         print('Location permission denied.');
//         return false;
//       }

//       if (!isBackgroundGranted && (await _requiresBackgroundLocation())) {
//         print('Background location permission denied.');
//         return false;
//       }

//       return true;
//     } catch (e) {
//       print('Error requesting permissions: $e');
//       return false;
//     }
//   }

//   static Future<bool> _requiresBackgroundLocation() async {
//     return true;
//   }

//   Location location = Location();
//   LocationData? _currentPosition;
//   String _currentAddress = "";

//   Future<void> _getLocation() async {
//     try {
//       LocationData initialLocation = await location.getLocation();
//       if (initialLocation.latitude != null &&
//           initialLocation.longitude != null) {
//         _currentPosition = initialLocation;
//         await _storeLocationInDb(initialLocation);
//         await _getAddressFromLatLng(
//             initialLocation.latitude!, initialLocation.longitude!);

//         var connectivityResult = await Connectivity().checkConnectivity();
//         if (connectivityResult != ConnectivityResult.none) {
//           await _trackingService.syncLocationsToApi();
//         }
//       }

//       location.onLocationChanged.listen((LocationData currentLocation) async {
//         try {
//           if (currentLocation.latitude != null &&
//               currentLocation.longitude != null) {
//             _currentPosition = currentLocation;
//             CustomToast().showCustomToast(
//                 'Locations synced successfully. $_currentPosition');
//             print(
//                 'Location Updated: ${currentLocation.latitude}, ${currentLocation.longitude}');
//             await _storeLocationInDb(currentLocation);
//             await _getAddressFromLatLng(
//                 currentLocation.latitude!, currentLocation.longitude!);

//             var connectivityResult = await Connectivity().checkConnectivity();
//             if (connectivityResult != ConnectivityResult.none) {
//               await _trackingService.syncLocationsToApi();
//             }
//           }
//         } catch (e) {
//           print('Error in location listener: $e');
//         }
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }

//   Future<void> _storeLocationInDb(LocationData locationData) async {
//     try {
//       await _dbHelper.insertLocation(
//         locationData.latitude!,
//         locationData.longitude!,
//         DateTime.now().toIso8601String(),
//       );
//     } catch (e) {
//       print('Error storing location in database: $e');
//     }
//   }

//   Future<void> _getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<geocode.Placemark> placemarks =
//           await geocode.placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         geocode.Placemark place = placemarks[0];
//         _currentAddress =
//             "${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}";
//         print('Address: $_currentAddress');
//       } else {
//         _currentAddress = "Address not found";
//         print('No placemarks found for coordinates: $lat, $lng');
//       }
//     } catch (e) {
//       print('Error getting address: $e');
//       _currentAddress = "Error retrieving address";
//     }
//   }

//   String get currentAddress => _currentAddress;
// }
