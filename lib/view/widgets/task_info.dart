import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class TaskInfo extends StatelessWidget {
  final String s;
  final int totalTask;
  final String icon;
  final Color color;
  final Color gradientColor1;
  final Color gradientColor2;
  const TaskInfo(this.s, this.totalTask, this.icon, this.color,
      this.gradientColor1, this.gradientColor2,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: boxBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(18.r)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientColor1,
            gradientColor2,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          icon.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(
                  icon,
                  height: 34.sp,
                  width: 34.sp,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  icon,
                  height: 34.sp,
                  width: 34.sp,
                  fit: BoxFit.contain,
                ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s,
                  style: heading7,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),
                Text(
                  "${totalTask}",
                  style: heading9,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
