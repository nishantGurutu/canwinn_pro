import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';

String deviceTokenToSendPushNotification = '';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseNotification(
  BuildContext context,
) async {
  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      /// here app is a background state
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message?.notification != null) {
        Map<String, String> finalPayLoadData =
            Map<String, String>.from(message!.data);
        // LocalNotificationService.handleNavigation(jsonEncode(message.data));

        print(
            "------Killed---------finalPayLoadData--------------:: ${finalPayLoadData}");
      }
    },
  );

  ///2. This method only call when App in foreground it mean app must be opened
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      debugPrint(
          "FirebaseMessaging.onMessage.listen ----------------------------------------------------");
      // Get.to(() => BottomNavigationBarExample(from: ''));

      /// here app is a  live state
      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        debugPrint("${message.notification!.bodyLocArgs}");
        debugPrint(message.notification!.bodyLocKey);
        debugPrint("${message.data}");
        debugPrint(message.data['type']);
        LocalNotificationService.createAndDisplayNotification(message);
      }
      debugPrint(
          "FirebaseMessaging.onMessage.listen close --------------------------------------------------");
    },
  );

  /// 3. This method only call when App in background and not terminated
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      /// here app is a background state
      print(
          "------background---------message.notification!.title--------------:: ${message.notification!.title}");
      print(
          "------background---------message.notification!.body--------------:: ${message.notification!.body}");
      print(
          "------background---------message.notification!.body--------------:: ${message.data['data']}");
      print(
          "------background---------message.notification!.body--------------:: ${message.data}");
      debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        // ignore: unused_local_variable
        Map<String, String> finalPayLoadData =
            Map<String, String>.from(message.data);
        // LocalNotificationService.handleNavigation(jsonEncode(message.data));
      } else {
        print("Firebse Messaging message data ${message.data}");
        print("Firebse Messaging message data 2 ${message.notification}");
      }
    },
  );

  /// Get our device token here
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final token = await _fcm.getToken();
  deviceTokenToSendPushNotification = token.toString();
  print(
      "My Device Token ==================> $deviceTokenToSendPushNotification");
  RegisterController().fcm_token_api(deviceTokenToSendPushNotification);
}
