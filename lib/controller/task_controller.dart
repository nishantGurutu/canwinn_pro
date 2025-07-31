import 'dart:io';
import 'dart:math';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/custom_caches_manager.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/task_category_list_model.dart';
import 'package:task_management/model/task_details_model.dart';
import 'package:task_management/service/project_service.dart';
import 'package:task_management/service/task_service.dart';

class TaskController extends GetxController {
  final ProfileController profileController = Get.put(ProfileController());
  var taskTabIndex = 0.obs;
  RxInt? isProgress;
  RxBool? isProgressStatus = false.obs;
  RxString? isProgressSelected = ''.obs;
  RxString? isCompleteSelected = ''.obs;
  RxBool? isCompleteStatus = false.obs;
  RxList<String> taskSelectedType =
      <String>['Assigned to me', 'Task created by me', "Task review by me"].obs;
  RxString selectedAssignedTask = ''.obs;
  RxList<String> taskType = <String>[
    'All Task',
    'New Task',
    'Progress',
    'Completed',
    'Important',
    'Past Due',
    'Due Today',
  ].obs;
  RxString selectedTaskType = 'All Task'.obs;
  Future<void> updateTaskType(String? value) async {
    selectedTaskType.value = value!;
    await taskListApi(
        selectedTaskType.value, selectedAssignedTask.value, '', '', '');
  }

  var isAllProjectCalling = false.obs;
  var allProjectListModel = AllProjectListModel().obs;
  Rx<CreatedByMe?> selectedAllProjectListData = Rx<CreatedByMe?>(null);
  RxList<CreatedByMe> allProjectDataList = <CreatedByMe>[].obs;
  Future<void> allProjectListApi() async {
    isAllProjectCalling.value = true;
    final result = await ProjectService().allProjectListApi();
    if (result != null) {
      allProjectDataList.clear();
      allProjectListModel.value = result;
      if (allProjectListModel.value.createdByMe!.isEmpty) {
        allProjectDataList.add(
          CreatedByMe(
            id: 0,
            name: "Daily Task",
            description: "Tasks to complete daily",
            status: 1,
          ),
        );
        allProjectDataList.add(
          CreatedByMe(
            id: -1,
            name: "Other",
            description: "Other Task",
            status: 1,
          ),
        );
      } else {
        allProjectDataList.add(
          CreatedByMe(
            id: 0,
            name: "Daily Task",
            description: "Tasks to complete daily",
            status: 1,
          ),
        );
        allProjectDataList.add(
          CreatedByMe(
            id: -1,
            name: "Other",
            description: "Other Task",
            status: 1,
          ),
        );
        for (int i = 0;
            i < (allProjectListModel.value.createdByMe?.length ?? 0);
            i++) {
          allProjectDataList.add(allProjectListModel.value.createdByMe![i]);
        }
        for (int i = 0;
            i < (allProjectListModel.value.assignedToMe?.length ?? 0);
            i++) {
          allProjectDataList.add(allProjectListModel.value.assignedToMe![i]);
        }
      }
      selectedAllProjectListData.value = allProjectDataList.first;
      await profileController
          .departmentList(selectedAllProjectListData.value!.id);
      allProjectDataList.refresh();
      selectedAllProjectListData.refresh();
    }
    isAllProjectCalling.value = false;
  }

  Future<void> updateAssignedTask(String? value) async {
    selectedAssignedTask.value = value!;
    await taskListApi(
        selectedTaskType.value, selectedAssignedTask.value, '', '', '');
  }

  final HomeController homeController = Get.put(HomeController());
  RxString selectedDate = DateFormat.yMMMMd().format(DateTime.now()).obs;
  var isTaskCategoryLoading = false.obs;
  var taskCategoryListModel = TaskCategoryListModel().obs;
  TaskCategoryListData? selectedTaskCategoryData;
  RxList<TaskCategoryListData> taskCategoryList = <TaskCategoryListData>[].obs;
  Future<void> taskCategoryListApi() async {
    isTaskCategoryLoading.value = true;
    final result = await TaskService().taskCategoryListApi();
    if (result != null) {
      taskCategoryListModel.value = result;
      taskCategoryList.clear();
      taskCategoryList.assignAll(taskCategoryListModel.value.data!);
    } else {}
    isTaskCategoryLoading.value = false;
  }

