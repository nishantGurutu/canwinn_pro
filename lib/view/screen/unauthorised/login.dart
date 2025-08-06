import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/firebase_messaging/notification_firebase.dart';
import 'package:task_management/view/screen/unauthorised/forgot_password.dart';
import '../../../constant/style_constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final RegisterController registerController =
      Get.put(RegisterController());
  String deviceToken = "";
  String androidVersion = 'Unknown';
  String modelName = 'Unknown';
  String appVersion = '1.0.0+2';
  @override
  void initState() {
    super.initState();
    functionCalling();
  }

  void functionCalling() async {
    await _getAndroidVersion();
    await firebaseNotification(context);
  }

  Future<void> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        androidVersion = '${androidInfo.version.release}';
        modelName = '${androidInfo.model}';
      });
    } else {
      setState(() {
        androidVersion = 'Not running on Android';
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Image.asset(
                    'assets/images/png/Ellipse 2 (1).png',
                    height: 265.w,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/png/Ellipse 1.png',
                    width: 250.w,
                  ),
                ],
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 85.h),
                        Text(
                          loginHere,
                          style: changeTextColor(boldText, primaryColor),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          welcomeBack,
                          textAlign: TextAlign.center,
                          style: changeTextColor(rubikBlack, textColor),
                        ),
                        SizedBox(
                          height: 65.h,
                        ),
                        CustomTextField(
                          controller: emailTextEditingController,
                          textCapitalization: TextCapitalization.none,
                          maxLine: 1,
                          data: email,
                          hintText: email,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Obx(
                          () => CustomTextField(
                            controller: passwordTextEditingController,
                            textCapitalization: TextCapitalization.none,
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
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(const ForgotPassword());
                              },
                              child: SizedBox(
                                height: 25.h,
                                child: Text(
                                  forgotPassword,
                                  style: changeTextColor(
                                      regularSmallText, secondaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Obx(
                          () => CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (registerController.isLoginLoading.value !=
                                    true) {
                                  registerController.userLogin(
                                    emailTextEditingController.text,
                                    passwordTextEditingController.text,
                                    deviceTokenToSendPushNotification,
                                    androidVersion,
                                    modelName,
                                    appVersion,
                                  );
                                }
                              }
                            },
                            text: registerController.isLoginLoading.value ==
                                    true
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
                                        style: changeTextColor(
                                            rubikBlack, whiteColor),
                                      ),
                                    ],
                                  )
                                : Text(
                                    signin,
                                    style:
                                        changeTextColor(rubikBlack, whiteColor),
                                  ),
                            color: primaryColor,
                            height: 45.h,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 170.h),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
