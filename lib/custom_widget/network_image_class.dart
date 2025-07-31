import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageurl;
  final double? height;
  final double? width;
  const NetworkImageWidget(
      {super.key,
      required this.imageurl,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => NetworkImageScreen(
              file: imageurl ?? '',
            ));
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: lightGreyColor.withOpacity(0.2),
              blurRadius: 13.0,
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
          child: Image.network(
            imageurl ?? "",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.r),
                  ),
                ),
                child: Image.asset(backgroundLogo),
              );
            },
          ),
        ),
      ),
    );
  }
}
