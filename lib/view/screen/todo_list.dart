import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/todo_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/tag_list_model.dart';
import 'package:task_management/model/todo_list_model.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class ToDoList extends StatefulWidget {
  final String? navigationType;
  const ToDoList(this.navigationType, {super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TodoController todoController = Get.put(TodoController());
  final PriorityController priorityController = Get.put(PriorityController());

  final TextEditingController editTitleTextEditingController =
      TextEditingController();
  final TextEditingController editDescriptionTextEditingController =
      TextEditingController();

  @override
  void initState() {
    todoController.todoListApi('all');
    todoController.tagListApi();
    priorityController.priorityApi();
    super.initState();
  }

  @override
  void dispose() {
    todoController.selectedSortData = null;
    super.dispose();
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

  String formatDateTime(String apiDate) {
    try {
      DateTime dateTime = DateTime.parse(apiDate).toLocal();
      return DateFormat('d MMM y h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (widget.navigationType == 'notification') {
                Get.offAll(() => SplashScreen());
              } else {
                Get.back();
              }
            },
            icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
          ),
          title: Text(
            todo,
            style: TextStyle(
                color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () => todoController.isTodoListLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: double.infinity,
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo,
                                    style: changeTextColor(
                                        robotoBlack, darkGreyColor),
                                  ),
                                  Text(
                                    manageYourTask,
                                    style: changeTextColor(
                                        rubikRegular, subTextColor),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: Checkbox(
                                            value: todoController
                                                .isMarkCompleted.value,
                                            onChanged: (value) {
                                              todoController.isMarkCompleted
                                                  .value = value!;
                                              for (int i = 0;
                                                  i <
                                                      todoController
                                                          .todoListData.length;
                                                  i++) {
                                                todoController
                                                        .completedTodoCheckList[i] =
                                                    todoController
                                                        .todoListData[i].id!;
                                              }
                                              if (todoController
                                                      .isMarkCompleted.value ==
                                                  true) {
                                                todoController.completeTodoApi(
                                                    todoController
                                                        .completedTodoCheckList,
                                                    1);
                                              } else {
                                                todoController.completeTodoApi(
                                                    todoController
                                                        .completedTodoCheckList,
                                                    0);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        markAllAsComplete,
                                        style: changeTextColor(
                                            rubikRegular, subTextColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 130.w,
                              height: 40.h,
                              child: CustomDropdown<String>(
                                items: todoController.sortList,
                                itemLabel: (item) => item,
                                onChanged: (value) {
                                  todoController.todoListApi(value);
                                },
                                hintText: sortBy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: InkWell(
                          onTap: () {
                            dueDateController.clear();
                            dueTimeController.clear();
                            todoController.titleTextEditingController.clear();
                            todoController.descriptionTextEditingController
                                .clear();
                            showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => addTodoBotomsheet(),
                            );
                          },
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 20.h,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    addTodo,
                                    style: changeTextColor(
                                        rubikRegular, whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      todoListWidget(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget editBottomSheet(
      String? title, int? priority, int? tags, String? description, int? id) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        width: double.infinity,
        height: 540.h,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editTodo,
                    style: changeTextColor(rubikBlack, darkGreyColor),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: editTitleTextEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      hintText: todoTitle,
                      keyboardType: TextInputType.emailAddress,
                      data: todoTitle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 160.w,
                          child: DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton2<TagData>(
                                isExpanded: true,
                                hint: Text(
                                  "Select Tag",
                                  style: changeTextColor(
                                      rubikRegular, darkGreyColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: todoController.tagList
                                    .map(
                                      (TagData item) =>
                                          DropdownMenuItem<TagData>(
                                        value: item,
                                        child: Text(
                                          item.tagName ?? '',
                                          style: changeTextColor(
                                              rubikRegular, Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: todoController.selectedTagData.value,
                                onChanged: (TagData? value) {},
                                buttonStyleData: ButtonStyleData(
                                  height: 45.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: lightBorderColor),
                                    color: whiteColor,
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
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      color: whiteColor,
                                      border:
                                          Border.all(color: lightBorderColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40.h,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160.w,
                          child: DropdownButtonHideUnderline(
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
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: lightBorderColor),
                                    color: whiteColor,
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
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      color: whiteColor,
                                      border:
                                          Border.all(color: lightBorderColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40.h,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextField(
                      controller: editDescriptionTextEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      hintText: description,
                      keyboardType: TextInputType.emailAddress,
                      maxLine: 3,
                      data: description,
                    ),
                    SizedBox(
                      height: 10.h,
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
                                alertDate,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 3.w,
                              ),
                              CustomCalender(
                                hintText: dateFormate,
                                controller: dueDateController,
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
                                alertTime,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 3.w,
                              ),
                              CustomTimer(
                                hintText: alertTime,
                                controller: dueTimeController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 160.w,
                          child: CustomTextField(
                            controller: editTimeTextEditingController,
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
                                items:
                                    todoController.timeList.map((String item) {
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
                                value:
                                    todoController.selectedTime!.value.isEmpty
                                        ? null
                                        : todoController.selectedTime?.value,
                                onChanged: (String? value) {
                                  todoController.selectedTime?.value =
                                      value ?? '';
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50.h,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: lightBorderColor),
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
                                      borderRadius: BorderRadius.circular(14.r),
                                      color: whiteColor,
                                      border:
                                          Border.all(color: lightBorderColor)),
                                  offset: const Offset(0, 0),
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InkWell(
                      onTap: () {
                        selectAttachmentDialog(context);
                      },
                      child: Container(
                        height: 35.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(color: lightBorderColor),
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 35.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: borderColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cancel,
                                style:
                                    changeTextColor(rubikRegular, whiteColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              todoController.editTodoApi(
                                editTitleTextEditingController.text,
                                todoController.selectedTagData.value?.id,
                                priorityController
                                    .selectedPriorityData.value?.id,
                                editDescriptionTextEditingController.text,
                                id,
                                dueDateController.text,
                                dueTimeController.text,
                                editTimeTextEditingController.text,
                                todoController.selectedTime?.value,
                              );
                            }
                          },
                          child: Container(
                            height: 35.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                edit,
                                style:
                                    changeTextColor(rubikRegular, whiteColor),
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
          ],
        ),
      ),
    );
  }

  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  Widget addTodoBotomsheet() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        width: double.infinity,
        height: 540.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      addTodo,
                      style: changeTextColor(rubikBlack, darkGreyColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: todoController.titleTextEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        hintText: todoTitle,
                        keyboardType: TextInputType.emailAddress,
                        data: todoTitle,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: CustomDropdown<TagData>(
                              items: todoController.tagList,
                              itemLabel: (item) => item.tagName ?? '',
                              onChanged: (value) {
                                todoController.selectedTagData.value = value;
                              },
                              hintText: selectTag,
                            ),
                          ),
                          SizedBox(
                            width: 160.w,
                            child: CustomDropdown<PriorityData>(
                              items: priorityController.priorityList,
                              itemLabel: (item) => item.priorityName ?? '',
                              onChanged: (value) {
                                priorityController.selectedPriorityData.value =
                                    value;
                              },
                              hintText: selectPriority,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        controller:
                            todoController.descriptionTextEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        hintText: description,
                        keyboardType: TextInputType.emailAddress,
                        maxLine: 3,
                        data: description,
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
                                  alertDate,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 3.w,
                                ),
                                CustomCalender(
                                  hintText: dateFormate,
                                  controller: dueDateController,
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
                                  alertTime,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 3.w,
                                ),
                                CustomTimer(
                                  hintText: alertTime,
                                  controller: dueTimeController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'Before Due',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: CustomTextField(
                              controller:
                                  todoController.timeTextEditingController,
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
                                  items: todoController.timeList
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
                                  value:
                                      todoController.selectedTime!.value.isEmpty
                                          ? null
                                          : todoController.selectedTime?.value,
                                  onChanged: (String? value) {
                                    todoController.selectedTime?.value =
                                        value ?? '';
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      border:
                                          Border.all(color: lightBorderColor),
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
                                    maxHeight: 200.h,
                                    width: 160.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        color: whiteColor,
                                        border: Border.all(
                                            color: lightBorderColor)),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 3.h),
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
                      InkWell(
                        onTap: () {
                          selectAttachmentDialog(context);
                        },
                        child: Container(
                          height: 35.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: lightBorderColor),
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
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 35.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: borderColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cancel,
                                  style:
                                      changeTextColor(rubikRegular, whiteColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          InkWell(
                            onTap: () {
                              if (todoController.isTodoAdding.value == false) {
                                if (_formKey.currentState!.validate()) {
                                  if (todoController.isTodoAdding.value ==
                                      false) {
                                    if ((todoController.selectedTime?.value ??
                                            "")
                                        .isNotEmpty) {
                                      todoController.addTodoApi(
                                        todoController
                                            .titleTextEditingController.text,
                                        todoController
                                            .selectedTagData.value?.id,
                                        priorityController
                                            .selectedPriorityData.value?.id,
                                        todoController
                                            .descriptionTextEditingController
                                            .text,
                                        dueTimeController.text,
                                        dueDateController.text,
                                        todoController
                                            .timeTextEditingController.text,
                                        todoController.selectedTime?.value ??
                                            "",
                                      );
                                    } else {
                                      CustomToast().showCustomToast(
                                          "Please select reminder type");
                                    }
                                  }
                                }
                              }
                            },
                            child: Container(
                              height: 35.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  submit,
                                  style:
                                      changeTextColor(rubikRegular, whiteColor),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectAttachmentDialog(
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
            height: 130.h,
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
      },
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takeAttachment(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      todoController.isFilePicUploading.value = true;
      todoController.pickedFile.value = File(pickedImage.path);
      todoController.profilePicPath.value = pickedImage.path.toString();
      todoController.isFilePicUploading.value = false;
      Get.back();
    } catch (e) {
      todoController.isFilePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      todoController.isFilePicUploading.value = false;
    }
  }

  final TextEditingController editTimeTextEditingController =
      TextEditingController();
  Widget todoListWidget() {
    return Obx(
      () => priorityController.isPriorityLoading.value == true &&
              todoController.isTodoListLoading.value == true &&
              todoController.isTagLoading.value == true
          ? Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : todoController.todoListData.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(noData),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: todoController.todoListData.length,
                    itemBuilder: (context, index) {
                      String priorityName = '';
                      if (todoController.todoListData[index].priority != null) {
                        final priorityId1 =
                            todoController.todoListData[index].priority;
                        final priority1 =
                            priorityController.priorityList.firstWhere(
                          (priority1) => priority1.id == priorityId1,
                        );
                        priorityName = priority1.priorityName ?? 'Unknown';
                      }
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: viewTodo(context,
                                      todoController.todoListData[index]),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
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
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 10.h, bottom: 10.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Obx(
                                          () => SizedBox(
                                            height: 20.h,
                                            width: 20.w,
                                            child: Checkbox(
                                              value: todoController
                                                  .todoListCheckbox[index],
                                              onChanged: (value) {
                                                todoController.todoListCheckbox[
                                                    index] = value!;

                                                todoController
                                                    .completedTodoCheckList
                                                    .add(todoController
                                                            .todoListData[index]
                                                            .id ??
                                                        0);
                                                if (todoController
                                                            .todoListCheckbox[
                                                        index] ==
                                                    true) {
                                                  todoController.completeTodoApi(
                                                      todoController
                                                          .completedTodoCheckList,
                                                      1);
                                                } else {
                                                  todoController.completeTodoApi(
                                                      todoController
                                                          .completedTodoCheckList,
                                                      0);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 263.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${todoController.todoListData[index].title ?? ''}",
                                              style: changeTextColor(
                                                  rubikBlack, darkGreyColor),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              "${todoController.todoListData[index].description ?? ""}",
                                              style: changeTextColor(
                                                  rubikRegular, subTextColor),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 70.w,
                                                  height: 30.h,
                                                  decoration: BoxDecoration(
                                                    color: priorityName
                                                                .toLowerCase() ==
                                                            "low"
                                                        ? Color(0xff0086FF)
                                                        : priorityName
                                                                    .toLowerCase() ==
                                                                "medium"
                                                            ? Color(0xffFF8700)
                                                            : Color(0xffFF0005),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.r),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "$priorityName",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${todoController.todoListData[index].alertDate ?? ""} ${todoController.todoListData[index].alertTime ?? ""}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 30.w,
                                        child: Center(
                                          child: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  onTap: () {
                                                    editTitleTextEditingController
                                                            .text =
                                                        todoController
                                                            .todoListData[index]
                                                            .title
                                                            .toString();
                                                    editDescriptionTextEditingController
                                                            .text =
                                                        todoController
                                                            .todoListData[index]
                                                            .description
                                                            .toString();
                                                    dueDateController.clear();
                                                    dueTimeController.clear();
                                                    for (var tagid
                                                        in todoController
                                                            .tagList) {
                                                      if (todoController
                                                              .todoListData[
                                                                  index]
                                                              .tags
                                                              .toString() ==
                                                          tagid.id.toString()) {
                                                        todoController
                                                            .selectedTagData
                                                            .value = tagid;

                                                        break;
                                                      }
                                                    }
                                                    for (var priorityid
                                                        in priorityController
                                                            .priorityList) {
                                                      if (todoController
                                                              .todoListData[
                                                                  index]
                                                              .priority
                                                              .toString() ==
                                                          priorityid.id
                                                              .toString()) {
                                                        priorityController
                                                            .selectedPriorityData
                                                            .value = priorityid;

                                                        break;
                                                      }
                                                    }
                                                    dueDateController
                                                        .text = todoController
                                                            .todoListData[index]
                                                            .alertDate ??
                                                        "";
                                                    dueTimeController
                                                        .text = todoController
                                                            .todoListData[index]
                                                            .alertTime ??
                                                        "";
                                                    editTimeTextEditingController
                                                        .text = (todoController
                                                                .todoListData[
                                                                    index]
                                                                .reminder ??
                                                            "")
                                                        .substring(0, 1);
                                                    todoController.selectedTime
                                                        ?.value = (todoController
                                                                .todoListData[
                                                                    index]
                                                                .reminder ??
                                                            "")
                                                        .substring(4);
                                                    showModalBottomSheet(
                                                      isDismissible: true,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          editBottomSheet(
                                                        todoController
                                                            .todoListData[index]
                                                            .title,
                                                        todoController
                                                            .todoListData[index]
                                                            .priority,
                                                        todoController
                                                            .todoListData[index]
                                                            .tags,
                                                        todoController
                                                            .todoListData[index]
                                                            .description,
                                                        todoController
                                                            .todoListData[index]
                                                            .id,
                                                      ),
                                                    );
                                                  },
                                                  child: Text(edit),
                                                ),
                                                PopupMenuItem(
                                                  onTap: () {
                                                    if (todoController
                                                            .isTodoDeleting
                                                            .value ==
                                                        false) {
                                                      todoController
                                                          .deleteTodoApi(
                                                              todoController
                                                                  .todoListData[
                                                                      index]
                                                                  .id);
                                                    }
                                                  },
                                                  child: Text(delete),
                                                ),
                                              ];
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget viewTodo(
    BuildContext context,
    TodoData todoListData,
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          width: double.infinity,
          height: 200.h,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "${todoListData.title ?? ""}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    width: 400,
                    child: Text(
                      "${todoListData.description ?? ""}",
                      style: changeTextColor(rubikRegular, subTextColor),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "${formatDateTime(todoListData.createdAt ?? "")}",
                    style: changeTextColor(rubikMedium, subTextColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 10.w,
            top: 5.h,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.close,
              ),
            ))
      ],
    );
  }
}
