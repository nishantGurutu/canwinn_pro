import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomCalender2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? from;
  final TextEditingController? otherController;

  CustomCalender2({
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
        DateTime initialDate = DateTime.now();
        DateTime firstDate = DateTime.now();
        DateTime lastDate = DateTime(2100);

        if (from == 'startDate' && otherController != null && otherController!.text.isNotEmpty) {
          try {
            DateTime dueDate = DateFormat('dd-MM-yyyy').parse(otherController!.text);
            lastDate = dueDate;
          } catch (e) {

          }
        }

        if (from == 'dueDate' && otherController != null && otherController!.text.isNotEmpty) {
          try {
            DateTime startDate = DateFormat('dd-MM-yyyy').parse(otherController!.text);
            firstDate = startDate; // Due date cannot be before start date
            initialDate = startDate.isAfter(DateTime.now()) ? startDate : DateTime.now();
          } catch (e) {

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
