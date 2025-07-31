import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/view/screen/attendence/widget/attendence_bos.dart';
import 'package:task_management/view/screen/attendence/widget/attendence_list.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  final AttendenceController attendenceController =
      Get.put(AttendenceController());

  Rx<DateTime> currentDate = DateTime.now().obs;
  @override
  initState() {
    currentDate.value =
        DateTime(currentDate.value.year, currentDate.value.month, 1);
    attendenceController.attendenceList(
        month: currentDate.value.month, year: currentDate.value.year);
    super.initState();
  }

  void previousMonth() async {
    currentDate.value =
        await DateTime(currentDate.value.year, currentDate.value.month - 1, 1);
    await attendenceController.attendenceList(
        month: currentDate.value.month, year: currentDate.value.year);
  }

  void nextMonth() async {
    currentDate.value =
        await DateTime(currentDate.value.year, currentDate.value.month + 1, 1);
    await attendenceController.attendenceList(
        month: currentDate.value.month, year: currentDate.value.year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          attendence,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: lightBlue,
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: lightGreyColor.withOpacity(0.1),
                    blurRadius: 13.0,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: previousMonth,
                            child: Container(
                              width: 30.w,
                              child: SizedBox(
                                width: 12.w,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              DateFormat('MMMM yyyy').format(currentDate.value),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          GestureDetector(
                            onTap: nextMonth,
                            child: Container(
                              width: 30.w,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: 12.w,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Divider(),
                    SizedBox(
                      height: 5.h,
                    ),
                    Obx(
                      () => attendenceController
                                  .isAttendenceListLoading.value ==
                              true
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => AttendenceBox(
                                      attendenceController
                                          .attendenceStatusList[0],
                                      (attendenceController.attendenceListModel
                                                  .value?.data?.presentDays ??
                                              "")
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Obx(
                                    () => AttendenceBox(
                                        attendenceController
                                            .attendenceStatusList[1],
                                        (attendenceController
                                                    .attendenceListModel
                                                    .value
                                                    ?.data
                                                    ?.absentCount ??
                                                "")
                                            .toString()),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Obx(
                                    () => AttendenceBox(
                                        attendenceController
                                            .attendenceStatusList[2],
                                        (attendenceController
                                                    .attendenceListModel
                                                    .value
                                                    ?.data
                                                    ?.halfdayCount ??
                                                "")
                                            .toString()),
                                  )
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => AttendenceBox(
                                attendenceController.attendenceStatusList[3],
                                (attendenceController.attendenceListModel.value
                                            ?.data?.leaveCount ??
                                        "")
                                    .toString()),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Obx(
                            () => AttendenceBox(
                                attendenceController.attendenceStatusList[4],
                                (attendenceController.attendenceListModel.value
                                            ?.data?.fine ??
                                        "")
                                    .toString()),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Obx(
                            () => AttendenceBox(
                                attendenceController.attendenceStatusList[5],
                                (attendenceController.attendenceListModel.value
                                            ?.data?.overtime ??
                                        "")
                                    .toString()),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Container(
                            height: 8.h,
                            width: 8.w,
                            decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '${(attendenceController.attendenceListModel.value?.data?.approvalPendingCount ?? "").toString()} Approval pending',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.r),
                    ),
                  ),
                  child: Obx(
                    () => attendenceController.isAttendenceListLoading.value ==
                            true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attendence Summary',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 20.h),
                                Expanded(
                                  child: AttendenceList(attendenceController
                                      .attendenceListModel.value?.data?.list),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
