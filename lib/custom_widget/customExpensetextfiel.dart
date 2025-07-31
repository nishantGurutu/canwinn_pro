import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomExpanseTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  GestureTapCallback? onTap;
  final bool? obscureText;
  final bool? enable;
  final String? data;
  final bool? readOnly;

  CustomExpanseTextField({
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
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      textCapitalization: textCapitalization,
      maxLines: obscureText == true ? 1 : maxLine,
      maxLength: maxLength,
      enabled: enable,
      readOnly: readOnly ?? false,
      onTap: onTap,
      obscureText: obscureText ?? false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$data field is required';
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
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
    );
  }
}
