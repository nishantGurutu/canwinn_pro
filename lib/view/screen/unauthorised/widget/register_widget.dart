import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/firebase_messaging/notification_firebase.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final RegisterController registerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 50.h),
          Image.asset(
            splashLogo,
            height: 110.h,
          ),
          SizedBox(height: 50.h),
          CustomTextField(
            controller: registerController.registerNameTextEditingController,
            textCapitalization: TextCapitalization.sentences,
            hintText: enterYourName,
            data: name,
          ),
          SizedBox(height: 15.h),
          CustomTextField(
            controller: registerController.registerEmailTextEditingController,
            textCapitalization: TextCapitalization.none,
            hintText: enterYourEmail,
            data: email,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15.h),
          Obx(
            () => CustomTextField(
              controller:
                  registerController.registerPasswordTextEditingController,
              textCapitalization: TextCapitalization.sentences,
              hintText: enterYourPassword,
              data: password,
              obscureText: registerController.isVisibility.value,
              suffixIcon: InkWell(
                onTap: () {
                  registerController.isVisibility.value =
                      !registerController.isVisibility.value;
                },
                child: Icon(
                  registerController.isVisibility.value == true
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: iconColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Obx(
            () => CustomTextField(
              controller:
                  registerController.registerConPasswordTextEditingController,
              textCapitalization: TextCapitalization.sentences,
              hintText: enterConfirmPasswordText,
              data: conPassword,
              obscureText: registerController.isVisibility2.value,
              suffixIcon: InkWell(
                onTap: () {
                  registerController.isVisibility2.value =
                      !registerController.isVisibility2.value;
                },
                child: Icon(
                  registerController.isVisibility2.value == true
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: iconColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Obx(
            () => CustomButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  registerController.registerUser(
                      registerController.registerNameTextEditingController.text,
                      registerController
                          .registerEmailTextEditingController.text,
                      registerController
                          .registerPasswordTextEditingController.text,
                      registerController
                          .registerConPasswordTextEditingController.text,
                      deviceTokenToSendPushNotification);
                }
              },
              text: registerController.isLoading.value == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.h,
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          loading,
                          style: changeTextColor(rubikBlack, whiteColor),
                        ),
                      ],
                    )
                  : Text(
                      registerText,
                      style: changeTextColor(rubikBlack, whiteColor),
                    ),
              color: primaryColor,
              width: double.infinity,
              height: 45.h,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
