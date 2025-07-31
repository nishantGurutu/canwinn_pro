import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class EditDailyTask extends StatelessWidget {
  final VoidCallback onTaskUpdated;
  final String? taskId;
  EditDailyTask({super.key, this.taskId, required this.onTaskUpdated});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController taskTimeTextController = TextEditingController();
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
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
                height: 15.h,
              ),
              Obx(
                () => CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (profileController.isDailyTaskEditing.value == false) {
                        profileController.editDailyTask(
                            taskId,
                            titleTextController.text,
                            taskTimeTextController.text,
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
