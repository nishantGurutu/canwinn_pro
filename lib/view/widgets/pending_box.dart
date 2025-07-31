import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/constant/color_constant.dart';

class PendingBox extends StatelessWidget {
  final String image;
  final String text;
  final int data;
  const PendingBox(
      {super.key, required this.image, required this.text, required this.data});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text('$data'),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: backgroundColor),
          borderRadius: BorderRadius.all(
            Radius.circular(13.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                image,
                height: 27.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
