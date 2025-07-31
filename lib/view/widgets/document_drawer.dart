import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/helper/storage_helper.dart';

class DocumentSideDrawer extends StatefulWidget {
  const DocumentSideDrawer({super.key});

  @override
  State<DocumentSideDrawer> createState() => _DocumentSideDrawerState();
}

class _DocumentSideDrawerState extends State<DocumentSideDrawer> {
  final BottomBarController bottomBarController = Get.find();
  RxString firstLetters = ''.obs;
  @override
  void initState() {
    super.initState();
    String sn = StorageHelper.getName().toString();
    List<String> splitString = sn.split(" ");
    firstLetters.value = splitString.map((word) => word[0]).join('');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        backgroundColor: whiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                width: double.infinity,
                color: primaryColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      SizedBox(height: 45.h),
                      Row(
                        children: [
                          Container(
                            height: 35.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                              color: redColor,
                              border: Border.all(color: whiteColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.r),
                              ),
                            ),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  firstLetters.value.toUpperCase(),
                                  style: changeTextColor(
                                      rubikSmallRegular, whiteColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '${StorageHelper.getName()}',
                            style: changeTextColor(robotoRegular, whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        // Get.to(const HrScreen());
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            notesIcon,
                            color: iconColor,
                            height: 25.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            myFile,
                            style: rubikRegular,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        // Get.to(const HrScreen());
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 5.w),
                          Text(
                            deleted,
                            style: rubikRegular,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        // Get.to(const HrScreen());
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            notesIcon,
                            color: iconColor,
                            height: 25.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            sharedWithMe,
                            style: rubikRegular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
