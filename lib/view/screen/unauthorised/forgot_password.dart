import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/forgot_password_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () => forgotPasswordController.isPasswordForgeting.value == true
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
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
                                  forgotPasswordTitle,
                                  style:
                                      changeTextColor(boldText, primaryColor),
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
                                  data: email,
                                  hintText: email,
                                ),
                                SizedBox(
                                  height: 20.h,
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
                                CustomButton(
                                  onPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    //   if (registerController.isLoginLoading.value !=
                                    //       true) {
                                    //     registerController.userLogin(
                                    //         emailTextEditingController.text,
                                    //         passwordTextEditingController.text,
                                    //         deviceTokenToSendPushNotification);
                                    //   }
                                    // }
                                  },
                                  text:
                                      // registerController
                                      //             .isLoginLoading.value ==
                                      //         true
                                      //     ?
                                      // Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     children: [
                                      //       SizedBox(
                                      //         height: 30.h,
                                      //         child:
                                      //             CircularProgressIndicator(
                                      //           color: whiteColor,
                                      //         ),
                                      //       ),
                                      //       SizedBox(width: 10.w),
                                      //       Text(
                                      //         loading,
                                      //         style: changeTextColor(
                                      //             rubikBlack, whiteColor),
                                      //       ),
                                      //     ],
                                      //   )
                                      // :
                                      Text(
                                    signin,
                                    style:
                                        changeTextColor(rubikBlack, whiteColor),
                                  ),
                                  color: primaryColor,
                                  height: 45.h,
                                  width: double.infinity,
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
      ),
    );
  }
}
