import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/task_details_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/task_attachment.dart';
import 'package:task_management/view/widgets/task_comments.dart';
import 'package:task_management/view/widgets/task_overview.dart';
import '../../controller/discussion_controller.dart';

class TaskDetails extends StatefulWidget {
  final int? taskId;
  final String? assignedStatus;
  final int initialIndex;
  const TaskDetails(
      {super.key,
      this.taskId,
      required this.assignedStatus,
      required this.initialIndex});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final DiscussionController discussionController =
      Get.put(DiscussionController());
  @override
  void initState() {
    taskController.taskDetailsApi(widget.taskId);
    discussionController.pickedFile2.value == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => taskController.isTaskDetailsLoading.value == true
          ? Scaffold(
              backgroundColor: whiteColor,
              body: Container(
                color: backgroundColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                backgroundColor: whiteColor,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
                ),
                title: Row(
                  children: [
                    Text(
                      "Task Details",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  if (widget.assignedStatus == "Assigned to me")
                    if (taskController.taskDetails.value?.data?.effectiveStatus
                            .toString()
                            .toLowerCase() !=
                        "completed")
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Badge(
                          isLabelVisible: (taskController.taskDetails.value
                                          ?.data?.subtask?.length ??
                                      0) >
                                  0
                              ? true
                              : false,
                          label: Text(
                            '${taskController.taskDetails.value?.data?.subtask?.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: whiteColor,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: allSubTaskListBottomSheet(
                                      context,
                                      taskController.taskDetails.value?.data
                                              ?.subtask ??
                                          [],
                                      widget.taskId),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedTabColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Text(
                                  'Sub task',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
              body: DefaultTabController(
                length: 3,
                initialIndex: widget.initialIndex,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.blue,
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Attachments'),
                          Tab(text: 'Comments'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: TaskOverview(
                                  taskController.taskDetails.value?.data,
                                  widget.taskId,
                                  discussionController),
                            ),
                          ),
                          taskController.taskDetails.value?.data?.attachment !=
                                  null
                              ? SingleChildScrollView(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: TaskAttachment(taskController
                                        .taskDetails.value?.data?.attachment),
                                  ),
                                )
                              : Center(child: Text('No attachments')),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: TaskComments(
                              widget.taskId,
                              discussionController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget allSubTaskListBottomSheet(
    BuildContext context,
    List<Subtask> list,
    int? taskId,
  ) {
    return Container(
      height: 600.h,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(15.r))),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: subTaskBottomSheet(context,
                              taskController.taskDetails.value?.data?.id)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      border: Border.all(color: secondaryColor),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      child: Row(
                        children: [
                          Container(
                            height: 22.h,
                            width: 22.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11.r),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'Add sub task',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          list.isEmpty
              ? Center(
                  child: Text(
                    "No Subtask data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < list.length; i++)
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
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
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Sub Task ID : ${list[i].id ?? ''}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
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
                                              Radius.circular(10.r)),
                                          shadowColor: lightGreyColor,
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (String result) {
                                            switch (result) {
                                              case 'edit':
                                                for (var priorityData
                                                    in priorityController
                                                        .priorityList) {
                                                  if (priorityData.id
                                                          .toString() ==
                                                      list[i]
                                                          .priority
                                                          .toString()) {
                                                    priorityController
                                                        .selectedPriorityData
                                                        .value = priorityData;
                                                    break;
                                                  }
                                                }
                                                subataskController3.text =
                                                    list[i].title ?? "";
                                                startDateController3.text =
                                                    list[i].startDate ?? "";
                                                dueDateController3.text =
                                                    list[i].dueDate ?? "";
                                                dueTimeController3.text =
                                                    list[i].dueTime ?? "";

                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child:
                                                        editSubTaskBottomSheet(
                                                      context,
                                                      list[i].id,
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case 'delete':
                                                taskController
                                                    .deleteSubTask(list[i].id);
                                                break;
                                              case 'status':
                                                taskController.isProgressStatus
                                                    ?.value = false;
                                                taskController.isCompleteStatus
                                                    ?.value = false;
                                                changeStatusDialog(
                                                  context,
                                                  list[i].id,
                                                  list[i].effectiveStatus,
                                                  taskId,
                                                );
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<String>>[
                                            if (widget.assignedStatus ==
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
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            if (widget.assignedStatus ==
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
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            if (widget.assignedStatus ==
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
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '${list[i].title ?? ""}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    '${list[i].description ?? ""}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${list[i].priorityName ?? ""}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: list[i]
                                                          .priorityName
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "medium"
                                                  ? mediumColor
                                                  : list[i]
                                                              .priorityName
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "low"
                                                      ? secondaryTextColor
                                                      : blueColor),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            '${list[i].effectiveStatus.toString()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: list[i]
                                                          .effectiveStatus
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? redColor
                                                  : list[i]
                                                              .effectiveStatus
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'progress'
                                                      ? thirdPrimaryColor
                                                      : blueColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: Text(
                                                  '${list[i].taskDate} ${list[i].taskTime}')))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }

  final TextEditingController subTaskRemarkController = TextEditingController();
  Future<void> changeStatusDialog(
    BuildContext context,
    newTaskListId,
    newTaskListStatus,
    int? taskId,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 350.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Change Status',
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
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Container(
                                height: 25.h,
                                width: 25.w,
                                child: Checkbox(
                                  value: taskController.isProgressStatus?.value,
                                  onChanged: (value) {
                                    taskController.isCompleteStatus?.value =
                                        false;
                                    taskController.isProgressStatus?.value =
                                        value!;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Container(
                                height: 25.h,
                                width: 25.w,
                                child: Checkbox(
                                  value: taskController.isCompleteStatus?.value,
                                  onChanged: (value) {
                                    taskController.isProgressStatus?.value =
                                        false;
                                    taskController.isCompleteStatus?.value =
                                        value!;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Complete',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  InkWell(
                    onTap: () {
                      showAlertDialog(context);
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
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Add Attachment',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  TaskCustomTextField(
                    controller: subTaskRemarkController,
                    textCapitalization: TextCapitalization.none,
                    data: statusRemark,
                    hintText: statusRemark,
                    labelText: statusRemark,
                    index: 0,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () => CustomButton(
                      onPressed: () {
                        if (taskController.isProgressUpdating.value == false) {
                          if (taskController.isProgressStatus?.value == true ||
                              taskController.isCompleteStatus?.value == true) {
                            if (taskController.isProgressStatus?.value ==
                                true) {
                              taskController.taskIdFromDetails =
                                  widget.taskId ?? 0;
                              taskController.updateProgressTask(
                                newTaskListId,
                                subTaskRemarkController.text,
                                1,
                                from: 'details',
                              );
                            } else if (taskController.isCompleteStatus?.value ==
                                true) {
                              taskController.taskIdFromDetails =
                                  widget.taskId ?? 0;
                              taskController.updateProgressTask(newTaskListId,
                                  subTaskRemarkController.text, 2,
                                  from: 'details');
                            }
                          } else {
                            CustomToast()
                                .showCustomToast("Please select status");
                          }
                        }
                      },
                      text: taskController.isProgressUpdating.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  loading,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            takeAttachment(ImageSource.gallery);
                          },
                          child: Container(
                            height: 40.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/gallery-icon-removebg-preview.png',
                                  height: 20.h,
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            takeAttachment(ImageSource.camera);
                          },
                          child: Container(
                            height: 40.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final ImagePicker imagePicker = ImagePicker();
  Future<void> takeAttachment(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      Get.back();
      discussionController.isFilePicUploading.value = true;
      discussionController.pickedFile2.value = File(pickedImage.path);
      discussionController.profilePicPath2.value = pickedImage.path.toString();
      discussionController.isFilePicUploading.value = false;
    } catch (e) {
      discussionController.isFilePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      discussionController.isFilePicUploading.value = false;
    }
  }

  int selectedProjectId = 0;

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  TextEditingController subataskController = TextEditingController();
  TextEditingController startDateController2 = TextEditingController();
  TextEditingController dueDateController2 = TextEditingController();
  TextEditingController dueTimeController2 = TextEditingController();
  Widget subTaskBottomSheet(BuildContext context, id) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 350.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Subtask',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              TaskCustomTextField(
                controller: subataskController,
                textCapitalization: TextCapitalization.sentences,
                data: subTaskName,
                hintText: subTaskName,
                labelText: subTaskName,
                index: 0,
                focusedIndexNotifier: focusedIndexNotifier,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startDate,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomCalender(
                          hintText: dateFormate,
                          controller: startDateController2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dueDate,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomCalender(
                          hintText: dateFormate,
                          controller: dueDateController2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dueTime,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomTimer(
                          controller: dueTimeController2,
                          hintText: dueTime,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectPriority,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomDropdown<PriorityData>(
                          items: priorityController.priorityList,
                          itemLabel: (item) => item.priorityName ?? "",
                          onChanged: (value) {
                            priorityController.selectedPriorityData.value =
                                value;
                          },
                          hintText: selectPriority,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Obx(
                () => CustomButton(
                  onPressed: () {
                    if (taskController.isSubTaskAdding.value == false) {
                      taskController.addSubTask(
                        subataskController.text,
                        startDateController2.text,
                        dueDateController2.text,
                        dueTimeController2.text,
                        priorityController.selectedPriorityData.value?.id,
                        id,
                      );
                    }
                  },
                  text: taskController.isSubTaskAdding.value == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              loading,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor),
                            ),
                          ],
                        )
                      : Text(
                          create,
                          style: TextStyle(color: whiteColor),
                        ),
                  width: double.infinity,
                  color: primaryColor,
                  height: 45.h,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier2 = ValueNotifier<int?>(null);
  TextEditingController subataskController3 = TextEditingController();
  TextEditingController startDateController3 = TextEditingController();
  TextEditingController dueDateController3 = TextEditingController();
  TextEditingController dueTimeController3 = TextEditingController();
  Widget editSubTaskBottomSheet(BuildContext context, id) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 350.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit Subtask',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              TaskCustomTextField(
                controller: subataskController3,
                textCapitalization: TextCapitalization.sentences,
                data: subTaskName,
                hintText: subTaskName,
                labelText: subTaskName,
                index: 0,
                focusedIndexNotifier: focusedIndexNotifier2,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startDate,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomCalender(
                          hintText: dateFormate,
                          controller: startDateController3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dueDate,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomCalender(
                          hintText: dateFormate,
                          controller: dueDateController3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dueTime,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        CustomTimer(
                          controller: dueTimeController3,
                          hintText: dueTime,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 161.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectPriority,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton2<PriorityData>(
                              isExpanded: true,
                              hint: Text(
                                "Select Priority",
                                style: changeTextColor(
                                    rubikRegular, darkGreyColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              items: priorityController.priorityList
                                  .map(
                                    (PriorityData item) =>
                                        DropdownMenuItem<PriorityData>(
                                      value: item,
                                      child: Text(
                                        item.priorityName ?? '',
                                        style: changeTextColor(
                                            rubikRegular, Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value:
                                  priorityController.selectedPriorityData.value,
                              onChanged: (PriorityData? value) {
                                priorityController.selectedPriorityData.value =
                                    value;
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 45.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border:
                                      Border.all(color: lightSecondaryColor),
                                  color: lightSecondaryColor,
                                ),
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
                                width: 312.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: lightSecondaryColor,
                                    border:
                                        Border.all(color: lightSecondaryColor)),
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Obx(
                () => CustomButton(
                  onPressed: () {
                    if (taskController.isSubTaskEditing.value == false) {
                      taskController.editSubTask(
                          subataskController3.text,
                          startDateController3.text,
                          dueDateController3.text,
                          dueTimeController3.text,
                          priorityController.selectedPriorityData.value?.id,
                          id);
                    }
                  },
                  text: taskController.isSubTaskEditing.value == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              loading,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor),
                            ),
                          ],
                        )
                      : Text(
                          edit,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                  width: double.infinity,
                  color: primaryColor,
                  height: 45.h,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
