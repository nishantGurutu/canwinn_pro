import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomCalender extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? from;
  final TextEditingController? otherController;

  const CustomCalender({
    super.key,
    required this.hintText,
    required this.controller,
    this.from,
    this.otherController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: whiteColor,
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
      readOnly: true,
      onTap: () async {
        DateTime initialDate = DateTime.now();
        DateTime firstDate =
            from == 'report'
                ? DateTime(1900)
                : DateTime.now(); // Restrict to today or later
        DateTime lastDate = DateTime(2200);

        // If selecting start date, ensure it's not after due date
        if (from == 'startDate' &&
            otherController != null &&
            otherController!.text.isNotEmpty) {
          try {
            DateTime dueDate = DateFormat(
              'dd-MM-yyyy',
            ).parse(otherController!.text);
            lastDate = dueDate; // Start date cannot be after due date
          } catch (e) {
            // Handle invalid date format if necessary
          }
        }

        // If selecting due date, ensure it's not before start date
        if (from == 'dueDate' &&
            otherController != null &&
            otherController!.text.isNotEmpty) {
          try {
            DateTime startDate = DateFormat(
              'dd-MM-yyyy',
            ).parse(otherController!.text);
            firstDate = startDate; // Due date cannot be before start date
            initialDate =
                startDate.isAfter(DateTime.now()) ? startDate : DateTime.now();
          } catch (e) {
            // Handle invalid date format if necessary
          }
        }

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          controller.text = formattedDate;
        }
      },
    );
  }
}
