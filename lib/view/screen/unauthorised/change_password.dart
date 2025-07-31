import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Image.asset(
                backArrowIcon,
                color: whiteColor,
              ),
            ),
          ),
        ),
        title: Text(
          changeText,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                oldText,
                style: robotoRegular,
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: oldPasswordTextEditingController,
                textCapitalization: TextCapitalization.none,
                hintText: enterOldText,
              ),
              SizedBox(height: 15.h),
              Text(
                newPasswordText,
                style: robotoRegular,
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: oldPasswordTextEditingController,
                textCapitalization: TextCapitalization.none,
                hintText: enterNewPasswordText,
              ),
              SizedBox(height: 15.h),
              Text(
                confirmPasswordText,
                style: robotoRegular,
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: oldPasswordTextEditingController,
                textCapitalization: TextCapitalization.none,
                hintText: enterConfirmPasswordText,
              ),
              SizedBox(height: 25.h),
              CustomButton(
                onPressed: () {},
                text: Text(changePassword),
                width: double.infinity,
                color: primaryColor,
                height: 45.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