  int hour = 0;
  int minute = 0;
  var isTaskLoading = false.obs;
  var yesterdayTaskDate = ''.obs;
  var todayTaskDate = ''.obs;
  var allTaskList = [].obs;
  var checkAllTaskList = [].obs;
  var newTaskList = [].obs;
  var progressTaskList = [].obs;
  var completeTaskList = [].obs;
  var assignedId = [].obs;
  RxInt pagevalue = 1.obs;
  RxInt prePageCount = 1.obs;
  var isScrolling = false.obs;
  Future<void> taskListApi(String? selectedTaskValue, String assignValue,
      String type, String date, String? userId) async {
    if (type == 'scroll') {
      isScrolling.value = true;
    } else {
      isTaskLoading.value = true;
    }

    try {
      // Generate a unique cache key based on input parameters
      // final cacheKey =
      //     'task_list_${selectedTaskValue}_${assignValue}_${date}_${userId}';

      // // Try to get cached data first
      // final cachedFile =
      //     await CustomCacheManager.instance.getFileFromCache(cacheKey);

      // Map<String, dynamic>? result;

      // if (cachedFile != null && cachedFile.file.existsSync()) {
      //   // Read cached data
      //   final cachedData = await cachedFile.file.readAsString();
      //   result = jsonDecode(cachedData);
      // } else {
      // Fetch from API if no cache or cache is stale
      var result = await TaskService().taskListApi(
          selectedTaskValue, assignValue, pagevalue.value, date, userId ?? "");

      // if (result != null) {
      //   // Cache the new API response
      //   await CustomCacheManager.instance.putFile(
      //     cacheKey,
      //     utf8.encode(jsonEncode(result)),
      //     fileExtension: 'json',
      //   );
      // }
      // }

      if (result != null) {
        checkAllTaskList.clear();
        isTaskLoading.value = false;

        if (type != 'scroll') {
          allTaskList.clear();
          newTaskList.clear();
          progressTaskList.clear();
          completeTaskList.clear();
        }

        if (selectedTaskValue == "All Task") {
          checkAllTaskList.addAll(result['pending']);
          checkAllTaskList.addAll(result['progress']);
          checkAllTaskList.addAll(result['complete']);
          if (checkAllTaskList.length >= 50) {
            allTaskList.clear();
            prePageCount.value = pagevalue.value;
            allTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.length < 50 &&
              checkAllTaskList.isNotEmpty) {
            allTaskList.clear();
            pagevalue.value = prePageCount.value;
            allTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.isEmpty) {
            pagevalue.value = prePageCount.value;
          }
        } else if (selectedTaskValue == "New Task" ||
            selectedTaskValue == "Past Due") {
          checkAllTaskList.assignAll(result['pending']);
          if (checkAllTaskList.length >= 50) {
            newTaskList.clear();
            prePageCount.value = pagevalue.value;
            newTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.length < 50 &&
              checkAllTaskList.isNotEmpty) {
            newTaskList.clear();
            pagevalue.value = prePageCount.value;
            newTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.isEmpty) {
            pagevalue.value = prePageCount.value;
          }
        } else if (selectedTaskValue == "Due Today") {
          checkAllTaskList.assignAll(result['pending']);
          if (checkAllTaskList.length >= 50) {
            allTaskList.clear();
            prePageCount.value = pagevalue.value;
            allTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.length < 50 &&
              checkAllTaskList.isNotEmpty) {
            allTaskList.clear();
            pagevalue.value = prePageCount.value;
            allTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.isEmpty) {
            pagevalue.value = prePageCount.value;
          }
        } else if (selectedTaskValue == "Progress") {
          checkAllTaskList.assignAll(result['progress']);
          if (checkAllTaskList.length >= 50) {
            progressTaskList.clear();
            prePageCount.value = pagevalue.value;
            progressTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.length < 50 &&
              checkAllTaskList.isNotEmpty) {
            progressTaskList.clear();
            pagevalue.value = prePageCount.value;
            progressTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.isEmpty) {
            pagevalue.value = prePageCount.value;
          }
        } else {
          checkAllTaskList.assignAll(result['complete']);
          if (checkAllTaskList.length >= 50) {
            completeTaskList.clear();
            prePageCount.value = pagevalue.value;
            completeTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.length < 50 &&
              checkAllTaskList.isNotEmpty) {
            completeTaskList.clear();
            pagevalue.value = prePageCount.value;
            completeTaskList.assignAll(checkAllTaskList);
          } else if (checkAllTaskList.isEmpty) {
            pagevalue.value = prePageCount.value;
          }
        }

        if (type == 'scroll') {
          isScrolling.value = false;
        } else {
          isTaskLoading.value = false;
        }
        isTaskLoading.value = false;
        refresh();
        print("ius8 38yue98 eih3u98  ");
        await homeController.homeDataApi('');

        for (var dt in allTaskList) {
          if (dt['due_date'] != null && dt['due_time'] != null) {
            try {
              String dateInput = "${dt['due_date']} ${dt['due_time']}";

              DateTime? dateTime;
              try {
                DateFormat inputFormat =
                    DateFormat("dd-MM-yyyy h:mm a", 'en_US');
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
                DateFormat outputFormat =
                    DateFormat("dd-MM-yyyy HH:mm", 'en_US');
                print('Formatted Date Input: 65ew54 $dateTime');
                String dateOutput = outputFormat.format(dateTime);
                List<String> splitDt = dateOutput.split(" ");
                List<String> splitDt2 = splitDt.first.split('-');
                List<String> splitDt3 = splitDt[1].split(':');

                String strReminder = "${dt['reminder']}";
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

                print("task alarm date in controller $targetDate");
                if (targetDate.isAfter(dtNow)) {
                  final randomId = Random().nextInt(1000);
                  LocalNotificationService().scheduleNotification(
                    targetDate,
                    dt['id'],
                    dt['title'],
                    'task',
                  );
                }
              } else {
                print("Failed to parse date for task: ${dt.taskName}");
              }
            } catch (e) {}
          }
        }
      } else {
        if (type == 'scroll') {
          isScrolling.value = false;
        } else {
          isTaskLoading.value = false;
        }
      }
    } catch (e) {
      print("Error in taskListApi: $e");
      if (type == 'scroll') {
        isScrolling.value = false;
      } else {
        isTaskLoading.value = false;
      }
    }
  }

