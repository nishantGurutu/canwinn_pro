import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/daily_task_list_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/get_submit_daily_task_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/user_profile_model.dart';
import 'package:task_management/service/user_profile_service.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/submitted_task_pdf_report.dart';
import '../model/assetsTypeListmode.dart';
import '../model/assets_list_model.dart';

class ProfileController extends GetxController {
  var isProfilePicUploading = false.obs;
  var nameTextEditingController = TextEditingController().obs;
  var emailTextEditingController = TextEditingController().obs;
  var departmentTextEditingController = TextEditingController().obs;
  var departmentIdTextEditingController = TextEditingController().obs;
  var mobileTextEditingController = TextEditingController().obs;
  var dobTextEditingController = TextEditingController().obs;
  var anniversaryDateController = TextEditingController().obs;
  var genderDateController = TextEditingController().obs;
  final HomeController homeController = Get.put(HomeController());
  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  Rx<File> pickedFile = File('').obs;
  RxList<String> anniversaryList = <String>["DOB", "Marriage Anniversary"].obs;
  RxList<String> genderList = <String>["Male", "Female"].obs;
  RxString? selectedGender = "".obs;
  RxString? selectedAnniversary = ''.obs;
  var isProfileUpdating = false.obs;
  Future<void> updateProfile(
    String name,
    String email,
    String mobile,
    String? departmentId,
    int? id,
    String? value,
    String dob,
    String anniversaryType,
    String annivresaryDate,
    BuildContext context,
  ) async {
    isProfileUpdating.value = true;
    final result = await ProfileService().updateProfile(
      name,
      email,
      mobile,
      departmentId,
      id,
      value,
      pickedFile,
      dob,
      anniversaryType,
      annivresaryDate,
    );
    await userDetails();
    await homeController.anniversarylist(context);
    isProfileUpdating.value = false;
  }

  var dataFromImagePicker = false.obs;
  var isUserDetailsLoading = false.obs;
  var isValidProfileImage = false.obs;
  RxString userRoleValue = ''.obs;
  Rx<UserProfileModel?> userProfileModel = Rx<UserProfileModel?>(null);
  RxList<AssetsData> assetsList = <AssetsData>[].obs;
  RxList<AllocatedAssets> allocatedAssetsList = <AllocatedAssets>[].obs;
  Future<void> userDetails() async {
    Future.microtask(() => isUserDetailsLoading.value = true);

    final result = await ProfileService().userDetails();
    if (result != null) {
      isUserDetailsLoading.value = false;
      isUserDetailsLoading.refresh();
      userProfileModel.value = result;
      dataFromImagePicker.value = false;
      assetsList.clear();
      if (userProfileModel.value!.data!.assets!.isNotEmpty) {
        assetsList.assignAll(userProfileModel.value!.data!.assets!);
      }
      if (userProfileModel.value!.data!.allocatedAssets!.isNotEmpty) {
        allocatedAssetsList
            .assignAll(userProfileModel.value!.data!.allocatedAssets!);
      }
      profilePicPath.value = '';
      await departmentList(null);
      await Future.delayed(Duration(milliseconds: 100));
      profilePicPath.value = userProfileModel.value?.data?.image ?? '';
      profilePicPath.refresh();
      nameTextEditingController.value.text =
          userProfileModel.value?.data?.name ?? "";
      emailTextEditingController.value.text =
          userProfileModel.value?.data?.email ?? "";
      mobileTextEditingController.value.text =
          userProfileModel.value?.data?.phone ?? "";
      dobTextEditingController.value.text =
          userProfileModel.value?.data?.dob ?? "";
      anniversaryDateController.value.text =
          userProfileModel.value?.data?.anniversaryDate ?? "";
      if (userProfileModel.value?.data?.departmentId != null) {
        departmentIdTextEditingController.value.text =
            userProfileModel.value?.data?.departmentId.toString() ?? "";
      }
      selectedAnniversary?.value =
          userProfileModel.value?.data?.anniversaryType ?? "";
      profilePicPath.value = userProfileModel.value?.data?.image ?? "";
      genderDateController.value.text =
          userProfileModel.value?.data?.gender ?? "";

      selectedGender?.value = userProfileModel.value?.data?.gender ?? "";

      StorageHelper.setName(userProfileModel.value?.data?.name ?? '');
      StorageHelper.setEmail(userProfileModel.value?.data?.email ?? '');
      StorageHelper.setPhone(userProfileModel.value?.data?.phone ?? '');
      StorageHelper.setRole(
          userProfileModel.value?.data?.role.toString() ?? '');
      StorageHelper.setDepartmentId(
          userProfileModel.value?.data?.departmentId ?? 0);
      StorageHelper.setGender(userProfileModel.value?.data?.gender ?? '');
      StorageHelper.setImage(userProfileModel.value?.data?.image ?? '');
      StorageHelper.setDob(userProfileModel.value?.data?.dob ?? '');
      refresh();
      if (userProfileModel.value!.data!.image != null) {
        isValidProfileImage.value = false;
      } else {
        if (userProfileModel.value?.data?.image != null) {
          if (userProfileModel.value!.data!.image!.contains('.jpg')) {
            isValidProfileImage.value = true;
          } else {
            isValidProfileImage.value = false;
          }
        }
      }
    }
    isUserDetailsLoading.value = false;
  }

  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  RxList<String> selectedDepartmentListId = <String>[].obs;
  var isdepartmentListLoading = false.obs;
  Rx<DepartmentListData?> selectedDepartMentListData =
      Rx<DepartmentListData?>(null);
  RxList<DepartmentListData> departmentDataList = <DepartmentListData>[].obs;
  Future<void> departmentList(dynamic selectedProjectId) async {
    isdepartmentListLoading.value = true;
    final result = await ProfileService().departmentList(selectedProjectId);
    if (result != null) {
      selectedDepartMentListData.value = null;
      departmentDataList.clear();
      selectedDepartmentListId.clear();
      departmentDataList.add(
        DepartmentListData(
          id: 0,
          name: "Other",
          status: 1,
        ),
      );
      departmentDataList.addAll(result.data!);

      selectedDepartmentListId
          .addAll(List<String>.filled(departmentDataList.length, ''));

      isdepartmentListLoading.value = false;
      for (var deptId in departmentDataList) {
        if (userProfileModel.value?.data?.departmentId.toString() ==
            deptId.id.toString()) {
          departmentTextEditingController.value.text = deptId.name ?? '';
          await userPageControlelr.roleListApi(
            selectedDepartMentListData.value?.id,
          );
          return;
        }
      }
    } else {}
    isdepartmentListLoading.value = false;
  }

