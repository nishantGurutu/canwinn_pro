import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/costom_select_attachment.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';
import 'package:task_management/view/widgets/to_assign_user_list.dart';

class EditTask extends StatefulWidget {
  final RxList<PriorityData> priorityList;
  final RxList<CreatedByMe> allProjectDataList;
  final RxList<ResponsiblePersonData> responsiblePersonList;
  final dynamic newTaskListId;
  final TextEditingController taskNameController3;
  final TextEditingController remarkController3;
  final TextEditingController startDateController3;
  final TextEditingController dueDateController3;
  final TextEditingController dueTimeController3;
  final dynamic assignedTo;
  const EditTask(
      this.priorityList,
      this.allProjectDataList,
      this.responsiblePersonList,
      this.newTaskListId,
      this.taskNameController3,
      this.remarkController3,
      this.startDateController3,
      this.dueDateController3,
      this.dueTimeController3,
      this.assignedTo,
      {super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TaskController taskController = Get.find();
  final PriorityController priorityController = Get.find();
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier2 = ValueNotifier<int?>(null);
  final TextEditingController timeTextEditingController =
      TextEditingController();
  RxList<String> assignedId = <String>[].obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    taskController.assignedUserId.clear();
    taskController.toAssignedPersonCheckBox.clear();
    super.dispose();
    taskController.reviewerUserId.clear();
    taskController.responsiblePersonSelectedCheckBox2.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 620.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      updateTask,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                TaskCustomTextField(
                  controller: widget.taskNameController3,
                  textCapitalization: TextCapitalization.sentences,
                  data: taskName,
                  hintText: taskName,
                  labelText: taskName,
                  index: 0,
                  focusedIndexNotifier: focusedIndexNotifier2,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TaskCustomTextField(
                  controller: widget.remarkController3,
                  textCapitalization: TextCapitalization.sentences,
                  data: enterRemark,
                  hintText: enterRemark,
                  labelText: enterRemark,
                  index: 1,
                  maxLine: 3,
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
                            selectProject,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton2<CreatedByMe>(
                                isExpanded: true,
                                hint: Text(
                                  selectProject,
                                  style: changeTextColor(
                                      rubikRegular, darkGreyColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: projectController.allProjectDataList
                                    .map(
                                      (CreatedByMe item) =>
                                          DropdownMenuItem<CreatedByMe>(
                                        value: item,
                                        child: Text(
                                          item.name ?? '',
                                          style: changeTextColor(
                                              rubikRegular, Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: projectController
                                    .selectedAllProjectListData.value,
                                onChanged: (CreatedByMe? value) {
                                  projectController
                                      .selectedAllProjectListData.value = value;
                                  profileController.departmentList(
                                      projectController
                                          .selectedAllProjectListData
                                          .value
                                          ?.id);
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
                                      border: Border.all(
                                          color: lightSecondaryColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
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
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectDepartment,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          DepartmentList(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              AttachmentClass()
                                  .takeAttachment(ImageSource.gallery);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Attachment",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Image.asset(
                                      'assets/images/png/attachment_rounded.png',
                                      color: whiteColor,
                                      height: 20.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Badge(
                            backgroundColor: secondaryPrimaryColor,
                            isLabelVisible:
                                taskController.assignedUserId.isEmpty
                                    ? false
                                    : true,
                            label: Text(
                              "${taskController.assignedUserId.length}",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ToAssignUserList(widget.assignedTo),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.r)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 17.w, vertical: 11.2.h),
                                  child: Text(
                                    "Assigned To",
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Badge(
                            backgroundColor: secondaryPrimaryColor,
                            isLabelVisible:
                                taskController.reviewerUserId.isEmpty
                                    ? false
                                    : true,
                            label: Text(
                              "${taskController.reviewerUserId.length}",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            child: InkWell(
                              onTap: () {
                                // taskController.reviewerUserId.clear();
                                // taskController
                                //     .responsiblePersonSelectedCheckBox2
                                //     .clear();
                                for (var person
                                    in widget.responsiblePersonList) {
                                  taskController
                                          .responsiblePersonSelectedCheckBox2[
                                      person.id] = false;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ResponsiblePersonList('reviewer',
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.r)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 11.2.h),
                                  child: Text(
                                    "Reviewer",
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      taskController.profilePicPath.value.isEmpty
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                openFile(
                                    File(taskController.profilePicPath.value));
                              },
                              child: Container(
                                height: 40.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: lightGreyColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(taskController.profilePicPath.value),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          "Invalid Image",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
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
                            controller: widget.startDateController3,
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
                            controller: widget.dueDateController3,
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
                            hintText: timeFormate,
                            controller: widget.dueTimeController3,
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
                                  selectPriority,
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
                                value: priorityController
                                    .selectedPriorityData.value,
                                onChanged: (PriorityData? value) {
                                  priorityController
                                      .selectedPriorityData.value = value;
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
                                      border: Border.all(
                                          color: lightSecondaryColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: CustomTextField(
                        controller: timeTextEditingController,
                        textCapitalization: TextCapitalization.none,
                        hintText: alarmReminder,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.lock_clock),
                        data: alarmReminder,
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: homeController.timeList.map((String item) {
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
                            value: homeController.selectedTime!.value.isEmpty
                                ? null
                                : homeController.selectedTime?.value,
                            onChanged: (String? value) {
                              homeController.selectedTime?.value = value ?? '';
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: lightSecondaryColor),
                                color: lightSecondaryColor,
                              ),
                            ),
                            hint: Text(
                              'Select type',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
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
                              maxHeight: 200,
                              width: 330,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: lightSecondaryColor,
                                  border:
                                      Border.all(color: lightSecondaryColor)),
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
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      if (taskController.isTaskAdding.value == false) {
                        if (_formKey2.currentState!.validate()) {
                          taskController.editTask(
                            widget.taskNameController3.text,
                            widget.remarkController3.text,
                            projectController
                                .selectedAllProjectListData.value?.id,
                            profileController
                                .selectedDepartMentListData.value?.id,
                            taskController.assignedUserId,
                            taskController.reviewerUserId,
                            widget.startDateController3.text,
                            widget.dueDateController3.text,
                            widget.dueTimeController3.text,
                            priorityController.selectedPriorityData.value?.id,
                            widget.newTaskListId,
                            timeTextEditingController.text,
                            homeController.selectedTime?.value ?? '',
                          );
                        }
                      }
                    },
                    text: taskController.isTaskEditing.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: whiteColor),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: whiteColor),
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
      ),
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
}
