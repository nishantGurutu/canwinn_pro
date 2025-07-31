import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/constant/color_constant.dart';

class CnSvgImage extends StatelessWidget {
  const CnSvgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/svg/menu.svg',
      height: 20.h,
      color: textColor,
    );
  }
}
