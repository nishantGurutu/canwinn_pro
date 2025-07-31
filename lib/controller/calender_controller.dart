import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/model/callender_eventList_model.dart';
import 'package:task_management/service/calender_service.dart';

class CalenderController extends GetxController {
  RxList<String> timeList = <String>[
    "Minutes",
    "Hours",
  ].obs;
  RxString? selectedTime = "".obs;

  RxList<String> categoryColorName = <String>[].obs;
  RxString selectedCategoryColorName = ''.obs;
  var isCalenderLoading = false.obs;
  RxList<CallenderEventData> eventsList = <CallenderEventData>[].obs;
  int hour = 0;
  int minute = 0;
  Future<void> eventListApi() async {
    isCalenderLoading.value = true;
    final result = await CalenderService().eventList();
    if (result != null) {
      eventsList.clear();
      eventsList.assignAll(result.data!);
      isCalenderLoading.value = false;

      for (var dt in eventsList) {
        if (dt.eventDate != null && dt.eventTime != null) {
          try {
            String dateInput = "${dt.eventDate} ${dt.eventTime}";

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

              String strReminder = "${dt.reminder}";
              int minute = int.parse(splitDt3.last);
              int hour = int.parse(splitDt3.first);

              if (strReminder != "null") {
                List<String> splitReminder = strReminder.split(" ");
                int reminderTime = int.parse(splitReminder.first);
                String reminderTimeType = splitReminder.last.toLowerCase();

                if (reminderTimeType == 'minutes') {
                  minute -= reminderTime;
                } else if (reminderTimeType == 'hours') {
                  hour -= reminderTime;
                }
              }

              DateTime dtNow = DateTime.now();
              DateTime targetDate = DateTime(
                int.parse(splitDt2.last),
                int.parse(splitDt2[1]),
                int.parse(splitDt2.first),
                hour,
                minute,
                0,
              );

              print("todoi9hn9i8j9 alarm date in controller $targetDate");
              if (targetDate.isAfter(dtNow)) {
                final randomId = Random().nextInt(1000);
                LocalNotificationService().scheduleNotification(
                  targetDate,
                  dt.id ?? 0,
                  dt.eventName.toString(),
                  'calender',
                  // dt.id,
                );
              }
            } else {
              print("Failed to parse date for task: ${dt.eventName}");
            }
          } catch (e) {}
        }
      }
    } else {}
    isCalenderLoading.value = false;
  }

  final TextEditingController eventControllerEditingController =
      TextEditingController();
  final TextEditingController eventDateControllerEditingController =
      TextEditingController();
  final TextEditingController eventTimeControllerEditingController =
      TextEditingController();

  var isEventAdding = false.obs;
  Future<void> addEventApi(String text, String date, String time,
      String reminder, String? reminderType) async {
    isEventAdding.value = true;
    final result = await CalenderService()
        .addEventApi(text, date, time, reminder, reminderType);
    isEventAdding.value = false;
    eventControllerEditingController.clear();
    eventDateControllerEditingController.clear();
    eventTimeControllerEditingController.clear();
    Get.back();
    await eventListApi();
    isEventAdding.value = false;
  }

  var isTaskDeleting = false.obs;
  Future<void> deleteEvent(int? id) async {
    isTaskDeleting.value = true;
    final result = await CalenderService().deleteEvent(id);
    if (result) {
      await eventListApi();
    } else {}
    isTaskDeleting.value = false;
  }
}
