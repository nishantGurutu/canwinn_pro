import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/service/feed_service.dart';

class FeedController extends GetxController {
  RxList<bool> feedTabList = <bool>[].obs;
  RxString fromPage = ''.obs;
  var isFeedListLoading = false.obs;
  var feedList = [].obs;
  Future<void> feedListApi() async {
    isFeedListLoading.value = true;
    final result = await FeedService().feedListApi();
    if (result != null) {
      isFeedListLoading.value = false;
      feedList.clear();
      feedList.assignAll(result['data']);
    } else {
      isFeedListLoading.value = false;
    }
    isFeedListLoading.value = false;
  }

  RxList<ResponsiblePersonData> selectedGuest = <ResponsiblePersonData>[].obs;
  var isEventAdding = false.obs;
  Future<void> addEvent(
      String title,
      String description,
      String dueDate,
      String dueTime,
      int guest,
      String reminder,
      String event,
      String? timeType,
      String venueType,
      String urlText) async {
    isEventAdding.value = true;
    final result = await FeedService().addEvent(
        title,
        description,
        dueDate,
        dueTime,
        guest,
        reminder,
        event,
        timeType,
        venueType,
        urlText,
        selectedGuest);
    if (result != null) {
      isEventAdding.value = false;
      await eventList();
    } else {}
    isEventAdding.value = false;
  }

  final TaskController taskController = Get.find();
  var isEventLoading = false.obs;

  var feedEventList = [].obs;
  Future<void> eventList() async {
    isEventLoading.value = true;
    final result = await FeedService().eventList();
    if (result != null) {
      isEventAdding.value = false;
      feedEventList.assignAll(result['data']);

      for (var dt in feedEventList) {
        if (dt['event_date'] != null && dt['event_time'] != null) {
          try {
            String dateInput = "${dt['event_date']} ${dt['event_time']}";

            DateTime? dateTime;
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
              dateTime = inputFormat.parse(dateInput.toLowerCase());
            } catch (e) {
              print("Error parsing with lowercase AM/PM: $e");
            }

            if (dateTime == null) {
              try {
                DateFormat inputFormat =
                    DateFormat("dd-MM-yyyy h:mm a", 'en_US');
                dateTime = inputFormat.parse(dateInput.toUpperCase());
              } catch (e) {
                print("Error parsing with uppercase AM/PM: $e");
              }
            }
            if (dateTime != null) {
              DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm", 'en_US');
              print('Formatted Date Input: 65ew54 $dateTime');
              String dateOutput = outputFormat.format(dateTime);
              List<String> splitDt = dateOutput.split(" ");
              List<String> splitDt2 = splitDt.first.split('-');
              List<String> splitDt3 = splitDt[1].split(':');

              // String strReminder = "${dt.reminder}";
              // int minute = int.parse(splitDt3.last);
              // int hour = int.parse(splitDt3.first);

              // if (strReminder != "null") {
              //   List<String> splitReminder = strReminder.split(" ");
              //   int reminderTime = int.parse(splitReminder.first);
              //   String reminderTimeType = splitReminder.last.toLowerCase();

              //   if (reminderTimeType == 'minutes') {
              //     minute -= reminderTime;
              //   } else if (reminderTimeType == 'hours') {
              //     hour -= reminderTime;
              //   }
              // }

              DateTime dtNow = DateTime.now();
              DateTime targetDate = DateTime(
                int.parse(splitDt2.last),
                int.parse(splitDt2[1]),
                int.parse(splitDt2.first),
                0,
                0,
                0,
              );

              print("todoi9hn9i8j9 alarm date in controller $targetDate");
              if (targetDate.isAfter(dtNow)) {
                final randomId = Random().nextInt(1000);
                LocalNotificationService().scheduleNotification(
                  targetDate,
                  dt.id ?? 0,
                  dt.title.toString(),
                  'todo',
                  // dt.id,
                );
              }
            } else {
              print("Failed to parse date for task: ${dt.title}");
            }
          } catch (e) {}
        }
      }

      // for (var dt in feedEventList) {
      //   if (dt['event_date'] != null && dt['event_time'] != null) {
      //     try {
      //       String dateInput = "${dt['event_date']} ${dt['event_time']}";
      //       DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a");
      //       DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm");
      //       DateTime dateTime = inputFormat.parse(dateInput);
      //       String dateOutput = outputFormat.format(dateTime);
      //       List<String> splitDt = dateOutput.split(" ");
      //       List<String> splitDt2 = splitDt.first.split('-');
      //       List<String> splitDt3 = splitDt[1].split(':');

      //       String strReminder = "20 Minutes";
      //       int minute = int.parse(splitDt3.last);
      //       int hour = int.parse(splitDt3.first);

      //       if (strReminder.isNotEmpty && strReminder != "null") {
      //         List<String> splitReminder = strReminder.split(" ");
      //         int reminderTime = int.parse(splitReminder.first);
      //         String reminderTimeType = splitReminder.last.toLowerCase();

      //         if (reminderTimeType == 'minutes') {
      //           minute -= reminderTime;
      //         } else if (reminderTimeType == 'hours') {
      //           hour -= reminderTime;
      //         }
      //       }

      //       DateTime dtNow = DateTime.now();
      //       DateTime targetDate = DateTime(
      //         int.parse(splitDt2.last),
      //         int.parse(splitDt2[1]),
      //         int.parse(splitDt2.first),
      //         hour,
      //         minute,
      //         0,
      //       );
      //       if (targetDate.isAfter(dtNow)) {
      //         final randomId = Random().nextInt(1000);
      //         LocalNotificationService().scheduleNotification(
      //             targetDate, randomId, dt['title'], "event", '');
      //       }
      //     } catch (e) {}
      //   }
      // }
    } else {
      isEventAdding.value = false;
    }
    isEventLoading.value = false;
  }

  var isEventDeleting = false.obs;
  Future<void> deleteEventList(int id) async {
    isEventDeleting.value = true;
    final result = await FeedService().deleteEventList(id);
    if (result != null) {
      isEventDeleting.value = false;
      await eventList();
    } else {
      isEventDeleting.value = false;
    }
    isEventDeleting.value = false;
  }

  var isEventEditing = false.obs;
  Future<void> editEventList(int id) async {
    isEventEditing.value = true;

    isEventEditing.value = false;
  }
}
