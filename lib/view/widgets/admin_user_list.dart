import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/custom_text_convert.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/view/screen/usee_wise_home_screen.dart';
import 'package:task_management/view/widgets/home_title.dart';

class AdminUserList extends StatelessWidget {
  final RxList<HomeUsers> homeAdminUserList;
  final TaskController taskController;
  final HomeController homeController;
  const AdminUserList(
      this.homeAdminUserList, this.taskController, this.homeController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeTitle('User Task Preview'),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: boxBorderColor),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: lightGreyColor.withOpacity(0.1),
                  blurRadius: 13.0,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "User Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Pending",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Complete",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: Obx(
                    () => homeController.isUserReportLoading.value == true
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: homeController.userReportDataList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      String cacheKey = 'home_data_cache';
                                      final cacheManager =
                                          DefaultCacheManager();
                                      await cacheManager
                                          .removeFile('$cacheKey');
                                      Get.to(() => UserWiseHomeScreen(
                                          homeController
                                              .userReportDataList[index]?.id,
                                          homeController
                                                  .userReportDataList[index]
                                                  ?.name ??
                                              ""));
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.h)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${CustomTextConvert().getNameChar(homeController.userReportDataList[index]?.name ?? "")}',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "${homeController.userReportDataList[index]?.name ?? ""}",
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                "${homeController.userReportDataList[index]?.inProgressTaskCount ?? 0}",
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${homeController.userReportDataList[index]?.completedTaskCount ?? 0}",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: lightBorderColor,
                                  )
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
