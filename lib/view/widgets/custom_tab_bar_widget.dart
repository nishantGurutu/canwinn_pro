import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tabBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(22.r),
        ),
      ),
      child: Row(
        children: [
          Obx(
            () => Expanded(
              child: InkWell(
                onTap: () {
                  homeController.isGeneralSelected.value == true;
                  homeController.isTaskCommentSelected.value == false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: homeController.isGeneralSelected.value == true
                        ? primaryColor
                        : tabBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(generalChatSvgIcon,
                            height: 26.h, color: whiteColor),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(generalText,
                            style: changeTextColor(
                                heading6,
                                homeController.isGeneralSelected.value == true
                                    ? whiteColor
                                    : chatIconColor))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: InkWell(
                onTap: () {
                  homeController.isGeneralSelected.value == false;
                  homeController.isTaskCommentSelected.value == true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: homeController.isTaskCommentSelected.value == true
                        ? primaryColor
                        : tabBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          commentSvgIcon,
                          height: 26.h,
                          color: chatIconColor,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          taskComents,
                          style: changeTextColor(
                              heading6,
                              homeController.isTaskCommentSelected.value == true
                                  ? whiteColor
                                  : chatIconColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
