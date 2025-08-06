import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_contact_list_model.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/inscreen/inChalanDetails.dart';
import 'package:task_management/view/screen/lead_note.dart';
import 'package:task_management/view/screen/lead_overview.dart';
import 'package:task_management/view/screen/leads_list.dart';
import 'package:task_management/view/screen/meeting/get_meeting.dart';
import 'package:task_management/view/screen/meeting_screen.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/screen/outscreen/chalanDetail.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:task_management/view/screen/vehical_details.dart';
import 'package:task_management/view/widgets/humangatepass/human_gatepass_details.dart';
import 'package:task_management/view/widgets/notes_folder.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('Notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'Notification action tapped with input: ${notificationResponse.input}');
  }
  if (notificationResponse.payload != null) {
    LocalNotificationService.handleNavigation(notificationResponse.payload);
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static String? pendingPayload;

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id',
      'your_channel_name',
      description: 'Your channel description',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('alarmsound'),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Foreground notification payload: ${response.payload}');
        handleNavigation(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Firebase notification clicked (background): ${message.data}');
      handleNavigation(jsonEncode(message.data));
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint(
            'Firebase notification clicked (terminated): ${message.data}');
        handleNavigation(jsonEncode(message.data));
      }
    });

    await requestBatteryOptimizationExemption();
  }

  static Future<void> requestBatteryOptimizationExemption() async {
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  static Future<void> createAndDisplayNotification(
      RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'pushnotificationapp',
        'Push Notification App',
        channelDescription: 'This channel is for push notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notificationtone'),
        fullScreenIntent: true,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint('Error displaying notification: $e');
    }
  }

  Future<void> scheduleNotification(
    DateTime dateTime,
    int notificationId,
    String title,
    String s,
  ) async {
    print('Scheduled Notification Time: $notificationId $s');

    int millisecondsUntilNotification =
        dateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      '$title $s reminder',
      '${s.contains('task') ? "Task is due!" : s.contains('sos') ? "SOS Reminder" : s.contains('event') ? "Event Reminder" : "Calendar Reminder"}',
      tz.TZDateTime.now(tz.local)
          .add(Duration(milliseconds: millisecondsUntilNotification)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your channel description',
          sound: RawResourceAndroidNotificationSound("alarmsound"),
          autoCancel: true,
          playSound: true,
          priority: Priority.max,
          enableVibration: true,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({'page': s, 'taskId': notificationId}),
    );

    Future.delayed(
        Duration(milliseconds: millisecondsUntilNotification), () {});
  }
  // {sendername: IT Administrator, senderid: 97, productid: 8, type: emi_reminder, title: EMI Due Reminder, message: EMI of 12000 due today for vehicle 789456 on 2025-07-15}
  // kiej8d99 payload data in push service {"sendername":"IT Administrator","senderid":"97","productid":"1","type":"lead","title":"Lead meeting is created","message":"Lead meeting for this lead Kallo is created"}

  // {"sendername":"IT Administrator","senderid":"97","productid":"18","type":"dailymsg"} -- daily message

  // Discussion
  // kiej8d99 payload data in push service {"sendername":"IT Administrator","senderid":"97","productid":"1","type":"leadchat","title":"Discussion & Comments","message":"New comment on lead \"Kallo\""}

  static void handleNavigation(String? payload) {
    if (payload == null) return;
    print("kiej8d99 payload data in push service ${payload}");
    debugPrint("kiej8d99 payload data in push service ${payload}");
    try {
      Map<String, dynamic> payloadData = jsonDecode(payload);
      debugPrint("Navigating to screen with payload: $payloadData");

      if (Get.context == null) {
        pendingPayload = payload;
        return;
      }
      //{"page":"followup","taskId":44}
      // {"sendername":"Nishant Kumar Schotest","senderid":"99","productid":"32","type":"leadchat","title":"Discussion & Comments","message":"New comment on lead \"weuiyiew\""}
      // {"sendername":"Nishant Kumar Schotest","senderid":"99","productid":"1","type":"leadquotation","title":"Lead Quotation is created","message":"Lead Quotation for this lead New is created"}
      // {"sendername":"Nishant Kumar Schotest","senderid":"99","productid":"38","type":"lead_followup","title":"New Lead Followup Created","message":"FollowUp for this lead New is created"}

      // {"sendername":"Nishant Kumar45","senderid":"235","productid":"70","type":"note","title":"You have successfully added a note: Sbsb","message":"Sbsb"}
      // {"sendername":"Nishant Kumar Schotest","senderid":"99","productid":"17","type":"gatepass","title":"Thank you for creating the gatepass.!","message":"you will get notified when further action is taken"}

      // {sendername: IT Administrator, senderid: 97, productid: 23, type: sos, title: You got a SOS message please check! , message: Canwinn Foundation SOS}
      // {"sendername":"Nishant Kumar","senderid":"99","productid":"37","type":"challan"}
      String? page = payloadData['page'];
      String? taskId = payloadData['taskId'].toString();

      if (payloadData['type'] == "chat") {
        Get.to(() => MessageScreen(
            payloadData['sendername'].toString(),
            payloadData['productid'].toString(),
            payloadData['senderid'].toString(),
            '',
            [],
            '',
            '',
            '',
            ''));
      } else if (payloadData['type'] == "dailymsg") {
        StorageHelper.setDailyMessage(true);
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 0;
// lead_meeting
        Get.to(() =>
            BottomNavigationBarExample(from: 'true', payloadData: payloadData));
      } else if (payloadData['type'] == "leadquotation") {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 2,
              leadNumber: '',
            ));
      } else if (payloadData['type'] == "leadchat") {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 3,
              leadNumber: '',
            ));
      } else if (payloadData['type'].toString() == "lead_followup") {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'],
              index: 1,
              leadNumber: payloadData['senderid'],
            ));
      } else if (payloadData['type'].toString() == "task") {
        Get.to(() => TaskDetails(
              taskId: int.parse(payloadData['productid'].toString()),
              assignedStatus: '',
              initialIndex: 0,
            ));
      } else if (payloadData['type'].toString().contains("todo")) {
        Get.to(() => ToDoList(''));
      } else if (payloadData['type'].toString() == "meeting") {
        Get.to(() => MeetingListScreen());
      } else if (payloadData['type'].toString() == "gatepass") {
        Get.to(() => HumanGatepassDetails(
              payloadData['productid'].toString(),
              from: 'notification',
            ));
      } else if (payloadData['type'].toString() == "lead") {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 0,
              leadNumber: '',
            ));
      } else if (payloadData['type'].toString() == 'leadchat') {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 3,
            ));
      } else if (payloadData['type'].toString() == 'lead_note') {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 5,
            ));
      } else if (payloadData['type'].toString() == 'lead_visit') {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 6,
            ));
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead notes')) {
        Get.to(LeadNoteScreen(
          leadId: payloadData['productid'].toString(),
          index: 4,
        ));
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead contact')) {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['productid'].toString(),
              index: 0,
            ));
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead meeting')) {
        Get.to(
          GetMeetingList(
            leadId: payloadData['productid'].toString(),
            contactList: <LeadContactData>[].obs,
            from: 'notification',
            addPeople: [],
            assignPeople: [],
          ),
        );
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('change lead')) {
        Get.to(
          GetMeetingList(
            leadId: payloadData['productid'].toString(),
            contactList: <LeadContactData>[].obs,
            from: 'notification',
            addPeople: [],
            assignPeople: [],
          ),
        );
      } else if (payloadData['type'].toString() == 'lead_note') {
        Get.to(LeadNoteScreen(
          leadId: payloadData['productid'].toString(),
          index: 4,
        ));
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead notes')) {
        Get.to(LeadNoteScreen(
          leadId: payloadData['productid'].toString(),
          index: 4,
        ));
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('change lead')) {
        Get.to(
          GetMeetingList(
            leadId: payloadData['productid'].toString(),
            contactList: <LeadContactData>[].obs,
            from: 'notification',
            addPeople: [],
            assignPeople: [],
          ),
        );
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('New Lead Created')) {
        Get.to(LeadList());
      } else if (payloadData['type'].toString().contains("challan")) {
        Get.to(() => InChalanDetails(payloadData['productid'.toString()]));
      } else if (payloadData['type'].toString().contains("out_challan")) {
        Get.to(() =>
            ChalanDetails(payloadData['productid'.toString()], 'notification'));
      } else if (payloadData['type'].toString().contains("project")) {
        Get.to(() => Project(''));
      } else if (payloadData['type'].toString() == "emi_reminder") {
        Get.to(() => VehicalDetails(
              vehicleId: int.parse(payloadData['productid'].toString()),
            ));
      } else if (payloadData['type'] == "note") {
        Get.to(() => NotesFolder());
      } else if (page.toString() == 'task') {
        Get.to(() => TaskDetails(
              taskId: int.parse(taskId.toString()),
              assignedStatus: '',
              initialIndex: 0,
            ));
      } else if (page.toString() == 'daily-task') {
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 0;
        Get.put<ProfileController>(ProfileController())
            .dailyTaskList(Get.context!, 'reminder', payloadData['taskId']);
        Get.to(() => BottomNavigationBarExample(
            from: 'reminder', payloadData: payloadData));
      } else if (page.toString().contains('event')) {
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 2;
        Get.to(() =>
            BottomNavigationBarExample(from: '', payloadData: payloadData));
      } else if (page.toString() == 'meeting') {
        Get.to(() => MeetingListScreen());
      } else if (page.toString().contains('calender')) {
        Get.to(() => CalendarScreen(''));
      } else if (page.toString().contains('todo')) {
        Get.to(() => ToDoList(''));
      } else if (page.toString() == 'lead_meeting') {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['taskId'].toString(),
              index: 6,
            ));
      } else if (page.toString().contains('followup')) {
        Get.to(() => LeadOverviewScreen(
              leadId: payloadData['taskId'].toString(),
              index: 1,
            ));
      }
    } catch (e) {
      debugPrint("Error decoding navigation payload: $e");
    }
  }

  static void checkPendingNotification() {
    if (pendingPayload != null) {
      handleNavigation(pendingPayload);
      pendingPayload = null;
    }
  }

  // static void onStart(ServiceInstance service) {
  //   debugPrint('Background service running...');
  // }
}
