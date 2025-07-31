import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomCalender2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomCalender2({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: lightSecondaryColor,
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Image.asset(
            'assets/images/png/callender.png',
            color: secondaryColor,
            height: 10.h,
          ),
        ),
        hintText: hintText,
        hintStyle: rubikRegular,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }
}
