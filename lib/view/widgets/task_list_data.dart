import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/costom_select_attachment.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/widgets/edit_class.dart';

class TaskListData extends StatefulWidget {
  final List newTaskList;
  final String taskType;
  final String assignedType;
  const TaskListData(
    this.newTaskList,
    this.taskType,
    this.assignedType, {
    super.key,
  });

  @override
  State<TaskListData> createState() => _TaskListDataState();
}

class _TaskListDataState extends State<TaskListData> {
  final TaskController taskController = Get.find();
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final PriorityController priorityController = Get.find();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    taskController.pagevalue.value = 1;
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      taskController.pagevalue.value += 1;
      taskController.taskListApi(
        widget.taskType,
        widget.assignedType,
        'scroll',
        '',
        '',
        '',
      );
      print('scroll controller listining');
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      taskController.pagevalue.value -= 1;
      taskController.taskListApi(
        widget.taskType,
        widget.assignedType,
        'scroll',
        '',
        '',
        '',
      );
    }
  }

  final TextEditingController taskNameController3 = TextEditingController();
  final TextEditingController remarkController3 = TextEditingController();
  final TextEditingController startDateController3 = TextEditingController();
  final TextEditingController dueDateController3 = TextEditingController();
  final TextEditingController dueTimeController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          taskController.isTaskLoading.value == true
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : widget.newTaskList.isEmpty
              ? Expanded(
                child: Center(
                  child: Text(
                    'No data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              )
              : Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: widget.newTaskList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == widget.newTaskList.length) {
                      return Obx(
                        () =>
                            taskController.isScrolling.value
                                ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                                : SizedBox.shrink(),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            TaskDetails(
                              taskId: widget.newTaskList[index]['id'],
                              assignedStatus:
                                  taskController.selectedAssignedTask.value,
                              initialIndex: 0,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: lightGreyColor.withOpacity(0.2),
                                blurRadius: 13.0,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Task ID ${widget.newTaskList[index]['id']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            widget.newTaskList[index]['is_late_completed']
                                                        .toString()
                                                        .toLowerCase() !=
                                                    "0"
                                                ? redColor
                                                : textColor,
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      height: 30.h,
                                      width: 25.w,
                                      child: PopupMenuButton<String>(
                                        color: whiteColor,
                                        constraints: BoxConstraints(
                                          maxWidth: 200.w,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                        shadowColor: lightGreyColor,
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'edit':
                                              for (var projectData
                                                  in projectController
                                                      .allProjectDataList) {
                                                if (projectData.id.toString() ==
                                                    widget
                                                        .newTaskList[index]['project_id']
                                                        .toString()) {
                                                  projectController
                                                      .selectedAllProjectListData
                                                      .value = projectData;
                                                  profileController.departmentList(
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value
                                                        ?.id,
                                                  );
                                                  break;
                                                }
                                              }
                                              taskController
                                                  .responsiblePersonListApi(
                                                    profileController
                                                        .selectedDepartMentListData
                                                        .value
                                                        ?.id,
                                                    "",
                                                  );
                                              taskNameController3.text =
                                                  widget
                                                      .newTaskList[index]['title'];
                                              remarkController3.text =
                                                  widget
                                                      .newTaskList[index]['description'];
                                              startDateController3.text =
                                                  widget
                                                      .newTaskList[index]['start_date'];
                                              dueDateController3.text =
                                                  widget
                                                      .newTaskList[index]['due_date'];
                                              dueTimeController3.text =
                                                  widget
                                                      .newTaskList[index]['due_time'];

                                              for (var priorityData
                                                  in priorityController
                                                      .priorityList) {
                                                if (priorityData.id
                                                        .toString() ==
                                                    widget
                                                        .newTaskList[index]['priority']
                                                        .toString()) {
                                                  priorityController
                                                      .selectedPriorityData
                                                      .value = priorityData;
                                                  break;
                                                }
                                              }
                                              for (var deptData
                                                  in profileController
                                                      .departmentDataList) {
                                                if (deptData.id.toString() ==
                                                    widget
                                                        .newTaskList[index]['department_id']
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
                                                builder:
                                                    (context) => Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(
                                                              context,
                                                            ).viewInsets.bottom,
                                                      ),
                                                      child: EditTask(
                                                        priorityController
                                                            .priorityList,
                                                        projectController
                                                            .allProjectDataList,
                                                        taskController
                                                            .responsiblePersonList,
                                                        widget
                                                            .newTaskList[index]['id'],
                                                        taskNameController3,
                                                        remarkController3,
                                                        startDateController3,
                                                        dueDateController3,
                                                        dueTimeController3,
                                                        widget
                                                            .newTaskList[index]['assigned_to'],
                                                        widget
                                                            .newTaskList[index]['reviewer'],
                                                        widget
                                                            .newTaskList[index]['priority'],
                                                        widget
                                                            .newTaskList[index]['attachment'],
                                                      ),
                                                    ),
                                              );
                                              break;
                                            case 'delete':
                                              taskController.deleteTask(
                                                widget.newTaskList[index]['id'],
                                              );
                                              break;
                                            case 'status':
                                              taskController
                                                  .isCompleteStatus
                                                  ?.value = false;
                                              taskController
                                                  .isProgressStatus
                                                  ?.value = false;
                                              statusRemarkController.clear();
                                              taskController
                                                  .profilePicPath2
                                                  .value = '';
                                              changeStatusDialog(
                                                context,
                                                widget.newTaskList[index]['id'],
                                                widget
                                                    .newTaskList[index]['status'],
                                                widget
                                                    .newTaskList[index]['parent_id'],
                                                widget
                                                    .newTaskList[index]['is_subtask_completed'],
                                              );
                                              break;
                                          }
                                        },
                                        itemBuilder:
                                            (
                                              BuildContext context,
                                            ) => <PopupMenuEntry<String>>[
                                              if (taskController
                                                      .selectedAssignedTask
                                                      .value ==
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
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (taskController
                                                      .selectedAssignedTask
                                                      .value ==
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
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (taskController
                                                      .selectedAssignedTask
                                                      .value ==
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
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${widget.newTaskList[index]['title']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        widget.newTaskList[index]['is_late_completed']
                                                    .toString()
                                                    .toLowerCase() !=
                                                "0"
                                            ? redColor
                                            : textColor,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '${widget.newTaskList[index]['description']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        widget.newTaskList[index]['is_late_completed']
                                                    .toString()
                                                    .toLowerCase() !=
                                                "0"
                                            ? redColor
                                            : textColor,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                          vertical: 4.h,
                                        ),
                                        child: Text(
                                          '${widget.newTaskList[index]['priority_name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                widget.newTaskList[index]['priority_name']
                                                            ?.toLowerCase() ==
                                                        'medium'
                                                    ? mediumColor
                                                    : widget.newTaskList[index]['priority_name']
                                                            ?.toLowerCase() ==
                                                        'low'
                                                    ? secondaryTextColor
                                                    : blueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                          vertical: 4.h,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${widget.newTaskList[index]['status'].toString() == "0"
                                                ? "Pending"
                                                : widget.newTaskList[index]['status'].toString() == "1"
                                                ? "Process"
                                                : "Complete"}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  widget.newTaskList[index]['status']
                                                              .toString() ==
                                                          "0"
                                                      ? buttonRedColor
                                                      : widget.newTaskList[index]['status']
                                                              .toString() ==
                                                          "1"
                                                      ? mediumColor
                                                      : blueColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                '${widget.newTaskList[index]['task_date']}',
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: secondaryTextColor,
                                                ),
                                              ),
                                            ],
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
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: newTaskListStatus.toString() == "2" ? 230.h : 340.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child:
                  newTaskListStatus.toString() == "2"
                      ? Center(
                        child: Text(
                          'Status Complete',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Change Status',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Container(
                                      height: 25.h,
                                      width: 25.w,
                                      child: Checkbox(
                                        value:
                                            taskController
                                                .isProgressStatus
                                                ?.value,
                                        onChanged: (value) {
                                          taskController
                                              .isProgressStatus
                                              ?.value = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              newTaskListStatus.toString() == "1"
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => Container(
                                          height: 25.h,
                                          width: 25.w,
                                          child: Checkbox(
                                            value:
                                                taskController
                                                    .isCompleteStatus
                                                    ?.value,
                                            onChanged: (value) {
                                              taskController
                                                  .isProgressStatus
                                                  ?.value = false;
                                              taskController
                                                  .isCompleteStatus
                                                  ?.value = value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Complete',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  )
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  AttachmentClass().selectAttachmentDialog(
                                    context,
                                  );
                                },
                                child: Container(
                                  height: 35.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    color: lightSecondaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/png/attachment-icon.png',
                                        width: 35.w,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Add Attachment',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Obx(
                                () =>
                                    taskController
                                            .profilePicPath2
                                            .value
                                            .isNotEmpty
                                        ? Container(
                                          height: 40.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: secondaryTextColor,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                            child: Image.file(
                                              File(
                                                taskController
                                                    .profilePicPath2
                                                    .value,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                        : SizedBox(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
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
                          SizedBox(height: 20.h),
                          Obx(
                            () => CustomButton(
                              onPressed: () {
                                if (taskController.isProgressUpdating.value ==
                                    false) {
                                  if (taskController.isProgressStatus?.value ==
                                          true ||
                                      taskController.isCompleteStatus?.value ==
                                          true) {
                                    if (statusRemarkController
                                        .text
                                        .isNotEmpty) {
                                      if (newTaskListStatus.toString() == "0") {
                                        taskController.taskIdFromDetails =
                                            newTaskListId;
                                        taskController.updateProgressTask(
                                          newTaskListId,
                                          statusRemarkController.text,
                                          1,
                                          from: 'list',
                                        );
                                      } else if (newTaskListStatus.toString() ==
                                          "1") {
                                        if (taskController
                                                .isCompleteStatus
                                                ?.value ==
                                            true) {
                                          taskController.taskIdFromDetails =
                                              newTaskListId;
                                          taskController.updateProgressTask(
                                            newTaskListId,
                                            statusRemarkController.text,
                                            2,
                                            from: 'list',
                                          );
                                        } else {
                                          taskController.taskIdFromDetails =
                                              newTaskListId;
                                          taskController.updateProgressTask(
                                            newTaskListId,
                                            statusRemarkController.text,
                                            1,
                                            from: 'list',
                                          );
                                        }
                                      }
                                    } else {
                                      CustomToast().showCustomToast(
                                        "Please add remark.",
                                      );
                                    }
                                  } else {
                                    CustomToast().showCustomToast(
                                      "Please select status",
                                    );
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
                                          SizedBox(width: 8.w),
                                          Text(
                                            loading,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        done,
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
      },
    );
  }
}
