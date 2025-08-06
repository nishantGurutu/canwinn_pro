import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller_binding.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/network_service.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/inscreen/inChalanDetails.dart';
import 'package:task_management/view/screen/lead_overview.dart';
import 'package:task_management/view/screen/meeting_screen.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/screen/outscreen/chalanDetail.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:task_management/view/screen/vehical_details.dart';
import 'package:task_management/view/widgets/humangatepass/human_gatepass_details.dart';
import 'package:task_management/view/widgets/notes_folder.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:geolocator/geolocator.dart' as geolocator;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final BottomBarController bottomBarController = Get.put(BottomBarController());

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String? messageData = jsonEncode(message.data);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  tz.initializeTimeZones();
  await requestPermissions();
  await requestPermissionHandlar();
  await StorageHelper.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      await _firebaseMessagingBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  await LocalNotificationService.initialize();
  // await LocationTrackerService.initialize();
  // await _handleLocationPermissionAndGPS();
  // await initializeService();
  // await LocationTrackerService.enableBackgroundMode();
  // await LocationTrackerService.initialize();
  // await LocationTrackerService.enableBackgroundMode();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  NetworkService().startMonitoring();
  NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  String? firebasePayload =
      await initialMessage != null ? jsonEncode(initialMessage?.data) : null;

  String? localPayload =
      await notificationAppLaunchDetails?.notificationResponse?.payload;

  debugPrint('Firebase remote message: $firebasePayload');
  debugPrint('Local notification payload: $localPayload');

  String? initialPayload = firebasePayload ?? localPayload;

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      child: MyApp(
        initialPayload: initialPayload,
      ),
    ),
  );
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       autoStartOnBoot: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );
// }

// Future<bool> _handleLocationPermissionAndGPS() async {
//   if (!await _requestLocationPermission()) {
//     return false;
//   }

//   if (!await _isGPSEnabled()) {
//     return false;
//   }

//   return true;
// }

// Future<bool> _requestLocationPermission() async {
//   var status = await Permission.locationWhenInUse.status;
//   if (!status.isGranted) {
//     status = await Permission.locationWhenInUse.request();
//     if (!status.isGranted) {
//       if (status.isPermanentlyDenied) {
//         await openAppSettings();
//       } else {
//         // Fluttertoast.showToast(
//         //   msg: "Location services are disabled. Please enable the services.",
//         //   toastLength: Toast.LENGTH_SHORT,
//         //   gravity: ToastGravity.CENTER,
//         //   timeInSecForIosWeb: 1,
//         //   backgroundColor: Colors.red,
//         //   textColor: Colors.white,
//         //   fontSize: 16.0,
//         // );
//       }
//       return false;
//     }
//   }

//   status = await Permission.locationAlways.status;
//   if (!status.isGranted) {
//     status = await Permission.locationAlways.request();
//     if (!status.isGranted) {
//       if (status.isPermanentlyDenied) {
//         await openAppSettings();
//       } else {
//         Get.showSnackbar(
//           const GetSnackBar(
//             title: "Location services are disabled. Please enable the services",
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//       return false;
//     }
//   }
//   return true;
// }