  RxMap<int, bool> responsiblePersonSelectedCheckBox2 = <int, bool>{}.obs;
  RxMap<int, bool> toAssignedPersonCheckBox = <int, bool>{}.obs;
  RxMap<int, bool> reviewerCheckBox2 = <int, bool>{}.obs;
  var isResponsiblePersonLoading = false.obs;
  RxBool selectAll = false.obs;
  RxList<ResponsiblePersonData> responsiblePersonList =
      <ResponsiblePersonData>[].obs;
  RxList<bool> selectedLongPress = <bool>[].obs;
  RxList<int> selectedMemberId = <int>[].obs;
  RxList<bool> responsiblePersonSelectedCheckBox = <bool>[].obs;
  RxList<bool> reviewerCheckBox = <bool>[].obs;
  Rx<ResponsiblePersonData?> selectedResponsiblePersonData =
      Rx<ResponsiblePersonData?>(null);
  RxList<int> selectedResponsiblePersonId = <int>[].obs;
  RxList<bool> selectedSharedListPerson = <bool>[].obs;
  var fromPage = ''.obs;
  RxList<bool> isLongPressed = <bool>[].obs;
  var makeSelectedPersonValue = ''.obs;
  var responsiblePersonListModel = ResponsiblePersonListModel().obs;
  Future<void> responsiblePersonListApi(dynamic id, String fromPage) async {
    Future.microtask(() {
      isResponsiblePersonLoading.value = true;
    });
    final result = await TaskService().responsiblePersonListApi(id);
    if (result != null) {
      selectedResponsiblePersonData.value = null;
      responsiblePersonListModel.value = result;
      isResponsiblePersonLoading.value = false;
      responsiblePersonList.clear();
      if (fromPage.toString() == "add_meeting") {
        responsiblePersonList.add(
          ResponsiblePersonData(
            id: 0,
            name: "All user",
            status: 1,
          ),
        );
      }
      for (var person in responsiblePersonListModel.value.data!) {
        responsiblePersonList.add(person);
      }
      selectedSharedListPerson
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      responsiblePersonSelectedCheckBox
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      selectedResponsiblePersonId
          .addAll(List<int>.filled(responsiblePersonList.length, 0));
      selectedResponsiblePersonId
          .addAll(List<int>.filled(responsiblePersonList.length, 0));
      selectedLongPress
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      reviewerCheckBox
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      responsiblePersonSelectedCheckBox2.clear();
      toAssignedPersonCheckBox.clear();
      for (var person in responsiblePersonList) {
        toAssignedPersonCheckBox[person.id] = false;
      }
      for (var person in responsiblePersonList) {
        responsiblePersonSelectedCheckBox2[person.id] = false;
      }
      await userLogActivity(responsiblePersonList.first.id);
    }
    Future.microtask(() {
      isResponsiblePersonLoading.value = false;
    });
  }

