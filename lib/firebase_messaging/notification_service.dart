import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:task_management/view/screen/outscreen/user_chalan_details.dart';
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
  debugPrint(
    'Notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
      'Notification action tapped with input: ${notificationResponse.input}',
    );
  }
  if (notificationResponse.payload != null) {
    LocalNotificationService.handleNavigation(notificationResponse.payload);
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static String? pendingPayload;
  static final AudioPlayer _audioPlayer = AudioPlayer();

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
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Foreground notification payload: ${response.payload}');

        if (response.actionId != null &&
            response.actionId!.startsWith("STOP_")) {
          int id =
              int.tryParse(response.actionId!.replaceFirst("STOP_", "")) ?? 0;
          await _notificationsPlugin.cancel(id); // ⛔ stop this alarm
          print("⏹️ Alarm $id stopped by user.");
          return; // don’t call handleNavigation if Stop
        }

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

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        debugPrint(
          'Firebase notification clicked (terminated): ${message.data}',
        );
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
    RemoteMessage message,
  ) async {
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

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

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
    String reminderTimeType,
    String selectAlarmTyle,
  ) async {
    print('Scheduled Notification Time: $notificationId $s');

    final millisecondsUntilNotification =
        dateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your channel description',
        sound: RawResourceAndroidNotificationSound("alarmtone"),
        autoCancel: false,
        playSound: true,
        priority: Priority.max,
        importance: Importance.max,
        enableVibration: true,
        fullScreenIntent: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'STOP_$notificationId',
            'Stop',
            showsUserInterface: true,
            cancelNotification: false,
          ),
        ],
      ),
    );
    if (selectAlarmTyle == "Not Repeated") {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        '$title $s reminder',
        s.contains('task')
            ? "Task is due!"
            : s.contains('sos')
            ? "SOS Reminder"
            : s.contains('event')
            ? "Event Reminder"
            : "Calendar Reminder",
        tz.TZDateTime.now(
          tz.local,
        ).add(Duration(milliseconds: millisecondsUntilNotification)),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode({'page': s, 'taskId': notificationId}),
      );
    } else if (selectAlarmTyle == 'Repeated') {
      if (reminderTimeType == 'minutes') {
        await _notificationsPlugin.periodicallyShow(
          notificationId,
          '$title $s reminder',
          "Task reminder every minute",
          RepeatInterval.everyMinute,
          notificationDetails,
          payload: jsonEncode({'page': s, 'taskId': notificationId}),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } else if (reminderTimeType == 'hours') {
        await _notificationsPlugin.periodicallyShow(
          notificationId,
          '$title $s reminder',
          "Task reminder every hour",
          RepeatInterval.hourly,
          notificationDetails,
          payload: jsonEncode({'page': s, 'taskId': notificationId}),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } else if (reminderTimeType == 'daily') {
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          '$title $s reminder',
          "Daily reminder",
          tz.TZDateTime.from(dateTime, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: jsonEncode({'page': s, 'taskId': notificationId}),
        );
      }
    }
  }

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
      String? page = payloadData['page'];
      String? taskId = payloadData['taskId'].toString();

      if (payloadData['type'] == "chat") {
        Get.to(
          () => MessageScreen(
            payloadData['sendername'].toString(),
            payloadData['productid'].toString(),
            payloadData['senderid'].toString(),
            '',
            [],
            '',
            '',
            '',
            '',
          ),
        );
      } else if (payloadData['type'] == "dailymsg") {
        StorageHelper.setDailyMessage(true);
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 0;
        Get.to(
          () => BottomNavigationBarExample(
            from: 'true',
            payloadData: payloadData,
          ),
        );
      } else if (payloadData['type'] == "leadquotation") {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 2,
            leadNumber: '',
          ),
        );
      } else if (payloadData['type'] == "leadchat") {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 3,
            leadNumber: '',
          ),
        );
      } else if (payloadData['type'].toString() == "lead_followup") {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'],
            index: 1,
            leadNumber: payloadData['senderid'],
          ),
        );
      } else if (payloadData['type'].toString() == "task") {
        Get.to(
          () => TaskDetails(
            taskId: int.parse(payloadData['productid'].toString()),
            assignedStatus: '',
            initialIndex: 0,
          ),
        );
      } else if (payloadData['type'].toString().contains("todo")) {
        Get.to(() => ToDoList(''));
      } else if (payloadData['type'].toString() == "meeting") {
        Get.to(() => MeetingListScreen());
      } else if (payloadData['type'].toString() == "gatepass") {
        Get.to(
          () => HumanGatepassDetails(
            payloadData['productid'].toString(),
            from: 'notification',
          ),
        );
      } else if (payloadData['type'].toString() == "lead") {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 0,
            leadNumber: '',
          ),
        );
      } else if (payloadData['type'].toString() == 'leadchat') {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 3,
          ),
        );
      } else if (payloadData['type'].toString() == 'lead_note') {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 5,
          ),
        );
      } else if (payloadData['type'].toString() == 'lead_visit') {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 6,
          ),
        );
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead notes')) {
        Get.to(
          LeadNoteScreen(leadId: payloadData['productid'].toString(), index: 4),
        );
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead contact')) {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['productid'].toString(),
            index: 0,
          ),
        );
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
        Get.to(
          LeadNoteScreen(leadId: payloadData['productid'].toString(), index: 4),
        );
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('Lead notes')) {
        Get.to(
          LeadNoteScreen(leadId: payloadData['productid'].toString(), index: 4),
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
      } else if (payloadData['type'].toString() == 'lead' &&
          payloadData['title'].toString().contains('New Lead Created')) {
        Get.to(LeadList());
      } else if (payloadData['type'].toString() == "challan") {
        Get.to(() => InChalanDetails(payloadData['productid'.toString()]));
      } else if (payloadData['type'].toString() == "out_challan") {
        Get.to(() => UserChalanDetails(payloadData['productid'.toString()]));
      } else if (payloadData['type'].toString().contains("project")) {
        Get.to(() => Project(''));
      } else if (payloadData['type'].toString() == "emi_reminder") {
        Get.to(
          () => VehicalDetails(
            vehicleId: int.parse(payloadData['productid'].toString()),
          ),
        );
      } else if (payloadData['type'] == "note") {
        Get.to(() => NotesFolder());
      } else if (page.toString() == 'task') {
        Get.to(
          () => TaskDetails(
            taskId: int.parse(taskId.toString()),
            assignedStatus: '',
            initialIndex: 0,
          ),
        );
      } else if (page.toString() == 'daily-task') {
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 0;
        Get.put<ProfileController>(
          ProfileController(),
        ).dailyTaskList(Get.context!, 'reminder', payloadData['taskId']);
        Get.to(
          () => BottomNavigationBarExample(
            from: 'reminder',
            payloadData: payloadData,
          ),
        );
      } else if (page.toString().contains('event')) {
        Get.put<BottomBarController>(BottomBarController())
            .currentPageIndex
            .value = 2;
        Get.to(
          () => BottomNavigationBarExample(from: '', payloadData: payloadData),
        );
      } else if (page.toString() == 'meeting') {
        Get.to(() => MeetingListScreen());
      } else if (page.toString().contains('calender')) {
        Get.to(() => CalendarScreen(''));
      } else if (page.toString().contains('todo')) {
        Get.to(() => ToDoList(''));
      } else if (page.toString() == 'lead_meeting') {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['taskId'].toString(),
            index: 6,
          ),
        );
      } else if (page.toString().contains('followup')) {
        Get.to(
          () => LeadOverviewScreen(
            leadId: payloadData['taskId'].toString(),
            index: 1,
          ),
        );
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
