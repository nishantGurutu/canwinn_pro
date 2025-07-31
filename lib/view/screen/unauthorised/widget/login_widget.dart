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
import 'package:task_management/view/screen/unauthorised/forgot_password.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  late final RegisterController registerController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
              controller: emailTextEditingController,
              textCapitalization: TextCapitalization.none,
              hintText: enterYourEmail,
              keyboardType: TextInputType.emailAddress,
              data: email,
            ),
            SizedBox(height: 15.h),
            Obx(
              () => CustomTextField(
                controller: passwordTextEditingController,
                textCapitalization: TextCapitalization.sentences,
                hintText: enterYourPassword,
                data: password,
                obscureText: registerController.isVisibility3.value,
                suffixIcon: InkWell(
                  onTap: () {
                    registerController.isVisibility3.value =
                        !registerController.isVisibility3.value;
                  },
                  child: Icon(
                    registerController.isVisibility3.value == true
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(const ForgotPassword());
                  },
                  child: SizedBox(
                    height: 25.h,
                    child: Text(
                      forgotPassword,
                      style: changeTextColor(rubikRegular, redColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Obx(
              () => CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (registerController.isLoginLoading.value != true) {
                      // registerController.userLogin(
                      //     emailTextEditingController.text,
                      //     passwordTextEditingController.text,
                      //     deviceTokenToSendPushNotification);
                    }
                  }
                },
                text: registerController.isLoginLoading.value == true
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
                        loginText,
                        style: changeTextColor(rubikBlack, whiteColor),
                      ),
                color: primaryColor,
                height: 45.h,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
