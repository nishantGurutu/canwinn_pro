import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
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
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/priority_model.dart' show PriorityData;
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/add_contact.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';
import 'package:task_management/view/widgets/task_contact_list.dart'
    show TaskContactList;
import 'package:task_management/view/widgets/to_assign_user_list.dart';

class AddTask extends StatefulWidget {
  final RxList<PriorityData> priorityList;
  final RxList<CreatedByMe> allProjectDataList;
  final RxList<ResponsiblePersonData> responsiblePersonList;
  final int? id;
  final String? description;
  const AddTask(
    this.priorityList,
    this.allProjectDataList,
    this.responsiblePersonList,
    this.id,
    this.description, {
    super.key,
  });
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController taskController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selectedProjectId = 0;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final PriorityController priorityController = Get.find();
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();

  @override
  void initState() {
    remarkController.text = widget.description ?? "";
    apiCall();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    taskController.pickedFile.value = File("");
    taskController.profilePicPath.value = "";
    taskController.reviewerUserId.clear();
    taskController.toAssignedPersonCheckBox.clear();
    taskController.assignedUserId.clear();
    taskController.responsiblePersonSelectedCheckBox2.clear();
    taskController.addTaskContactList.clear();
  }

  var isLoading = false.obs;

  void apiCall() async {
    isLoading.value = true;
    await taskController.allProjectListApi(projectId: widget.id);
    priorityController.priorityApi(from: '');
    await profileController.departmentList(
      taskController.selectedAllProjectListData.value?.id ?? 0,
    );
    isLoading.value = false;
  }

