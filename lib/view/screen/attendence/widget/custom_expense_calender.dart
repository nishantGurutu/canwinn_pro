import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomExpenseCalender extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomExpenseCalender({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        suffixIcon: Padding(
          padding: EdgeInsets.all(11.sp),
          child: Image.asset(
            'assets/images/png/callender.png',
            color: textColor,
            height: 10.h,
          ),
        ),
        hintText: hintText,
        hintStyle: rubikRegular,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }
}
