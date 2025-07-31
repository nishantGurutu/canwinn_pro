// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class AddDailyTask extends StatelessWidget {
  final VoidCallback onTaskAdded;
  AddDailyTask({super.key, required this.onTaskAdded});
  final ProfileController profileController = Get.find();
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController taskTimeTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
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
}
