import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/activity_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/activity_type_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class NewActivity extends StatefulWidget {
  const NewActivity({super.key});

  @override
  State<NewActivity> createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {
  final ActivityController activityController = Get.put(ActivityController());
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController titleTextEditingController =
      TextEditingController();
  final TextEditingController dueDateTextEditingController =
      TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  final TextEditingController reminderTextEditingController =
      TextEditingController();
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController activityTypeTextEditingController =
      TextEditingController();

  @override
  void initState() {
    activityController.activityTypeListApi();
    taskController.responsiblePersonListApi('', "");
    super.initState();
  }

  @override
  void dispose() {
    activityController.selectedActivity.value = '';
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          newActivity,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => activityController.isActivityTypeLoading.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: rubikRegular,
                              ),
                              SizedBox(height: 5.h),
                              CustomTextField(
                                controller: titleTextEditingController,
                                textCapitalization: TextCapitalization.none,
                                hintText: title,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    activityType,
                                    style: rubikRegular,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => bottomSheet(),
                                      );
                                    },
                                    icon: Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 16.h,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              activityTypeGrid(
                                  activityController.activityTypeList),
                              SizedBox(height: 10.h),
                              CustomCalender(
                                hintText: dueDate,
                                controller: dueDateTextEditingController,
                              ),
                              SizedBox(height: 10.h),
                              CustomTimer(
                                hintText: "Select Time",
                                controller: timeTextEditingController,
                              ),
                              SizedBox(height: 10.h),
                              CustomTextField(
                                controller: reminderTextEditingController,
                                textCapitalization: TextCapitalization.none,
                                hintText: reminder,
                              ),
                              SizedBox(height: 10.h),
                              CustomDropdown<String>(
                                items: activityController.beforeDue,
                                itemLabel: (item) => item,
                                onChanged: (value) {
                                  dueDateTextEditingController.text = value!;
                                },
                                hintText: selectDueTime,
                              ),
                              SizedBox(height: 10.h),
                              CustomDropdown<ResponsiblePersonData>(
                                items: taskController.responsiblePersonList,
                                itemLabel: (item) => item.name ?? '',
                                onChanged: (value) {
                                  taskController.selectedResponsiblePersonData
                                      .value = value;
                                },
                                hintText: selectPerson,
                              ),
                              SizedBox(height: 10.h),
                              CustomTextField(
                                controller: descriptionTextEditingController,
                                textCapitalization: TextCapitalization.none,
                                hintText: description,
                                maxLine: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomButton(
                        onPressed: () {
                          if (activityController.isActivityAdding.value ==
                              false) {
                            if (activityController
                                .selectedActivity.value.isNotEmpty) {
                              activityController.addActivityApi(
                                titleTextEditingController.text,
                                dueDateTextEditingController.text,
                                timeTextEditingController.text,
                                reminderTextEditingController.text,
                                descriptionTextEditingController.text,
                                activityController.selectedOwner?.value,
                                taskController.selectedResponsiblePersonData
                                        .value?.id ??
                                    0,
                              );
                            } else {
                              CustomToast()
                                  .showCustomToast('Select activity type.');
                            }
                          }
                        },
                        text: Text(
                          submit,
                          style: TextStyle(color: whiteColor),
                        ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget activityTypeGrid(RxList<ActivityTypeData> activityTypeList) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: List.generate(
        activityTypeList.length,
        (index2) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                activityController.selectedActivity.value =
                    activityTypeList[index2].id.toString();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color: activityController.selectedActivity.value ==
                              activityTypeList[index2].id.toString()
                          ? whiteColor
                          : darkGreyColor),
                  color: activityController.selectedActivity.value ==
                          activityTypeList[index2].id.toString()
                      ? secondaryColor
                      : whiteColor,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Text(
                    '${activityTypeList[index2].name}',
                    style: changeTextColor(
                        rubikRegular,
                        activityController.selectedActivity.value ==
                                activityTypeList[index2].id.toString()
                            ? whiteColor
                            : darkGreyColor),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomSheet() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        width: double.infinity,
        height: 200.h,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    addActivityType,
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
                  children: [
                    CustomTextField(
                      controller: activityTypeTextEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      hintText: activityType,
                      keyboardType: TextInputType.emailAddress,
                      data: activityType,
                    ),
                    SizedBox(
                      height: 30.h,
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
                              activityController.addActivityTypeApi(
                                  activityTypeTextEditingController.text);
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
    );
  }
}
