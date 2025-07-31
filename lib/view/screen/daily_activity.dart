import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/image_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/text_constant.dart';
import '../../controller/profile_controller.dart';
import '../../custom_widget/button_widget.dart';
import '../../custom_widget/task_text_field.dart';
import '../widgets/custom_timer.dart';

class DailyActivity extends StatefulWidget {
  const DailyActivity({super.key});

  @override
  State<DailyActivity> createState() => _DailyActivityState();
}

class _DailyActivityState extends State<DailyActivity> {
  final ProfileController profileController = Get.find();
  @override
  void initState() {
    super.initState();
    profileController.dailyTaskList(context, '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(backArrowIcon),
        ),
        title: Text(
          dailyActivity,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: addTaskBottomSheet(context),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Obx(
          () => profileController.isDailyTaskLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : profileController.dailyTaskDataList.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(noDailyTaskIcon, height: 200.h),
                        Text(
                          "No task available",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: lightTextColor),
                        )
                      ],
                    ))
                  : Container(
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
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  profileController.dailyTaskDataList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 5.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 245.w,
                                                // color: greenColor,
                                                child: Text(
                                                  "${index + 1}. ${profileController.dailyTaskDataList[index].taskName}",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                "${profileController.dailyTaskDataList[index].taskTime}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: lightTextColor),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              titleTextController2.text =
                                                  "${profileController.dailyTaskDataList[index].taskName}";
                                              taskTimeTextController2.text =
                                                  "${profileController.dailyTaskDataList[index].taskTime}";
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) => Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: editTaskBottomSheet(
                                                      context,
                                                      taskId: profileController
                                                          .dailyTaskDataList[
                                                              index]
                                                          .id
                                                          .toString()),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 28.h,
                                              width: 28.w,
                                              decoration: BoxDecoration(
                                                  color: deepLightGreenColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.r)),
                                              child: Padding(
                                                padding: EdgeInsets.all(4.sp),
                                                child:
                                                    SvgPicture.asset(editIcon),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          InkWell(
                                            onTap: () {
                                              profileController.deleteDailyTask(
                                                  profileController
                                                          .dailyTaskDataList[
                                                              index]
                                                          .id ??
                                                      0,
                                                  context);
                                            },
                                            child: Container(
                                              height: 28.h,
                                              width: 28.w,
                                              decoration: BoxDecoration(
                                                  color: deepLightRedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.r)),
                                              child: Padding(
                                                padding: EdgeInsets.all(4.sp),
                                                child: SvgPicture.asset(
                                                    deleteIcon),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: backgroundColor,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController taskTimeTextController = TextEditingController();
  final TextEditingController titleTextController2 = TextEditingController();
  final TextEditingController taskTimeTextController2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  Widget addTaskBottomSheet(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 300.h,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15.h,
              children: [
                SizedBox(
                  height: 0.h,
                ),
                Text(
                  'Add Daily Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                TaskCustomTextField(
                  controller: titleTextController,
                  textCapitalization: TextCapitalization.sentences,
                  data: "Task Name",
                  hintText: "Task Name",
                  labelText: 'Task Name',
                  index: 0,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                CustomTimer(
                  hintText: timeFormate,
                  controller: taskTimeTextController,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (profileController.isDailyTaskAdding.value ==
                            false) {
                          profileController.addDailyTask(
                              titleTextController.text,
                              context,
                              taskTimeTextController.text);
                          titleTextController.clear();
                          taskTimeTextController.clear();
                        }
                      }
                    },
                    text: profileController.isDailyTaskAdding.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                loading,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editTaskBottomSheet(BuildContext context, {required String taskId}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 290.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15.h,
            children: [
              Text(
                'Edit Daily Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              TaskCustomTextField(
                controller: titleTextController2,
                textCapitalization: TextCapitalization.sentences,
                data: "Task Name",
                hintText: "Task Name",
                labelText: 'Task Name',
                index: 0,
                focusedIndexNotifier: focusedIndexNotifier,
              ),
              CustomTimer(
                hintText: timeFormate,
                controller: taskTimeTextController2,
              ),
              SizedBox(
                height: 15.h,
              ),
              Obx(
                () => CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (profileController.isDailyTaskEditing.value == false) {
                        profileController.editDailyTask(
                            taskId,
                            titleTextController2.text,
                            taskTimeTextController2.text,
                            context);
                      }
                    }
                  },
                  text: profileController.isDailyTaskEditing.value == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              loading,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor),
                            )
                          ],
                        )
                      : Text(
                          save,
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
}
