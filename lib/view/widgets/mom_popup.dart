import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/meeting_controller.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/meeting_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/add_task.dart';

class MomBotomsheet extends StatelessWidget {
  final List<Moms> momUsers;
  final RxList<CreatedByMe> allProjectDataList;
  final RxList<PriorityData> priorityList;
  final RxList<ResponsiblePersonData> responsiblePersonList;
  final int? id;
  MomBotomsheet(
    this.momUsers,
    this.allProjectDataList,
    this.priorityList,
    this.responsiblePersonList,
    this.id, {
    super.key,
  });

  final MeetingController meetingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      width: double.infinity,
      height: 620.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mom List",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: 25.w,
                    height: 35.h,
                    child: SvgPicture.asset('assets/images/svg/cancel.svg'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    meetingController.momController.clear();
                    meetingController.showAlertDialog(context, id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightBoxColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/svg/timer_10_alt_1.svg',
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Add MoM',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Expanded(
              child:
                  momUsers.isEmpty
                      ? Center(
                        child: Text(
                          "No mom available",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: momUsers.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                        child: Image.network(
                                          '${momUsers[index].userimage}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.r),
                                                ),
                                              ),
                                              child: Image.asset(
                                                backgroundLogo,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${momUsers[index].username}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '${momUsers[index].description}',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder:
                                              (context) => Padding(
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                      MediaQuery.of(
                                                        context,
                                                      ).viewInsets.bottom,
                                                ),
                                                child: AddTask(
                                                  priorityList,
                                                  allProjectDataList,
                                                  responsiblePersonList,
                                                  0,
                                                  momUsers[index].description,
                                                ),
                                              ),
                                        );
                                      },
                                      child: Container(
                                        height: 26.h,
                                        width: 26.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: borderColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(13.r),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(13.r),
                                          ),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
