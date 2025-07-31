import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/daily_task_list_model.dart';
import 'package:task_management/service/user_profile_service.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class MyDailyTask extends StatelessWidget {
  final VoidCallback onTaskAdded;
  final RxList<DailyTasks> dailyTaskDataList;
  MyDailyTask(this.dailyTaskDataList, {required this.onTaskAdded, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Daily Task List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: addTaskBottomSheet(context,
                              onTaskAdded: onTaskAdded),
                          // child: AddDailyTask(onTaskAdded: onTaskAdded),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: whiteColor),
                            SizedBox(width: 5.w),
                            Text(
                              "Add Task",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  itemCount: dailyTaskDataList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
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
                                horizontal: 10.w, vertical: 8.h),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    "${dailyTaskDataList[index].taskName}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 90.w,
                                  child: Center(
                                    child: Text(
                                      "${dailyTaskDataList[index].taskTime}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    titleTextController2.text =
                                        "${dailyTaskDataList[index].taskName}";
                                    taskTimeTextController2.text =
                                        "${dailyTaskDataList[index].taskTime}";
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: editTaskBottomSheet(context,
                                            taskId: dailyTaskDataList[index]
                                                .id
                                                .toString(),
                                            onTaskUpdated: onTaskAdded),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/png/edit_image.png',
                                    height: 20.h,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                InkWell(
                                  onTap: () {
                                    ProfileService()
                                        .deleteDailyTask(
                                            dailyTaskDataList[index].id ?? 0)
                                        .then((_) => onTaskAdded());
                                  },
                                  child: Image.asset(
                                    'assets/images/png/delete_image.png',
                                    height: 20.h,
                                  ),
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
            ],
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
  final ProfileController profileController = Get.find();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  Widget addTaskBottomSheet(BuildContext context,
      {required VoidCallback onTaskAdded}) {
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

  Widget editTaskBottomSheet(BuildContext context,
      {required String taskId, required VoidCallback onTaskUpdated}) {
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