  var isDepartmentAdding = false.obs;
  Future<void> addDepartment(String deptName) async {
    isDepartmentAdding.value = true;
    final result = await ProfileService().addDepartment(deptName);
    Get.back();
    await departmentList(0);
    isDepartmentAdding.value = false;
  }

  var isDailyTaskLoading = false.obs;
  final List<TextEditingController> timeControllers = [];
  RxList<DailyTasks> dailyTaskDataList = <DailyTasks>[].obs;
  RxList<bool> dailyTaskListCheckbox = <bool>[].obs;
  Future<void> dailyTaskList(
      BuildContext context, String s, payloadData) async {
    print('payload data value in task list function ${payloadData}');
    isDailyTaskLoading.value = true;
    final result = await ProfileService().dailyTaskList();
    if (result != null) {
      isDailyTaskLoading.value = false;
      dailyTaskDataList.clear();
      dailyTaskListCheckbox.clear();
      dailyTaskDataList.assignAll(result.tasks!);
      dailyTaskListCheckbox
          .addAll(List<bool>.filled(dailyTaskDataList.length, false));
      isDailyTaskLoading.value = false;
      if (s == "pastTask") {
        Future.delayed(Duration(milliseconds: 100), () {
          showAlertDialog(context);
        });
      }
      await initializeTimeControllers(dailyTaskDataList.length);

      print('s value in tasklist api $s');
      if (s == "reminder") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: dailyTaskListWidget(context, payloadData),
            ),
          );
        });
      }
      await scheduleDailyTask(dailyTaskDataList);
    } else {}
    isDailyTaskLoading.value = false;
  }

  var selectedUser = ResponsiblePersonData().obs;
  RxList<AssetsTypeData> assetsTypeListData = <AssetsTypeData>[].obs;
  var selectedAssetsTypeData = AssetsTypeData().obs;
  var assetsTypeListLoading = false.obs;
  Future<void> assetsTypeList() async {
    assetsTypeListLoading.value = true;
    final result = await ProfileService().assetsTypeList();
    if (result != null) {
      assetsTypeListLoading.value = false;
      assetsTypeListData.assignAll(result.data!);
    }
    assetsTypeListLoading.value = false;
  }

  RxList<AssetsListData> assetsListData = <AssetsListData>[].obs;
  var selectedAssetsListData = AssetsListData().obs;
  var assetsListLoading = false.obs;
  Future<void> assetsListApi(int? id) async {
    assetsListLoading.value = true;
    final result = await ProfileService().assetsList(id);
    if (result != null) {
      assetsListLoading.value = false;
      assetsListData.assignAll(result.data!);
    }
    assetsListLoading.value = false;
  }

  Future<void> initializeTimeControllers(int count) async {
    timeControllers.clear();
    remarkControllers.clear();
    for (int i = 0; i < count; i++) {
      timeControllers.add(TextEditingController());
      remarkControllers.add(TextEditingController());
    }

    for (int i = 0; i < count; i++) {
      timeControllers[i].text = dailyTaskDataList[i].taskTime.toString();
    }
  }

  Future<void> scheduleDailyTask(RxList<DailyTasks> dailyTaskDataList) async {
    if (dailyTaskDataList.isNotEmpty) {
      for (var dt in dailyTaskDataList) {
        DateTime dateTimedt = DateTime.now();
        String formattedDate = DateFormat("dd-MM-yyyy").format(dateTimedt);

        String dateInput = "${formattedDate} ${dt.taskTime}";
        print('Date input format in profile: $dateInput');

        DateTime? dateTime;
        try {
          DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
          dateTime = inputFormat.parse(dateInput.toLowerCase());
        } catch (e) {
          print("Error parsing with lowercase AM/PM: $e");
        }

        if (dateTime == null) {
          try {
            DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
            dateTime = inputFormat.parse(dateInput.toUpperCase());
          } catch (e) {}
        }

        if (dateTime != null) {
          DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm", 'en_US');
          String dateOutput = outputFormat.format(dateTime);

          List<String> splitDt = dateOutput.split(" ");
          List<String> splitDt2 = splitDt.first.split('-');
          List<String> splitDt3 = splitDt[1].split(':');

          DateTime dtNow = DateTime.now();
          DateTime targetDate = DateTime(
            int.parse(splitDt2.last),
            int.parse(splitDt2[1]),
            int.parse(splitDt2.first),
            int.parse(splitDt3.first),
            int.parse(splitDt3.last),
            0,
          );

          if (targetDate.isAfter(dtNow)) {
            final notificationId = dt.id;

            LocalNotificationService().scheduleNotification(
              targetDate,
              dt.id ?? 0,
              dt.taskName ?? '',
              'daily-task',
            );
          }
        } else {}
      }
    }
  }

  final TextEditingController selectedDateTextController =
      TextEditingController();
  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Obx(
                () => isQuotationDownloading.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Downloading....',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Download report',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: CustomCalender(
                                  hintText: dateFormate,
                                  controller: selectedDateTextController,
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              InkWell(
                                onTap: () async {
                                  await downloadReport(
                                      date: selectedDateTextController.text);
                                },
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/png/download_image.png',
                                      height: 30.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  var isQuotationDownloading = false.obs;

  Future<void> downloadReport({required String date}) async {
    isQuotationDownloading.value = true;
    print('download report data value ${date}');

    final Uint8List? pdfData = await ProfileService().downloadReportApi(date);
    if (pdfData != null && pdfData.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();

      final folderPath = directory.path;

      final now = DateTime.now();
      final formattedDate =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
      final fileName = 'report_${formattedDate}.pdf';
      final filePath = '$folderPath/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      CustomToast().showCustomToast("Report downloaded successfuly.");
      Get.back();
    }
    isQuotationDownloading.value = false;
  }

  var isDailyTaskAdding = false.obs;
  Future<void> addDailyTask(
      String taskName, BuildContext context, String taskTime) async {
    isDailyTaskAdding.value = true;
    final result = await ProfileService().addDailyTask(taskName, taskTime);
    isDailyTaskAdding.value = false;
    await dailyTaskList(context, '', '');
    Get.back();
    isDailyTaskAdding.value = false;
  }

  var isDailyTaskDeleting = false.obs;
  Future<void> deleteDailyTask(int id, BuildContext context) async {
    isDailyTaskDeleting.value = true;
    final result = await ProfileService().deleteDailyTask(id);
    isDailyTaskDeleting.value = false;
    await dailyTaskList(context, '', '');
    isDailyTaskDeleting.value = false;
  }

  var isDailyTaskEditing = false.obs;
  Future<void> editDailyTask(
      String? taskId, String title, String time, BuildContext context) async {
    isDailyTaskEditing.value = true;
    final result = await ProfileService().editDailyTask(taskId, title, time);
    isDailyTaskEditing.value = false;
    Get.back();
    await dailyTaskList(context, '', '');
    isDailyTaskEditing.value = false;
  }

  var isDailyTaskSubmitting = false.obs;
  RxList<DailyTaskSubmitModel> dailyTaskSubmitList =
      <DailyTaskSubmitModel>[].obs;
  Future<void> submitDailyTask(RxList<DailyTaskSubmitModel> dailyTaskSubmitList,
      BuildContext context) async {
    isDailyTaskSubmitting.value = true;
    final result = await ProfileService().submitDailyTask(dailyTaskSubmitList);
    Get.back();
    isDailyTaskSubmitting.value = false;
    await dailyTaskList(context, '', '');
    isDailyTaskSubmitting.value = false;
  }

  var isPreviousTaskLoading = false.obs;
  RxList<SubmitDailyTasksData> previousSubmittedTask =
      <SubmitDailyTasksData>[].obs;
  Future<void> previousSubmittedTaskLoading(String dateText) async {
    isPreviousTaskLoading.value = true;
    final result = await ProfileService().previousSubmittedTask(dateText);
    if (result != null) {
      isPreviousTaskLoading.value = false;
      previousSubmittedTask.assignAll(result.tasks!);
      Get.back();
      final pdfGenerator = SubmittedTaskPdfReport(
          previousSubmittedTask, result.completedCount, dateText);
      await pdfGenerator.generatePDF();
    } else {
      isPreviousTaskLoading.value = false;
    }
    isPreviousTaskLoading.value = false;
  }

  var isAssestAssigning = false.obs;
  Future<void> assignAssets(
      AssetsTypeData assetTypeId,
      AssetsListData assetId,
      ResponsiblePersonData selectedPerson,
      String allocateddate,
      String releaseDate) async {
    isAssestAssigning.value = true;
    final result = await ProfileService().assignAssets(
        assetTypeId, assetId, selectedPerson, allocateddate, releaseDate);
    Get.back();
    await assignAssetsList();
    isAssestAssigning.value = false;
    isAssestAssigning.value = false;
  }

  var isAssestAssigningList = false.obs;
  var allocatedAssignList = [].obs;
  Future<void> assignAssetsList() async {
    isAssestAssigningList.value = true;
    final result = await ProfileService().assignAssetsList();
    if (result != null) {
      isAssestAssigningList.value = false;
      if (result['allocated_assets'] != null) {
        allocatedAssignList.assignAll(result['allocated_assets']);
      }
    }
    isAssestAssigningList.value = false;
  }

  var isAssestAssignEditing = false.obs;
  Future<void> editAssignAssets() async {
    isAssestAssignEditing.value = true;
    // final result = await ProfileService().editAssignAssets(
    //     id,
    //     nameTextEditingController,
    //     qtyTextEditingController,
    //     serialNoTextEditingController);
    await userDetails();
    isAssestAssignEditing.value = false;
  }

  var isAssestAssignDeleting = false.obs;
  Future<void> deleteAssignAssets(int? id) async {
    isAssestAssignDeleting.value = true;
    final result = await ProfileService().deleteAssignAssets(id);
    await userDetails();
    isAssestAssignDeleting.value = false;
  }

  var isAllocatedAssestAssignDeleting = false.obs;
  Future<void> deleteAllocatedAssignAssets(
      int? id, allocationDate, releasedDate) async {
    isAllocatedAssestAssignDeleting.value = true;
    final result = await ProfileService()
        .deleteAllocatedAssignAssets(id, allocationDate, releasedDate);
    await assignAssetsList();
    isAllocatedAssestAssignDeleting.value = false;
  }

  final List<TextEditingController> remarkControllers = [];
  Widget dailyTaskListWidget(BuildContext context, payloadData) {
    if (timeControllers.isEmpty ||
        timeControllers.length != dailyTaskDataList.length) {
      initializeTimeControllers(dailyTaskDataList.length);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Obx(
        () => isDailyTaskLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Daily Task List',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    isDailyTaskLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: dailyTaskDataList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: dailyTaskDataList[index]
                                                    .id
                                                    .toString() ==
                                                payloadData.toString()
                                            ? completeBackgroundColor
                                            : whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                lightGreyColor.withOpacity(0.2),
                                            blurRadius: 13.0,
                                            spreadRadius: 2,
                                            blurStyle: BlurStyle.normal,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 8.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${index + 1}.',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  width: 260.w,
                                                  child: Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    '${dailyTaskDataList[index].taskName}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Spacer(),
                                                Obx(
                                                  () => SizedBox(
                                                    height: 20.h,
                                                    width: 20.w,
                                                    child: Checkbox(
                                                      value:
                                                          dailyTaskListCheckbox[
                                                              index],
                                                      onChanged: (value) {
                                                        if (isDailyTaskSubmitting
                                                                .value ==
                                                            false) {
                                                          if (timeControllers[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty &&
                                                              remarkControllers[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                            dailyTaskListCheckbox[
                                                                index] = value!;
                                                            if (value) {
                                                              final taskId =
                                                                  dailyTaskDataList[
                                                                          index]
                                                                      .id;

                                                              dailyTaskSubmitList
                                                                  .add(
                                                                DailyTaskSubmitModel(
                                                                    taskId:
                                                                        taskId ??
                                                                            0,
                                                                    doneTime:
                                                                        timeControllers[index]
                                                                            .text,
                                                                    remarks: remarkControllers[
                                                                            index]
                                                                        .text),
                                                              );
                                                            } else {
                                                              final taskId =
                                                                  dailyTaskDataList[
                                                                          index]
                                                                      .id;
                                                              dailyTaskSubmitList
                                                                  .removeWhere(
                                                                (task) =>
                                                                    task.taskId ==
                                                                    taskId,
                                                              );
                                                            }
                                                          } else {
                                                            CustomToast()
                                                                .showCustomToast(
                                                                    "Please select time & remarks.");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 120.w,
                                                  child: TextField(
                                                    controller:
                                                        timeControllers[index],
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.access_time,
                                                        color: secondaryColor,
                                                      ),
                                                      hintText: timeFormate,
                                                      hintStyle: rubikRegular,
                                                      fillColor:
                                                          lightSecondaryColor,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 10.h),
                                                    ),
                                                    readOnly: true,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                InkWell(
                                                  onTap: () {
                                                    remarkShowAlertDialog(
                                                        context, index);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          lightSecondaryColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                    ),
                                                    width: 180.w,
                                                    height: 40.h,
                                                    child: Center(
                                                      child: Text(
                                                        '${remarkControllers[index].text.isEmpty ? "Add Remark" : remarkControllers[index].text}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                );
                              },
                            ),
                          ),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (isDailyTaskSubmitting.value == false) {
                            if (dailyTaskSubmitList.isNotEmpty) {
                              submitDailyTask(dailyTaskSubmitList, context);
                              timeControllers.clear();
                              remarkControllers.clear();
                            } else {
                              CustomToast()
                                  .showCustomToast("Please select daily task.");
                            }
                          }
                        },
                        text: isDailyTaskSubmitting.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: CircularProgressIndicator(
                                    color: whiteColor,
                                  )),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor),
                                  ),
                                ],
                              )
                            : Text(
                                submit,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  Future<void> remarkShowAlertDialog(
    BuildContext context,
    int index,
  ) async {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TaskCustomTextField(
                    controller: remarkControllers[index],
                    textCapitalization: TextCapitalization.sentences,
                    data: remark,
                    hintText: remark,
                    labelText: remark,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                      color: primaryColor,
                      text: Text(
                        add,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: whiteColor),
                      ),
                      onPressed: () {
                        remarkControllers[index].text =
                            remarkControllers[index].text.trim();
                        Get.back();
                      },
                      width: 200,
                      height: 40.h)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