Future<bool> _isGPSEnabled() async {
  bool serviceEnabled;
  geolocator.LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, prompt the user to enable them.
    Fluttertoast.showToast(
      msg: "GPS is disabled. Please enable the GPS.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    return false;
  }

  return true;
}

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   Timer.periodic(const Duration(seconds: 5), (timer) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     // Fetch current location
//     geolocator.Position? position;
//     try {
//       position = await geolocator.Geolocator.getCurrentPosition(
//         // ignore: deprecated_member_use
//         desiredAccuracy: geolocator.LocationAccuracy.high,
//       );
//     } catch (e) {
//       print('Failed to get location: $e');
//     }

//     // Add log with timestamp and location info
//     final log = preferences.getStringList('log') ?? <String>[];
//     final currentTime = DateTime.now().toIso8601String();
//     final locationInfo = position != null
//         ? 'Lat: ${position.latitude}, Lon: ${position.longitude}'
//         : 'Location not available';

//     log.add('$currentTime - $locationInfo');
//     _storeLocationInDb(lat: position?.latitude, lon: position?.longitude);

//     // preferences.setString("token", loginModel.data?.token ?? "");

//     // await LocationTrackingService().syncLocationsToApi();

//     // await LocationTrackingService().syncLocationsToApi();
//     await preferences.setStringList('log', log);

//     // Fluttertoast.showToast(
//     //   msg: "FLUTTER BACKGROUND SERVICE: $currentTime - $locationInfo'",
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   gravity: ToastGravity.CENTER,
//     //   timeInSecForIosWeb: 1,
//     //   backgroundColor: Colors.red,
//     //   textColor: Colors.white,
//     //   fontSize: 16.0,
//     // );
//     print('FLUTTER BACKGROUND SERVICE: $currentTime - $locationInfo');

//     service.invoke('update', {
//       "current_date": currentTime,
//       "location": locationInfo,
//     });
//   });
// }

DatabaseHelper _dbHelper = DatabaseHelper.instance;
Future<void> _storeLocationInDb({double? lat, double? lon}) async {
  try {
    await _dbHelper.insertLocation(
      lat ?? 0.0,
      lon ?? 0,
      DateTime.now().toIso8601String(),
    );
  } catch (e) {
    print('Error storing location in database: $e');
  }
}

// End location service

Location location = Location();
LocationData? _currentPosition;
String _currentAddress = "";

Future<void> requestPermissionHandlar() async {
  if (await Permission.ignoreBatteryOptimizations.isDenied) {
    await Permission.ignoreBatteryOptimizations.request();
  }
}

Future<void> requestPermissions() async {
  await [
    Permission.notification,
    Permission.locationWhenInUse,
    Permission.locationAlways,
    Permission.accessMediaLocation,
    Permission.location,
    Permission.locationAlways,
    Permission.camera,
    Permission.microphone,
    Permission.notification,
    Permission.bluetooth,
  ].request();
}

Future<void> requestNotificationPermission() async {
  final NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('Notification permission status: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  final String? initialPayload;

  MyApp({super.key, this.initialPayload});
  final BottomBarController bottomBarController =
      Get.put(BottomBarController());
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Task Management',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialBinding: ControllerBinding(),
          home: _getInitialScreen(),
        );
      },
    );
  }

  Widget _getInitialScreen() {
    print('task list data in main payload data 873yd83u9 ${initialPayload}');
    if (initialPayload == null) {
      return const SplashScreen();
    }

    Map<String, dynamic> payloadData = jsonDecode(initialPayload!);

    if (payloadData['type'] == "chat") {
      return MessageScreen(
          payloadData['sendername'].toString(),
          payloadData['productid'].toString(),
          payloadData['senderid'].toString(),
          '',
          [],
          '',
          '',
          '',
          'notification');
    } else if (payloadData['type'].toString() == "dailymsg") {
      print('Navigating from main dailymsg ${initialPayload}');
      StorageHelper.setDailyMessage(true);
      bottomBarController.currentPageIndex.value = 0;
      return BottomNavigationBarExample(from: 'true', payloadData: payloadData);
    } else if (payloadData['type'] == "note") {
      return NotesFolder();
    } else if (payloadData['type'].toString() == "task" ||
        payloadData['type'].toString().contains("task_list")) {
      return TaskDetails(
        taskId: int.parse(payloadData['productid'].toString()),
        assignedStatus: '',
        initialIndex: 0,
      );
    } else if (payloadData['type'].toString().contains("todo")) {
      return ToDoList('');
    } else if (payloadData['type'].toString() == "gatepass") {
      return HumanGatepassDetails(
        payloadData['productid'].toString(),
        from: 'notification',
      );
    } else if (payloadData['type'].toString() == "meeting") {
      return MeetingListScreen();
    } else if (payloadData['type'].toString().contains("challan")) {
      return InChalanDetails(payloadData['productid'.toString()]);
    } else if (payloadData['type'].toString().contains("out_challan")) {
      return ChalanDetails(payloadData['productid'.toString()], 'notification');
    } else if (payloadData['type'].toString() == "sos") {
      bottomBarController.currentPageIndex.value = 0;
      return BottomNavigationBarExample(from: 'true', payloadData: payloadData);
    } else if (payloadData['type'].toString().contains("project")) {
      return Project('notification');
    } else if (payloadData['page'].toString() == "task") {
      return TaskDetails(
        taskId: int.parse(
          payloadData['taskId'].toString(),
        ),
        assignedStatus: '',
        initialIndex: 0,
      );
    } else if (payloadData['page'].toString() == "daily-task") {
      bottomBarController.currentPageIndex.value = 0;
      return BottomNavigationBarExample(
          from: 'reminder', payloadData: payloadData);
    } else if (payloadData['page'].toString().contains("todo")) {
      return ToDoList('');
    } else if (payloadData['type'].toString() == "emi_reminder") {
      return VehicalDetails(
        vehicleId: int.parse(payloadData['productid'].toString()),
      );
    } else if (payloadData['page'].toString() == "meeting") {
      return MeetingListScreen();
    } else if (payloadData['page'].toString() == "event") {
      bottomBarController.currentPageIndex.value = 2;
      return BottomNavigationBarExample(from: '', payloadData: payloadData);
    } else if (payloadData['page'].toString().contains("calender")) {
      return CalendarScreen('notification');
    } else if (payloadData['type'].toString() == "lead_followup") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'],
        index: 1,
        leadNumber: payloadData['senderid'],
      );
    } else if (payloadData['type'].toString() == "leadquotation") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'].toString(),
        index: 2,
        leadNumber: '',
      );
    } else if (payloadData['type'].toString() == "leadchat") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'].toString(),
        index: 3,
        leadNumber: '',
      );
    } else if (payloadData['type'].toString() == "lead_note") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'].toString(),
        index: 5,
        leadNumber: '',
      );
    } else if (payloadData['type'].toString() == "lead") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'].toString(),
        index: 0,
        leadNumber: '',
      );
    } else if (payloadData['type'].toString() == "lead_visit") {
      return LeadOverviewScreen(
        leadId: payloadData['productid'].toString(),
        index: 6,
        leadNumber: '',
      );
    } else if (payloadData['page'].toString() == "followup") {
      return LeadOverviewScreen(
        leadId: payloadData['taskId'].toString(),
        index: 1,
      );
    } else if (payloadData['page'].toString() == "lead_meeting") {
      return LeadOverviewScreen(
        leadId: payloadData['taskId'].toString(),
        index: 6,
      );
    }
    return const SplashScreen();
  }
}
