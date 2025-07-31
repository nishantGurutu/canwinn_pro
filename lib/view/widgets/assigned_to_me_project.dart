import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/model/all_project_list_model.dart';

class AssignedToMeProject extends StatelessWidget {
  final RxList<CreatedByMe> assignedProjectList;
  const AssignedToMeProject(this.assignedProjectList, {super.key});

  @override
  Widget build(BuildContext context) {
    return assignedProjectList.isEmpty
        ? Center(
            child: Text(
              'No project available',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ListView.builder(
            itemCount: assignedProjectList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: newLightTextColor),
                          borderRadius:
                              BorderRadius.all(Radius.circular(11.r))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.h,
                          children: [
                            Text(
                              'Project ID ${assignedProjectList[index].id}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: newLightTextColor),
                            ),
                            Text(
                              '${assignedProjectList[index].name}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                            Text(
                              '${assignedProjectList[index].description}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: activeColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(11.r))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 2.h),
                                    child: Text(
                                      '${assignedProjectList[index].statusName}',
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/png/calendar_month.png",
                                        height: 18.h,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${assignedProjectList[index].startDate}',
                                        style: TextStyle(
                                            color: newLightTextColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
