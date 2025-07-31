import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';

class AttendenceBox extends StatelessWidget {
  final String attendenceStatusList;
  final String attendenceStatusValueList;
  const AttendenceBox(this.attendenceStatusList, this.attendenceStatusValueList,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundGreyColor,
          borderRadius: BorderRadius.all(
            Radius.circular(3.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$attendenceStatusList',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$attendenceStatusValueList',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