  Future<void> takePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;
        if (filePath == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: File path is null')));
          return;
        }
        final File file = File(filePath);
        taskController.pickedFile.value = File(file.path);
        taskController.profilePicPath.value = file.path.toString();
        print(
          'selected file path from device is ${taskController.pickedFile.value}',
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No file selected.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      width: double.infinity,
      height: 700.h,
      child: Obx(
        () =>
            isLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SafeArea(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 680.h),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    createNewTask,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              TaskCustomTextField(
                                controller: taskNameController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                data: taskName,
                                hintText: taskName,
                                labelText: taskName,
                                index: 0,
                                focusedIndexNotifier: focusedIndexNotifier,
                              ),
                              SizedBox(height: 10.h),
                              TaskCustomTextField(
                                controller: remarkController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                data: enterRemark,
                                hintText: enterRemark,
                                labelText: enterRemark,
                                index: 1,
                                maxLine: 3,
                                focusedIndexNotifier: focusedIndexNotifier,
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectProject,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: Text(
                                      selectDepartment,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => DropdownButtonHideUnderline(
                                        child: DropdownButton2<CreatedByMe>(
                                          isExpanded: true,
                                          items:
                                              taskController.allProjectDataList
                                                  .map((CreatedByMe item) {
                                                    return DropdownMenuItem<
                                                      CreatedByMe
                                                    >(
                                                      value: item,
                                                      child: Text(
                                                        item.name ?? "",
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontFamily: 'Roboto',
                                                          color: darkGreyColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16.sp,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    );
                                                  })
                                                  .toList(),
                                          value:
                                              taskController
                                                  .selectedAllProjectListData
                                                  .value,
                                          onChanged: (CreatedByMe? value) {
                                            taskController
                                                .selectedAllProjectListData
                                                .value = value;
                                            print(
                                              "selected project id in add task ${taskController.selectedAllProjectListData.value?.id}",
                                            );
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 47.h,
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                              left: 14.w,
                                              right: 14.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                              color: whiteColor,
                                            ),
                                          ),
                                          hint: Text(
                                            'Select Project'.tr,
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
                                            iconSize: 14.sp,
                                            iconEnabledColor: lightGreyColor,
                                            iconDisabledColor: lightGreyColor,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200.h,
                                            width: 161.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: Radius.circular(40.r),
                                              thickness:
                                                  WidgetStateProperty.all<
                                                    double
                                                  >(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                    true,
                                                  ),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: 40.h,
                                            padding: EdgeInsets.only(
                                              left: 14.w,
                                              right: 14.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: Obx(
                                      () =>
                                          profileController
                                                      .isdepartmentListLoading
                                                      .value ==
                                                  true
                                              ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                              : Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(14.r),
                                                      ),
                                                  border: Border.all(
                                                    color: lightBorderColor,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 4.h,
                                                  ),
                                                  child: MultiDropdown<
                                                    DepartmentListData
                                                  >(
                                                    fieldDecoration: FieldDecoration(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                          ),
                                                      border:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    10.r,
                                                                  ),
                                                                ),
                                                          ),
                                                    ),
                                                    items:
                                                        profileController
                                                            .departmentDataList
                                                            .map(
                                                              (
                                                                item,
                                                              ) => DropdownItem<
                                                                DepartmentListData
                                                              >(
                                                                value: item,
                                                                label:
                                                                    item.name ??
                                                                    '',
                                                              ),
                                                            )
                                                            .toList(),
                                                    controller:
                                                        MultiSelectController<
                                                          DepartmentListData
                                                        >(),
                                                    enabled: true,
                                                    searchEnabled: true,
                                                    onSelectionChange: (
                                                      selectedItems,
                                                    ) async {
                                                      homeController
                                                          .selectedDepartMentListData2
                                                          .assignAll(
                                                            selectedItems,
                                                          );
                                                      await homeController
                                                          .responsiblePersonListApi2(
                                                            homeController
                                                                .selectedDepartMentListData2,
                                                          );
                                                    },
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
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
                                              child: AddContactIntask(),
                                            ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: chatColor,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          'Add Contact',
                                          style: changeTextColor(
                                            heading7,
                                            chatColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Obx(
                                    () =>
                                        taskController
                                                .addTaskContactList
                                                .isNotEmpty
                                            ? InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => TaskContactList(
                                                    taskController
                                                        .addTaskContactList,
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                width: 100.w,
                                                height: 30.h,
                                                child: Stack(
                                                  children: List.generate(
                                                    taskController
                                                                .addTaskContactList
                                                                .length >
                                                            3
                                                        ? 4
                                                        : taskController
                                                            .addTaskContactList
                                                            .length,
                                                    (index) {
                                                      if (index < 3) {
                                                        final contact =
                                                            taskController
                                                                .addTaskContactList[index];
                                                        final firstChar =
                                                            contact
                                                                    .name!
                                                                    .isNotEmpty
                                                                ? contact
                                                                    .name![0]
                                                                : '?';
                                                        final leftPosition =
                                                            index == 0
                                                                ? 0.0
                                                                : (index == 1
                                                                    ? 22.w
                                                                    : 44.w);
                                                        final bgColor =
                                                            index == 0
                                                                ? redColor
                                                                : index == 1
                                                                ? blueColor
                                                                : secondaryColor;
                                                        return Positioned(
                                                          left: leftPosition,
                                                          child: Container(
                                                            height: 30.h,
                                                            width: 30.w,
                                                            decoration: BoxDecoration(
                                                              color: bgColor,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      15.r,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                firstChar,
                                                                style:
                                                                    changeTextColor(
                                                                      heading9,
                                                                      whiteColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        final extraCount =
                                                            taskController
                                                                .addTaskContactList
                                                                .length -
                                                            3;
                                                        return Positioned(
                                                          left: 65.w,
                                                          child: Container(
                                                            height: 30.h,
                                                            width: 30.w,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  primaryButtonColor,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      15.r,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '+$extraCount',
                                                                style:
                                                                    changeTextColor(
                                                                      heading9,
                                                                      whiteColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                            : SizedBox(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            takePhoto();
                                          },
                                          child: Container(
                                            width: 115.w,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 11.2.h,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Attachment",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  Image.asset(
                                                    'assets/images/png/attachment_rounded.png',
                                                    color: whiteColor,
                                                    height: 16.sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Badge(
                                          backgroundColor:
                                              secondaryPrimaryColor,
                                          isLabelVisible:
                                              taskController
                                                      .assignedUserId
                                                      .isEmpty
                                                  ? false
                                                  : true,
                                          label: Text(
                                            "${taskController.assignedUserId.length}",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (context) => Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(
                                                              context,
                                                            ).viewInsets.bottom,
                                                      ),
                                                      child: ToAssignUserList(
                                                        '',
                                                      ),
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                color: secondaryColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 11.2.h,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Assigned To",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Badge(
                                          backgroundColor:
                                              secondaryPrimaryColor,
                                          isLabelVisible:
                                              taskController
                                                      .reviewerUserId
                                                      .isEmpty
                                                  ? false
                                                  : true,
                                          label: Text(
                                            "${taskController.reviewerUserId.length ?? ""}",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
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
                                                      child:
                                                          ResponsiblePersonList(
                                                            'reviewer',
                                                            '',
                                                          ),
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              width: 95.w,
                                              decoration: BoxDecoration(
                                                color: blueColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(7.r),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 11.2.h,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Reviewer",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
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
                                              File(
                                                taskController
                                                    .profilePicPath
                                                    .value,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 60.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: lightGreyColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.r),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.file(
                                                File(
                                                  taskController
                                                      .profilePicPath
                                                      .value,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Center(
                                                    child: Text(
                                                      "Invalid Image",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
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
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${startDate} *",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        CustomCalender(
                                          hintText: dateFormate,
                                          controller: startDateController,
                                          from: 'startDate',
                                          otherController: dueDateController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 161.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${dueDate} *",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3.w),
                                        CustomCalender(
                                          hintText: dateFormate,
                                          controller: dueDateController,
                                          from: 'dueDate',
                                          otherController: startDateController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${dueTime} *",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: Text(
                                      "${selectPriority} *",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50.h,
                                      child: CustomTimer(
                                        hintText: "",
                                        controller: dueTimeController,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: SizedBox(
                                      child: CustomDropdown<PriorityData>(
                                        items: priorityController.priorityList,
                                        itemLabel:
                                            (item) => item.priorityName ?? "",
                                        selectedValue: null,
                                        onChanged: (value) {
                                          priorityController
                                              .selectedPriorityData
                                              .value = value;
                                        },
                                        hintText: selectPriority,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 160.w,
                                    child: CustomTextField(
                                      controller: timeTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      hintText: alarmReminder,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icon(Icons.lock_clock),
                                      data: alarmReminder,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^[0-9]*$'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160.w,
                                    height: 44.h,
                                    child: Obx(
                                      () => DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          items:
                                              homeController.alarmTypeList.map((
                                                String item,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontFamily: 'Roboto',
                                                      color: darkGreyColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.sp,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                          value:
                                              homeController
                                                      .selectedAlarmTypeTime!
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : homeController
                                                      .selectedAlarmTypeTime
                                                      ?.value,
                                          onChanged: (String? value) {
                                            homeController
                                                .selectedAlarmTypeTime
                                                ?.value = value ?? '';
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50.h,
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                              left: 14.w,
                                              right: 14.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                              color: whiteColor,
                                            ),
                                          ),
                                          hint: Text(
                                            'Alarm type',
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto',
                                              color: darkGreyColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Image.asset(
                                              'assets/images/png/Vector 3.png',
                                              color: secondaryColor,
                                              height: 8.h,
                                            ),
                                            iconSize: 14.sp,
                                            iconEnabledColor: lightGreyColor,
                                            iconDisabledColor: lightGreyColor,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200.h,
                                            width: 160.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                color: lightBorderColor,
                                              ),
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                                  WidgetStateProperty.all<
                                                    double
                                                  >(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                    true,
                                                  ),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 47.h,
                                child: Obx(
                                  () => DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items:
                                          homeController.timeList.map((
                                            String item,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: 'Roboto',
                                                  color: darkGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                      value:
                                          homeController
                                                  .selectedTime!
                                                  .value
                                                  .isEmpty
                                              ? null
                                              : homeController
                                                  .selectedTime
                                                  ?.value,
                                      onChanged: (String? value) {
                                        homeController.selectedTime?.value =
                                            value ?? '';
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50.h,
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 14.w,
                                          right: 14.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          border: Border.all(
                                            color: lightBorderColor,
                                          ),
                                          color: whiteColor,
                                        ),
                                      ),
                                      hint: Text(
                                        'Select type',
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
                                        iconSize: 14.sp,
                                        iconEnabledColor: lightGreyColor,
                                        iconDisabledColor: lightGreyColor,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200.h,
                                        width: 330.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          color: whiteColor,
                                          border: Border.all(
                                            color: lightBorderColor,
                                          ),
                                        ),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                6,
                                              ),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                true,
                                              ),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Obx(
                                () => CustomButton(
                                  onPressed: () {
                                    print(
                                      '3te6637 e36re63 7e63fr655 ${homeController.selectedDepartMentListData2.length}',
                                    );
                                    if (taskController.isTaskAdding.value ==
                                        false) {
                                      if (taskController
                                          .assignedUserId
                                          .isNotEmpty) {
                                        if (taskController
                                            .reviewerUserId
                                            .isNotEmpty) {
                                          if (priorityController
                                                      .selectedPriorityData
                                                      .value !=
                                                  null &&
                                              dueTimeController
                                                  .text
                                                  .isNotEmpty &&
                                              dueDateController
                                                  .text
                                                  .isNotEmpty &&
                                              startDateController
                                                  .text
                                                  .isNotEmpty) {
                                            if (homeController
                                                .selectedDepartMentListData2
                                                .isNotEmpty) {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                taskController.addTask(
                                                  taskNameController.text,
                                                  remarkController.text,
                                                  taskController
                                                          .selectedAllProjectListData
                                                          .value
                                                          ?.id ??
                                                      0,
                                                  startDateController.text,
                                                  dueDateController.text,
                                                  dueTimeController.text,
                                                  priorityController
                                                      .selectedPriorityData
                                                      .value
                                                      ?.id,
                                                  'bottom',
                                                  timeTextEditingController
                                                      .text,
                                                  homeController
                                                          .selectedTime
                                                          ?.value ??
                                                      '',
                                                  homeController
                                                      .selectedDepartMentListData2,
                                                  homeController
                                                          .selectedAlarmTypeTime
                                                          ?.value ??
                                                      '',
                                                );
                                              }
                                            } else {
                                              CustomToast().showCustomToast(
                                                "Please select department.",
                                              );
                                            }
                                          } else {
                                            CustomToast().showCustomToast(
                                              "Please select * value.",
                                            );
                                          }
                                        } else {
                                          CustomToast().showCustomToast(
                                            "Please select reviewer person.",
                                          );
                                        }
                                      } else {
                                        CustomToast().showCustomToast(
                                          "Please select assign person.",
                                        );
                                      }
                                    }
                                  },
                                  text:
                                      taskController.isTaskAdding.value == true
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
                                            create,
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
                              SizedBox(height: 6.h),
                            ],
                          ),
                        ),
                      ),
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
        MaterialPageRoute(builder: (context) => ImageScreen(file: file)),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFScreen(file: file)),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unsupported file type.')));
    }
  }
}