  var isLogActivityLoading = false.obs;
  var logActivityList = [].obs;
  Future<void> userLogActivity(dynamic id) async {
    isLogActivityLoading.value = true;
    final result = await TaskService().userLogActivity(id);
    if (result != null) {
      logActivityList.clear();
      logActivityList.assignAll(result['data']);
    }
    isLogActivityLoading.value = false;
  }

  var isSearchLoading = false.obs;
  void searchFunction({required String searchText}) {
    isSearchLoading.value = true;
    isSearchLoading.value = false;
  }

  var isTaskDetailsLoading = false.obs;
  Rx<TaskDetailsModel?> taskDetails = Rx<TaskDetailsModel?>(null);
  Future<void> taskDetailsApi(int? taskId) async {
    isTaskDetailsLoading.value = true;
    final result = await TaskService().taskDetails(taskId);
    if (result != null) {
      taskDetails.value = result;
    }
    isTaskDetailsLoading.value = false;
  }

  RxList<ContactsData> addTaskContactList = <ContactsData>[].obs;
  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  var isProfilePicUploading = false.obs;
  RxList<String> assignedUserId = <String>[].obs;
  RxList<String> reviewerUserId = <String>[].obs;
  Rx<File> pickedFile = File('').obs;
  var isTaskAdding = false.obs;
  Future<void> addTask(
    String taskName,
    String remark,
    int selectedProjectId,
    int? departmentId,
    String startDate,
    String dueDate,
    String dueTime,
    int? priorityId,
    String s,
    String timeTextString,
    String timeType,
  ) async {
    isTaskAdding.value = true;
    try {
      final result = await TaskService().addTaskApi(
        taskName,
        remark,
        selectedProjectId,
        departmentId,
        pickedFile,
        assignedUserId,
        reviewerUserId,
        startDate,
        dueDate,
        dueTime,
        priorityId,
        timeTextString,
        timeType,
        addTaskContactList,
      );
      if (result) {
        Get.back();
        responsiblePersonSelectedCheckBox
            .addAll(List<bool>.filled(responsiblePersonList.length, false));
        reviewerCheckBox
            .addAll(List<bool>.filled(responsiblePersonList.length, false));
        assignedUserId.clear();
        reviewerUserId.clear();

        // Refresh task list
        await taskListApi(
            selectedTaskType.value, selectedAssignedTask.value, '', '', '');

        // Invalidate home data cache
        String cacheKey = 'home_data_cache';
        final cacheManager = DefaultCacheManager();
        await cacheManager.removeFile('$cacheKey');
        // await cacheManager.removeFile('$cacheKey$selectedProjectId');
        await homeController.homeDataApi(StorageHelper.getId());
        if (s == 'bottom') {
          Get.back();
        }
      }
    } catch (e) {
      print('Error adding task: $e');
    } finally {
      isTaskAdding.value = false;
    }
  }
  // Future<void> addTask(
  //     String taskName,
  //     String remark,
  //     int selectedProjectId,
  //     int? departmentId,
  //     String startDate,
  //     String dueDate,
  //     String dueTime,
  //     int? priorityId,
  //     String s,
  //     String timeTextString,
  //     String timeType) async {
  //   isTaskAdding.value = true;
  //   final result = await TaskService().addTaskApi(
  //     taskName,
  //     remark,
  //     selectedProjectId,
  //     departmentId,
  //     pickedFile,
  //     assignedUserId,
  //     reviewerUserId,
  //     startDate,
  //     dueDate,
  //     dueTime,
  //     priorityId,
  //     timeTextString,
  //     timeType,
  //     addTaskContactList,
  //   );
  //   if (result) {
  //     Get.back();
  //     responsiblePersonSelectedCheckBox
  //         .addAll(List<bool>.filled(responsiblePersonList.length, false));
  //     reviewerCheckBox
  //         .addAll(List<bool>.filled(responsiblePersonList.length, false));
  //     assignedUserId.clear();
  //     reviewerUserId.clear();
  //     await taskListApi(
  //         selectedTaskType.value, selectedAssignedTask.value, '', '', '');

