import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/register_controller.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool? enable;
  final bool readonly;
  final String? data;
  final VoidCallback? onTap;

  CustomTextField({
    super.key,
    this.hintText,
    this.keyboardType,
    required this.controller,
    required this.textCapitalization,
    this.maxLine,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.enable = true,
    this.data,
    this.onTap,
    this.readonly = false,
  });

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readonly,
      textCapitalization: textCapitalization,
      maxLines: obscureText == true ? 1 : maxLine,
      maxLength: maxLength,
      enabled: enable,
      onTap: onTap,
      obscureText: obscureText ?? false,
      style:
          enable == false ? changeTextColor(rubikRegular, darkGreyColor) : null,
      validator: (value) {
        if (data == "Reminder") {
          return null;
        }
        if (value!.isEmpty) {
          return "Please Enter $data";
        }
        if (data == "email") {
          String pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Please Enter Valid Email';
          }
        }

        if (data == 'Confirm Password') {
          if (registerController.registerPasswordTextEditingController.text !=
              registerController
                  .registerConPasswordTextEditingController.text) {
            return "Password and confirm password don't match.";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        counterText: "",
        fillColor: whiteColor,
        filled: true,
        hintStyle: changeTextColor(rubikRegular, darkGreyColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      ),
    );
  }
}
