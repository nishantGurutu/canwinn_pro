import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final TextEditingController lastNameTextEditingController =
      TextEditingController();
  final TextEditingController dobTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController mobileTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
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
          setting,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  firstName,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: firstName,
                  keyboardType: TextInputType.emailAddress,
                  controller: firstNameTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  lastName,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: lastName,
                  keyboardType: TextInputType.emailAddress,
                  controller: lastNameTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  dateOfBirth,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: dateFormate,
                  keyboardType: TextInputType.emailAddress,
                  controller: dobTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  emailId,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: emailExample,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  mobileNumber,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: mobileExample,
                  keyboardType: TextInputType.emailAddress,
                  controller: mobileTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  phoneNumber,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: phoneExample,
                  keyboardType: TextInputType.emailAddress,
                  controller: phoneTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 10.h),
                Text(
                  address,
                  style: rubikRegular,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  hintText: address,
                  keyboardType: TextInputType.emailAddress,
                  controller: addressTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLine: 4,
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: Text(
                    save,
                    style: changeTextColor(rubikBlack, whiteColor),
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
}