  //     if (s == 'bottom') {
  //       Get.back();
  //     }
  //   }
  //   isTaskAdding.value = false;
  // }

  var isSubTaskAdding = false.obs;
  Future<void> addSubTask(String taskName, String startDate, String dueDate,
      String dueTime, int? priorityId, id) async {
    isSubTaskAdding.value = true;
    final result = await TaskService()
        .addSubTaskApi(taskName, startDate, dueDate, dueTime, priorityId, id);
    Get.back();
    taskDetailsApi(id);
    isSubTaskAdding.value = false;
  }

  var isSubTaskEditing = false.obs;
  Future<void> editSubTask(String taskName, String startDate, String dueDate,
      String dueTime, int? priorityId, id) async {
    isSubTaskEditing.value = true;
    final result = await TaskService()
        .editSubTaskApi(taskName, startDate, dueDate, dueTime, priorityId, id);
    if (result) {
      Get.back();
      taskDetailsApi(id);
    }
    isSubTaskEditing.value = false;
  }

  var isTaskEditing = false.obs;
  Future<void> editTask(
      String taskName,
      String remark,
      int? projectId,
      int? deptId,
      RxList<String> assignedUserId,
      RxList<String> reviewerUserId,
      String startDate,
      String dueDate,
      String dueTime,
      int? priorityId,
      newTaskListId,
      String timeTextEditingController,
      String timeType) async {
    isTaskEditing.value = true;
    final result = await TaskService().editTaskApi(
        taskName,
        remark,
        projectId,
        deptId,
        assignedUserId,
        reviewerUserId,
        startDate,
        dueDate,
        dueTime,
        priorityId,
        newTaskListId,
        pickedFile,
        timeTextEditingController,
        timeType);
    if (result) {
      await taskListApi(
          selectedTaskType.value, selectedAssignedTask.value, '', '', '');
      Get.back();
    }
    isTaskEditing.value = false;
  }

  var isTaskDeleting = false.obs;
  Future<void> deleteTask(int? id) async {
    isTaskDeleting.value = true;
    final result = await TaskService().deleteTask(id);
    if (result) {
      await taskListApi(
          selectedTaskType.value, selectedAssignedTask.value, '', '', '');
    }
    isTaskDeleting.value = false;
  }

  Future<void> deleteSubTask(int? id) async {
    isTaskDeleting.value = true;
    final result = await TaskService().deleteTask(id);
    if (result) {
      await taskDetailsApi(id);
    }
    isTaskDeleting.value = false;
  }

  var profilePicPath2 = "".obs;
  var isFileUpdated = false.obs;
  var isFilePicUploading = false.obs;
  Rx<File> pickedFile2 = File('').obs;
  int taskIdFromDetails = 0;
  var isProgressUpdating = false.obs;
  Future<void> updateProgressTask(int? id, String statusRemark, int i,
      {required String from}) async {
    isProgressUpdating.value = true;
    final result = await TaskService()
        .updateProgressTask(id, statusRemark, i, pickedFile2);
    if (result) {
      isProgressStatus?.value = false;
      Get.back();
      if (from == "details") {
        await taskListApi(
            selectedTaskType.value, selectedAssignedTask.value, '', '', '');
        await taskDetailsApi(taskIdFromDetails);
      } else {
        await taskListApi(
            selectedTaskType.value, selectedAssignedTask.value, '', '', '');
        await taskDetailsApi(taskIdFromDetails);
      }
    }
    isProgressUpdating.value = false;
  }
}
