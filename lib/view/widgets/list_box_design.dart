import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class ListBoxDesign extends StatelessWidget {
  final String image;
  final String title;
  final String value;
  const ListBoxDesign(
      {super.key,
      required this.image,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(11.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 45.h,
            ),
            SizedBox(
              width: 6.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: heading9,
                ),
                Text(
                  value,
                  style: changeTextColor(heading11, redColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
