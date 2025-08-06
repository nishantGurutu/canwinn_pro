// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/costom_select_attachment.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/widgets/add_task.dart';
import 'package:task_management/view/widgets/edit_class.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class TaskScreenPage extends StatefulWidget {
  final String taskType;
  final String assignedType;
  final String? navigationType;
  final String? userId;
  const TaskScreenPage(this.navigationType, this.userId,
      {super.key, required this.taskType, required this.assignedType});

  @override
  State<TaskScreenPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskScreenPage> {
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  ScrollController _scrollController = ScrollController();
  final HomeController homeController = Get.find();
  final TextEditingController dueDateController = TextEditingController();
  @override
  void initState() {
    taskController.pagevalue.value = 1;
    taskController.selectedAssignedTask.value = widget.assignedType;
    _scrollController.addListener(_scrollListener);
    taskController.checkAllTaskList.clear();
    taskController.allTaskList.clear();
    taskController.newTaskList.clear();
    taskController.progressTaskList.clear();
    taskController.completeTaskList.clear();
    taskController.pagevalue.value = 1;
    taskController.responsiblePersonListApi(
        profileController.selectedDepartMentListData.value?.id, "");
    taskController.selectedTaskType.value = widget.taskType;
    taskController.selectedAssignedTask.value = widget.assignedType;
    priorityController.priorityApi();
    taskController.allProjectListApi();
    taskController.taskListApi(
        widget.taskType,
        taskController.selectedAssignedTask.value,
        'initstate',
        '',
        widget.userId);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      taskController.pagevalue.value += 1;
      await taskController.taskListApi(
          widget.taskType,
          taskController.selectedAssignedTask.value,
          'scroll',
          '',
          widget.userId);
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      taskController.pagevalue.value -= 1;
      await taskController.taskListApi(
          widget.taskType,
          taskController.selectedAssignedTask.value,
          'scroll',
          '',
          widget.userId);
    }
  }

  List<Color> colorList = [backgroundColor, whiteColor];

  @override
  void dispose() {
    _scrollController.dispose();
    taskController.isProgressStatus?.value = false;
    profileController.selectedDepartMentListData.value = null;
    taskController.selectedTaskType.value = 'All Task';
    taskController.selectedAssignedTask.value = 'Task created by me';
    super.dispose();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      taskController.isProfilePicUploading.value = true;
      taskController.pickedFile.value = File(pickedImage.path);
      taskController.profilePicPath.value = pickedImage.path.toString();
      taskController.isProfilePicUploading.value = false;
    } catch (e) {
      taskController.isProfilePicUploading.value = false;
    } finally {
      taskController.isProfilePicUploading.value = false;
    }
  }

  bool _isBackButtonPressed = false;
  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      if (widget.navigationType == "notification") {
        Get.offAll(() => SplashScreen());
      } else {
        Get.back();
      }
      return true;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (widget.navigationType.toString() == 'notification') {
                Get.offAll(() => SplashScreen());
              } else {
                Get.back();
              }
            },
            icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
          ),
          title: Text(
            task,
            style: TextStyle(
                color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: InkWell(
                onTap: () {
                  taskController.selectedAllProjectListData.value =
                      taskController.allProjectDataList.first;

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTask(
                          priorityController.priorityList,
                          taskController.allProjectDataList,
                          taskController.responsiblePersonList,
                          0,
                          ""),
                    ),
                  );
                },
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.r),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: whiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        dueDateController.text = formattedDate;
                        taskController.taskListApi(
                            widget.taskType,
                            widget.assignedType,
                            '',
                            dueDateController.text,
                            widget.userId);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: boxBorderColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.h),
                        child: Icon(
                          Icons.calendar_month,
                          size: 30.h,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 130.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: boxBorderColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: taskController.taskType.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            value: taskController.selectedTaskType.value.isEmpty
                                ? null
                                : taskController.selectedTaskType.value,
                            onChanged: (String? value) {
                              taskController.updateTaskType(value);
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: whiteColor,
                              ),
                            ),
                            hint: Text(
                              'Select Task'.tr,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Image.asset(
                                'assets/images/png/Vector 3.png',
                                color: secondaryColor,
                                height: 8.h,
                              ),
                              iconSize: 14,
                              iconEnabledColor: lightGreyColor,
                              iconDisabledColor: lightGreyColor,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200.h,
                              width: 130.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: whiteColor,
                                  border: Border.all(color: boxBorderColor)),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 155.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: boxBorderColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: taskController.taskSelectedType
                                .map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            value: taskController
                                    .selectedAssignedTask.value.isEmpty
                                ? null
                                : taskController.selectedAssignedTask.value,
                            onChanged: (String? value) {
                              taskController.updateAssignedTask(value);
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 155.w,
                              padding: EdgeInsets.only(left: 14.w, right: 14.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: whiteColor,
                              ),
                            ),
                            hint: Text(
                              'Select Task Type'.tr,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Image.asset(
                                'assets/images/png/Vector 3.png',
                                color: secondaryColor,
                                height: 8.h,
                              ),
                              iconSize: 14.h,
                              iconEnabledColor: lightGreyColor,
                              iconDisabledColor: lightGreyColor,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200.h,
                              width: 155.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: whiteColor,
                              ),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Obx(
                  () => taskController.isTaskLoading.value == true
                      ? SizedBox(
                          height: 700.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => taskController.selectedTaskType.value ==
                                      "All Task"
                                  ? allTaskList(taskController.allTaskList)
                                  : taskController.selectedTaskType.value ==
                                              "New Task" ||
                                          taskController
                                                  .selectedTaskType.value ==
                                              "Past Due" ||
                                          taskController
                                                  .selectedTaskType.value ==
                                              "Due Today"
                                      ? newTaskList(taskController.newTaskList)
                                      : taskController.selectedTaskType.value ==
                                              "Progress"
                                          ? progressTaskList(
                                              taskController.progressTaskList)
                                          : completeTaskList(
                                              taskController.completeTaskList),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController taskNameController3 = TextEditingController();
  final TextEditingController remarkController3 = TextEditingController();
  final TextEditingController startDateController3 = TextEditingController();
  final TextEditingController dueDateController3 = TextEditingController();
  final TextEditingController dueTimeController3 = TextEditingController();
  Widget allTaskList(RxList newTaskList) {
    return Obx(
      () => taskController.isTaskLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : newTaskList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No data',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: newTaskList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == newTaskList.length) {
                        return Obx(
                          () => taskController.isScrolling.value == true
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        );
                      }
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 5.h),
                            child: InkWell(
                              onTap: () {
                                Get.to(TaskDetails(
                                  taskId: newTaskList[index]['id'],
                                  assignedStatus:
                                      taskController.selectedAssignedTask.value,
                                  initialIndex: 0,
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(11.r),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: lightGreyColor.withOpacity(0.1),
                                      blurRadius: 6.0,
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.inner,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 10.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${newTaskList[index]['title']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: changeTextColor(
                                          heading16,
                                          newTaskList[index]
                                                          ['is_late_completed']
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "0"
                                              ? redColor
                                              : textColor,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        'Task ID ${newTaskList[index]['id']}',
                                        style: changeTextColor(
                                          heading8,
                                          newTaskList[index]
                                                          ['is_late_completed']
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "0"
                                              ? redColor
                                              : textColor,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                              color: newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'medium'
                                                  ? Color(0xffFF8700)
                                                  : newTaskList[index][
                                                                  'priority_name']
                                                              ?.toLowerCase() ==
                                                          'low'
                                                      ? Color(0xffFFCD57)
                                                      : Color(0xffFF0005),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 2.h),
                                              child: Center(
                                                child: Text(
                                                  '${newTaskList[index]['priority_name']}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Container(
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                              color: newTaskList[index][
                                                              'effective_status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "pending"
                                                  ? Color(0xffD045FF)
                                                  : newTaskList[index][
                                                                  'effective_status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "progress"
                                                      ? Color.fromARGB(
                                                          95, 16, 129, 18)
                                                      : Color(0xff0086FF),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 2.h),
                                              child: Center(
                                                child: Text(
                                                  '${newTaskList[index]['effective_status'].toString()}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: whiteColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    calenderTaskicon),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Text(
                                                  '${newTaskList[index]['task_date']}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: secondaryTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 15.w,
                            top: 5.h,
                            child: SizedBox(
                              height: 30.h,
                              width: 25.w,
                              child: PopupMenuButton<String>(
                                color: whiteColor,
                                constraints: BoxConstraints(
                                  maxWidth: 200.w,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                shadowColor: lightGreyColor,
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.more_vert),
                                onSelected: (String result) async {
                                  switch (result) {
                                    case 'edit':
                                      for (var projectData in projectController
                                          .allProjectDataList) {
                                        if (projectData.id.toString() ==
                                            newTaskList[index]['project_id']
                                                .toString()) {
                                          projectController
                                              .selectedAllProjectListData
                                              .value = projectData;
                                          await profileController
                                              .departmentList(projectController
                                                  .selectedAllProjectListData
                                                  .value
                                                  ?.id);
                                          break;
                                        }
                                      }
                                      await taskController
                                          .responsiblePersonListApi(
                                              profileController
                                                  .selectedDepartMentListData
                                                  .value
                                                  ?.id,
                                              "");
                                      taskNameController3.text =
                                          newTaskList[index]['title'];
                                      remarkController3.text =
                                          newTaskList[index]['description'];
                                      startDateController3.text =
                                          newTaskList[index]['start_date'];
                                      dueDateController3.text =
                                          newTaskList[index]['due_date'];
                                      dueTimeController3.text =
                                          newTaskList[index]['due_time'];

                                      for (var priorityData
                                          in priorityController.priorityList) {
                                        if (priorityData.id.toString() ==
                                            newTaskList[index]['priority']
                                                .toString()) {
                                          priorityController
                                              .selectedPriorityData
                                              .value = priorityData;
                                          break;
                                        }
                                      }

                                      for (var deptData in profileController
                                          .departmentDataList) {
                                        if (deptData.id.toString() ==
                                            newTaskList[index]['department_id']
                                                .toString()) {
                                          profileController
                                              .selectedDepartMentListData
                                              .value = deptData;
                                          break;
                                        }
                                      }
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: EditTask(
                                            priorityController.priorityList,
                                            projectController
                                                .allProjectDataList,
                                            taskController
                                                .responsiblePersonList,
                                            newTaskList[index]['id'],
                                            taskNameController3,
                                            remarkController3,
                                            startDateController3,
                                            dueDateController3,
                                            dueTimeController3,
                                            newTaskList[index]['assigned_to'],
                                          ),
                                        ),
                                      );
                                      break;
                                    case 'delete':
                                      await taskController
                                          .deleteTask(newTaskList[index]['id']);
                                      break;
                                    case 'status':
                                      taskController.isCompleteStatus?.value =
                                          false;
                                      taskController.isProgressStatus?.value =
                                          false;
                                      statusRemarkController.clear();
                                      taskController.profilePicPath2.value = '';
                                      await changeStatusDialog(
                                        context,
                                        newTaskList[index]['id'],
                                        newTaskList[index]['status'],
                                        newTaskList[index]['parent_id'],
                                        newTaskList[index]
                                            ['is_subtask_completed'],
                                        newTaskList[index]['effective_status'],
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  if (taskController
                                          .selectedAssignedTask.value ==
                                      "Task created by me")
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Image.asset(
                                          "assets/images/png/edit-icon.png",
                                          height: 20.h,
                                        ),
                                        title: Text(
                                          'Edit',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  if (taskController
                                          .selectedAssignedTask.value ==
                                      "Task created by me")
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Image.asset(
                                          'assets/images/png/delete-icon.png',
                                          height: 20.h,
                                        ),
                                        title: Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  if (taskController
                                          .selectedAssignedTask.value ==
                                      "Assigned to me")
                                    PopupMenuItem<String>(
                                      value: 'status',
                                      child: ListTile(
                                        leading: Image.asset(
                                          'assets/images/png/document.png',
                                          height: 20.h,
                                        ),
                                        title: Text(
                                          'Change Status',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget newTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No New data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: InkWell(
                          onTap: () {
                            Get.to(TaskDetails(
                              taskId: newTaskList[index]['id'],
                              assignedStatus:
                                  taskController.selectedAssignedTask.value,
                              initialIndex: 0,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11.r),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGreyColor.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${newTaskList[index]['title']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: changeTextColor(
                                      heading16,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: changeTextColor(
                                      heading8,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          // color: newTaskList[index]
                                          //                 ['priority_name']
                                          //             ?.toLowerCase() ==
                                          //         'medium'
                                          //     ? softYellowColor
                                          //     : newTaskList[index]
                                          //                     ['priority_name']
                                          //                 ?.toLowerCase() ==
                                          //             'low'
                                          //         ? completeBackgroundColor
                                          //         : softredColor,
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? Color(0xffFF8700)
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? Color(0xffFFCD57)
                                                  : Color(0xffFF0005),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['priority_name']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  // newTaskList[index][
                                                  //                 'priority_name']
                                                  //             ?.toLowerCase() ==
                                                  //         'medium'
                                                  //     ? mediumColor
                                                  //     : newTaskList[index][
                                                  //                     'priority_name']
                                                  //                 ?.toLowerCase() ==
                                                  //             'low'
                                                  //         ? blueColor
                                                  //         : slightlyDarkColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          // color: newTaskList[index]
                                          //                 ['effective_status']
                                          //             .toString()
                                          //             .toLowerCase() ==
                                          //         "pending"
                                          //     ? pendingBackgroundColor
                                          //     : newTaskList[index][
                                          //                     'effective_status']
                                          //                 .toString()
                                          //                 .toLowerCase() ==
                                          //             "progress"
                                          //         ? progressBackgroundColor
                                          //         : completeBackgroundColor,

                                          color: newTaskList[index]
                                                          ['effective_status']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "pending"
                                              ? Color(0xffD045FF)
                                              : newTaskList[index][
                                                              'effective_status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "progress"
                                                  ? Color.fromARGB(
                                                      95, 16, 129, 18)
                                                  : Color(0xff0086FF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['effective_status'].toString()}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  // newTaskList[index][
                                                  //                 'effective_status']
                                                  //             .toString()
                                                  //             .toLowerCase() ==
                                                  //         "pending"
                                                  //     ? pendingColor
                                                  //     : newTaskList[index][
                                                  //                     'effective_status']
                                                  //                 .toString()
                                                  //                 .toLowerCase() ==
                                                  //             "progress"
                                                  //         ? elegentGreenColor
                                                  //         : blueColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(calenderTaskicon),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15.w,
                        top: 5.h,
                        child: SizedBox(
                          height: 30.h,
                          width: 25.w,
                          child: PopupMenuButton<String>(
                            color: whiteColor,
                            constraints: BoxConstraints(
                              maxWidth: 200.w,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            shadowColor: lightGreyColor,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String result) {
                              switch (result) {
                                case 'edit':
                                  for (var projectData
                                      in projectController.allProjectDataList) {
                                    if (projectData.id.toString() ==
                                        newTaskList[index]['project_id']
                                            .toString()) {
                                      projectController
                                          .selectedAllProjectListData
                                          .value = projectData;
                                      profileController.departmentList(
                                          projectController
                                              .selectedAllProjectListData
                                              .value
                                              ?.id);
                                      break;
                                    }
                                  }
                                  taskController.responsiblePersonListApi(
                                      profileController
                                          .selectedDepartMentListData.value?.id,
                                      "");
                                  taskNameController3.text =
                                      newTaskList[index]['title'];
                                  remarkController3.text =
                                      newTaskList[index]['description'];
                                  startDateController3.text =
                                      newTaskList[index]['start_date'];
                                  dueDateController3.text =
                                      newTaskList[index]['due_date'];
                                  dueTimeController3.text =
                                      newTaskList[index]['due_time'];

                                  for (var priorityData
                                      in priorityController.priorityList) {
                                    if (priorityData.id.toString() ==
                                        newTaskList[index]['priority']
                                            .toString()) {
                                      priorityController.selectedPriorityData
                                          .value = priorityData;
                                      break;
                                    }
                                  }

                                  for (var deptData
                                      in profileController.departmentDataList) {
                                    if (deptData.id.toString() ==
                                        newTaskList[index]['department_id']
                                            .toString()) {
                                      profileController
                                          .selectedDepartMentListData
                                          .value = deptData;
                                      break;
                                    }
                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: EditTask(
                                        priorityController.priorityList,
                                        projectController.allProjectDataList,
                                        taskController.responsiblePersonList,
                                        newTaskList[index]['id'],
                                        taskNameController3,
                                        remarkController3,
                                        startDateController3,
                                        dueDateController3,
                                        dueTimeController3,
                                        newTaskList[index]['assigned_to'],
                                      ),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  taskController
                                      .deleteTask(newTaskList[index]['id']);
                                  break;
                                case 'status':
                                  taskController.isCompleteStatus?.value =
                                      false;
                                  taskController.isProgressStatus?.value =
                                      false;
                                  statusRemarkController.clear();
                                  taskController.profilePicPath2.value = '';
                                  changeStatusDialog(
                                    context,
                                    newTaskList[index]['id'],
                                    newTaskList[index]['status'],
                                    newTaskList[index]['parent_id'],
                                    newTaskList[index]['is_subtask_completed'],
                                    newTaskList[index]['effective_status'],
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/images/png/edit-icon.png",
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/delete-icon.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Assigned to me")
                                PopupMenuItem<String>(
                                  value: 'status',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/document.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Change Status',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  Widget progressTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No Progress data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: InkWell(
                          onTap: () {
                            Get.to(TaskDetails(
                              taskId: newTaskList[index]['id'],
                              assignedStatus:
                                  taskController.selectedAssignedTask.value,
                              initialIndex: 0,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11.r),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGreyColor.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${newTaskList[index]['title']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: changeTextColor(
                                      heading16,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: changeTextColor(
                                      heading8,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          // color: newTaskList[index]
                                          //                 ['priority_name']
                                          //             ?.toLowerCase() ==
                                          //         'medium'
                                          //     ? softYellowColor
                                          //     : newTaskList[index]
                                          //                     ['priority_name']
                                          //                 ?.toLowerCase() ==
                                          //             'low'
                                          //         ? completeBackgroundColor
                                          //         : softredColor,
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? Color(0xffFF8700)
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? Color(0xffFFCD57)
                                                  : Color(0xffFF0005),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['priority_name']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  // newTaskList[index][
                                                  //                 'priority_name']
                                                  //             ?.toLowerCase() ==
                                                  //         'medium'
                                                  //     ? mediumColor
                                                  //     : newTaskList[index][
                                                  //                     'priority_name']
                                                  //                 ?.toLowerCase() ==
                                                  //             'low'
                                                  //         ? blueColor
                                                  //         : slightlyDarkColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          // color: newTaskList[index]
                                          //                 ['effective_status']
                                          //             .toString()
                                          //             .toLowerCase() ==
                                          //         "pending"
                                          //     ? pendingBackgroundColor
                                          //     : newTaskList[index][
                                          //                     'effective_status']
                                          //                 .toString()
                                          //                 .toLowerCase() ==
                                          //             "progress"
                                          //         ? progressBackgroundColor
                                          //         : completeBackgroundColor,
                                          color: newTaskList[index]
                                                          ['effective_status']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "pending"
                                              ? Color(0xffD045FF)
                                              : newTaskList[index][
                                                              'effective_status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "progress"
                                                  ? Color.fromARGB(
                                                      95, 16, 129, 18)
                                                  : Color(0xff0086FF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['effective_status'].toString()}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  // newTaskList[index][
                                                  //                 'effective_status']
                                                  //             .toString()
                                                  //             .toLowerCase() ==
                                                  //         "pending"
                                                  //     ? pendingColor
                                                  //     : newTaskList[index][
                                                  //                     'effective_status']
                                                  //                 .toString()
                                                  //                 .toLowerCase() ==
                                                  //             "progress"
                                                  //         ? elegentGreenColor
                                                  //         : blueColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(calenderTaskicon),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15.w,
                        top: 5.h,
                        child: SizedBox(
                          height: 30.h,
                          width: 25.w,
                          child: PopupMenuButton<String>(
                            color: whiteColor,
                            constraints: BoxConstraints(
                              maxWidth: 200.w,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            shadowColor: lightGreyColor,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String result) {
                              switch (result) {
                                case 'edit':
                                  for (var projectData
                                      in projectController.allProjectDataList) {
                                    if (projectData.id.toString() ==
                                        newTaskList[index]['project_id']
                                            .toString()) {
                                      projectController
                                          .selectedAllProjectListData
                                          .value = projectData;
                                      profileController.departmentList(
                                          projectController
                                              .selectedAllProjectListData
                                              .value
                                              ?.id);
                                      break;
                                    }
                                  }
                                  taskController.responsiblePersonListApi(
                                      profileController
                                          .selectedDepartMentListData.value?.id,
                                      "");
                                  taskNameController3.text =
                                      newTaskList[index]['title'];
                                  remarkController3.text =
                                      newTaskList[index]['description'];
                                  startDateController3.text =
                                      newTaskList[index]['start_date'];
                                  dueDateController3.text =
                                      newTaskList[index]['due_date'];
                                  dueTimeController3.text =
                                      newTaskList[index]['due_time'];

                                  for (var priorityData
                                      in priorityController.priorityList) {
                                    if (priorityData.id.toString() ==
                                        newTaskList[index]['priority']
                                            .toString()) {
                                      priorityController.selectedPriorityData
                                          .value = priorityData;
                                      break;
                                    }
                                  }

                                  for (var deptData
                                      in profileController.departmentDataList) {
                                    if (deptData.id.toString() ==
                                        newTaskList[index]['department_id']
                                            .toString()) {
                                      profileController
                                          .selectedDepartMentListData
                                          .value = deptData;
                                      break;
                                    }
                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: EditTask(
                                        priorityController.priorityList,
                                        projectController.allProjectDataList,
                                        taskController.responsiblePersonList,
                                        newTaskList[index]['id'],
                                        taskNameController3,
                                        remarkController3,
                                        startDateController3,
                                        dueDateController3,
                                        dueTimeController3,
                                        newTaskList[index]['assigned_to'],
                                      ),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  taskController
                                      .deleteTask(newTaskList[index]['id']);
                                  break;
                                case 'status':
                                  taskController.isCompleteStatus?.value =
                                      false;
                                  taskController.isProgressStatus?.value =
                                      false;
                                  statusRemarkController.clear();
                                  taskController.profilePicPath2.value = '';
                                  changeStatusDialog(
                                    context,
                                    newTaskList[index]['id'],
                                    newTaskList[index]['status'],
                                    newTaskList[index]['parent_id'],
                                    newTaskList[index]['is_subtask_completed'],
                                    newTaskList[index]['effective_status'],
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/images/png/edit-icon.png",
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/delete-icon.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Assigned to me")
                                PopupMenuItem<String>(
                                  value: 'status',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/document.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Change Status',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  Widget completeTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No Completed data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: InkWell(
                          onTap: () {
                            Get.to(TaskDetails(
                              taskId: newTaskList[index]['id'],
                              assignedStatus:
                                  taskController.selectedAssignedTask.value,
                              initialIndex: 0,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11.r),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGreyColor.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.inner,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${newTaskList[index]['title']}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: changeTextColor(
                                      heading16,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: changeTextColor(
                                      heading8,
                                      newTaskList[index]['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? Color(0xffFF8700)
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? Color(0xffFFCD57)
                                                  : Color(0xffFF0005),
                                          // color: newTaskList[index]
                                          //                 ['priority_name']
                                          //             ?.toLowerCase() ==
                                          //         'medium'
                                          //     ? softYellowColor
                                          //     : newTaskList[index]
                                          //                     ['priority_name']
                                          //                 ?.toLowerCase() ==
                                          //             'low'
                                          //         ? completeBackgroundColor
                                          //         : softredColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['priority_name']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  //  newTaskList[index][
                                                  //                 'priority_name']
                                                  //             ?.toLowerCase() ==
                                                  //         'medium'
                                                  //     ? mediumColor
                                                  //     : newTaskList[index][
                                                  //                     'priority_name']
                                                  //                 ?.toLowerCase() ==
                                                  //             'low'
                                                  //         ? blueColor
                                                  //         : slightlyDarkColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          // color: newTaskList[index]
                                          //                 ['effective_status']
                                          //             .toString()
                                          //             .toLowerCase() ==
                                          //         "pending"
                                          //     ? pendingBackgroundColor
                                          //     : newTaskList[index][
                                          //                     'effective_status']
                                          //                 .toString()
                                          //                 .toLowerCase() ==
                                          //             "progress"
                                          //         ? progressBackgroundColor
                                          //         : completeBackgroundColor,
                                          color: newTaskList[index]
                                                          ['effective_status']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "pending"
                                              ? Color(0xffD045FF)
                                              : newTaskList[index][
                                                              'effective_status']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "progress"
                                                  ? Color.fromARGB(
                                                      95, 16, 129, 18)
                                                  : Color(0xff0086FF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 2.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['effective_status'].toString()}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor
                                                  // newTaskList[index][
                                                  //                 'effective_status']
                                                  //             .toString()
                                                  //             .toLowerCase() ==
                                                  //         "pending"
                                                  //     ? pendingColor
                                                  //     : newTaskList[index][
                                                  //                     'effective_status']
                                                  //                 .toString()
                                                  //                 .toLowerCase() ==
                                                  //             "progress"
                                                  //         ? elegentGreenColor
                                                  //         : blueColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(calenderTaskicon),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15.w,
                        top: 5.h,
                        child: SizedBox(
                          height: 30.h,
                          width: 25.w,
                          child: PopupMenuButton<String>(
                            color: whiteColor,
                            constraints: BoxConstraints(
                              maxWidth: 200.w,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            shadowColor: lightGreyColor,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.more_vert),
                            onSelected: (String result) {
                              switch (result) {
                                case 'edit':
                                  for (var projectData
                                      in projectController.allProjectDataList) {
                                    if (projectData.id.toString() ==
                                        newTaskList[index]['project_id']
                                            .toString()) {
                                      projectController
                                          .selectedAllProjectListData
                                          .value = projectData;
                                      profileController.departmentList(
                                          projectController
                                              .selectedAllProjectListData
                                              .value
                                              ?.id);
                                      break;
                                    }
                                  }
                                  taskController.responsiblePersonListApi(
                                      profileController
                                          .selectedDepartMentListData.value?.id,
                                      "");
                                  taskNameController3.text =
                                      newTaskList[index]['title'];
                                  remarkController3.text =
                                      newTaskList[index]['description'];
                                  startDateController3.text =
                                      newTaskList[index]['start_date'];
                                  dueDateController3.text =
                                      newTaskList[index]['due_date'];
                                  dueTimeController3.text =
                                      newTaskList[index]['due_time'];

                                  for (var priorityData
                                      in priorityController.priorityList) {
                                    if (priorityData.id.toString() ==
                                        newTaskList[index]['priority']
                                            .toString()) {
                                      priorityController.selectedPriorityData
                                          .value = priorityData;
                                      break;
                                    }
                                  }

                                  for (var deptData
                                      in profileController.departmentDataList) {
                                    if (deptData.id.toString() ==
                                        newTaskList[index]['department_id']
                                            .toString()) {
                                      profileController
                                          .selectedDepartMentListData
                                          .value = deptData;
                                      break;
                                    }
                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: EditTask(
                                        priorityController.priorityList,
                                        projectController.allProjectDataList,
                                        taskController.responsiblePersonList,
                                        newTaskList[index]['id'],
                                        taskNameController3,
                                        remarkController3,
                                        startDateController3,
                                        dueDateController3,
                                        dueTimeController3,
                                        newTaskList[index]['assigned_to'],
                                      ),
                                    ),
                                  );
                                  break;
                                case 'delete':
                                  taskController
                                      .deleteTask(newTaskList[index]['id']);
                                  break;
                                case 'status':
                                  taskController.isCompleteStatus?.value =
                                      false;
                                  taskController.isProgressStatus?.value =
                                      false;
                                  statusRemarkController.clear();
                                  taskController.profilePicPath2.value = '';
                                  changeStatusDialog(
                                    context,
                                    newTaskList[index]['id'],
                                    newTaskList[index]['status'],
                                    newTaskList[index]['parent_id'],
                                    newTaskList[index]['is_subtask_completed'],
                                    newTaskList[index]['effective_status'],
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/images/png/edit-icon.png",
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Task created by me")
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/delete-icon.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              if (taskController.selectedAssignedTask.value ==
                                  "Assigned to me")
                                PopupMenuItem<String>(
                                  value: 'status',
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/png/document.png',
                                      height: 20.h,
                                    ),
                                    title: Text(
                                      'Change Status',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController statusRemarkController = TextEditingController();
  Future<void> changeStatusDialog(
    BuildContext context,
    newTaskListId,
    newTaskListStatus,
    parentId,
    isubtaskCompleted,
    efectiveStatus,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: efectiveStatus.toString().toLowerCase() == "completed"
                ? 230.h
                : 340.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: efectiveStatus.toString().toLowerCase() == "completed"
                  ? Center(
                      child: Text(
                        'Status Complete',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Update Status',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Container(
                                    width: 25.w,
                                    height: 25.h,
                                    child: Radio(
                                      value: 'progress',
                                      groupValue: taskController
                                          .isProgressSelected?.value,
                                      onChanged: (value) {
                                        taskController.isProgressSelected
                                            ?.value = value ?? "";
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'In Progress',
                                  style: heading5,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Container(
                                    width: 25.w,
                                    height: 25.h,
                                    child: Radio(
                                      value: 'complete',
                                      groupValue: taskController
                                          .isProgressSelected?.value,
                                      onChanged: (value) {
                                        taskController.isProgressSelected
                                            ?.value = value ?? "";
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  'Complete',
                                  style: heading5,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'Attachment',
                              style: heading5,
                            ),
                            SvgPicture.asset(
                              attachmentIcon,
                              height: 20.h,
                            ),
                            SizedBox(width: 10.w),
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  AttachmentClass()
                                      .selectAttachmentDialog(context);
                                },
                                child: taskController
                                        .pickedFile2.value.path.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => ImageScreen(
                                                file: taskController
                                                    .pickedFile2.value,
                                              ));
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: 35.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4.r),
                                            ),
                                            child: Image.file(
                                              taskController.pickedFile2.value,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SvgPicture.asset(addPhotoIcon),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TaskCustomTextField(
                          controller: statusRemarkController,
                          textCapitalization: TextCapitalization.sentences,
                          data: statusRemark,
                          hintText: statusRemark,
                          labelText: statusRemark,
                          index: 0,
                          maxLine: 3,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => SizedBox(
                                width: 100.w,
                                height: 40.h,
                                child: CustomButton(
                                  onPressed: () async {
                                    if (taskController
                                            .isProgressUpdating.value ==
                                        false) {
                                      if (taskController
                                              .isProgressSelected?.value !=
                                          "") {
                                        if (statusRemarkController
                                            .text.isNotEmpty) {
                                          if (taskController
                                                  .isProgressSelected?.value ==
                                              "progress") {
                                            taskController.taskIdFromDetails =
                                                newTaskListId;
                                            await taskController
                                                .updateProgressTask(
                                                    newTaskListId,
                                                    statusRemarkController.text,
                                                    1,
                                                    from: 'list');
                                          } else {
                                            taskController.taskIdFromDetails =
                                                newTaskListId;
                                            await taskController
                                                .updateProgressTask(
                                                    newTaskListId,
                                                    statusRemarkController.text,
                                                    2,
                                                    from: 'list');
                                          }
                                        } else {
                                          CustomToast().showCustomToast(
                                              "Please add remark.");
                                        }
                                      } else {
                                        CustomToast().showCustomToast(
                                            "Please select status");
                                      }
                                    }
                                  },
                                  text:
                                      taskController.isProgressUpdating.value ==
                                              true
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: whiteColor,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                SvgPicture.asset(doneTaskIcon),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  done,
                                                  style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                  width: double.infinity,
                                  color: primaryColor,
                                  height: 40.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 100.w,
                              height: 40.h,
                              child: CustomButton(
                                onPressed: () {
                                  Get.back();
                                },
                                text: Text(
                                  cancel,
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                width: double.infinity,
                                color: primaryColor,
                                height: 40.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: file),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  ValueNotifier<int?> focusedIndexNotifier3 = ValueNotifier<int?>(null);
}
