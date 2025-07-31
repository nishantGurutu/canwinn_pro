import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/model/tag_list_model.dart';
import 'package:task_management/model/todo_list_model.dart';
import 'package:task_management/service/todo_service.dart';

class TodoController extends GetxController {
  final TextEditingController titleTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  RxBool isMarkCompleted = false.obs;
  RxList<String> sortList = <String>[
    "Inbox",
    "Ascending",
    "Descending",
    "Recently Added",
    "Done",
    "Important",
    "Trash",
  ].obs;
  String? selectedSortData;
  RxList<String> timeList = <String>[
    "Minutes",
    "Hours",
  ].obs;
  RxString? selectedTime = "".obs;
  RxList<int> completedTodoCheckList = <int>[].obs;
  RxList<bool> todoListCheckbox = <bool>[].obs;

  RxList<TodoData> todoListData = <TodoData>[].obs;
  RxBool isAllTodoChecked = false.obs;
  var isTodoListLoading = false.obs;

  int hour = 0;
  int minute = 0;

  Future<void> todoListApi(String? value) async {
    isTodoListLoading.value = true;
    final result = await TodoService().todoListApi(value);
    if (result != null) {
      todoListData.clear();
      completedTodoCheckList.clear();
      todoListData.assignAll(result.data!);
      todoListCheckbox.addAll(List<bool>.filled(todoListData.length, false));
      completedTodoCheckList.addAll(List<int>.filled(todoListData.length, 0));
      for (int i = 0; i < todoListData.length; i++) {
        if (todoListData[i].isComplete == 1) {
          todoListCheckbox[i] = true;
        } else {
          todoListCheckbox[i] = false;
        }
      }
      for (int i = 0; i < todoListData.length; i++) {
        if (todoListData[i].isComplete == 0) {
          isMarkCompleted.value = false;
          break;
        } else {
          isMarkCompleted.value = true;
        }
      }

      for (var dt in todoListData) {
        if (dt.alertDate != null && dt.alertTime != null) {
          try {
            String dateInput = "${dt.alertDate} ${dt.alertTime}";

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
    }
    isTodoListLoading.value = false;
  }

  var isTagLoading = false.obs;
  RxList<TagData> tagList = <TagData>[].obs;
  Future<void> tagListApi() async {
    isTagLoading.value = true;
    final result = await TodoService().tagListApi();
    if (result != null) {
      tagList.clear();
      tagList.assignAll(result.data!);
    } else {}
    isTagLoading.value = false;
  }

  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  var isFilePicUploading = false.obs;
  var isProfilePicUploading = false.obs;
  Rx<File> pickedFile = File('').obs;
  Rx<TagData?> selectedTagData = Rx<TagData?>(null);
  var isTodoAdding = false.obs;
  Future<void> addTodoApi(
      String title,
      int? tag,
      int? priorityId,
      String description,
      String dueTime,
      String dueDate,
      String reminderTime,
      String selectedReminderTime) async {
    isTodoAdding.value = true;
    final result = await TodoService().addTodoApi(
        title,
        tag,
        priorityId,
        description,
        dueTime,
        dueDate,
        reminderTime,
        selectedReminderTime,
        pickedFile);
    if (result != null) {
      titleTextEditingController.clear();
      descriptionTextEditingController.clear();
      Get.back();
      todoListApi(selectedSortData);
    } else {}
    isTodoAdding.value = false;
  }

  Future<void> editTodoApi(
    String titleText,
    int? tagId,
    int? priorityId,
    String descText,
    int? id,
    String date,
    String time,
    String reminderText,
    String? reminderValue,
  ) async {
    isTodoAdding.value = true;
    final result = await TodoService().editTodoApi(titleText, tagId, priorityId,
        descText, id, date, time, pickedFile, reminderText, reminderValue);
    if (result != null) {
      Get.back();
      todoListApi(selectedSortData);
    } else {}
    isTodoAdding.value = false;
  }

  var isTodoDeleting = false.obs;
  Future<void> deleteTodoApi(int? id) async {
    isTodoDeleting.value = true;
    final result = await TodoService().deleteTodoApi(id);
    if (result != null) {
      todoListApi(selectedSortData);
    } else {}
    isTodoDeleting.value = false;
  }

  Future<void> completeTodoApi(
      RxList<int> completedTodoCheckList, int i) async {
    isTodoDeleting.value = true;
    final result =
        await TodoService().completeTodoApi(completedTodoCheckList, i);
    if (result != null) {
      todoListApi(selectedSortData);
    } else {}
    isTodoDeleting.value = false;
  }
}
