import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/meeting_controller.dart';
import 'package:task_management/model/meeting_list_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingList extends StatelessWidget {
  final RxList<UpcomingMeeting> meetingListData;
  UpcomingList(this.meetingListData, {super.key});

  final MeetingController meetingController = Get.find();

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          child: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${index + 1}. ${meetingListData[index].title}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Obx(
                        () {
                          return meetingController.isMeetingTokenLoading.value
                              ? CircularProgressIndicator()
                              : IconButton(
                                  onPressed: () async {
                                    await meetingController.meetingToken();
                                  },
                                  icon: const Icon(Icons.video_call),
                                );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                    onTap: () async {
                      _launchURL(meetingListData[index].url ?? "");
                    },
                    child: Text(
                      '${meetingListData[index].url}',
                      style: TextStyle(
                          fontSize: 16,
                          color: blueColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${meetingListData[index].venue}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${meetingListData[index].meetingDate} ${meetingListData[index].meetingTime} - ${meetingListData[index].meetingEndTime}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (meetingController.isAttendStatusUpdating.value ==
                              false) {
                            await meetingController.attendMeeting(
                              context,
                              meetingId: meetingListData[index].id,
                              status: 1,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: meetingBoxColor,
                            ),
                            color: meetingListData[index]
                                        .attendanceStatus
                                        .toString() ==
                                    "1"
                                ? meetingBoxColor
                                : whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/png/done_tick.png',
                                  height: 15.h,
                                  color: meetingListData[index]
                                              .attendanceStatus
                                              .toString() ==
                                          "1"
                                      ? whiteColor
                                      : meetingBoxColor,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  'Attending',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: meetingListData[index]
                                                .attendanceStatus
                                                .toString() ==
                                            "1"
                                        ? whiteColor
                                        : meetingBoxColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      InkWell(
                        onTap: () async {
                          await meetingController.attendMeeting(
                            context,
                            meetingId: meetingListData[index].id,
                            status: 0,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: meetingListData[index]
                                        .attendanceStatus
                                        .toString() ==
                                    "0"
                                ? buttonRedColor
                                : whiteColor,
                            border: Border.all(
                              color: buttonRedColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/png/raphael_cross.png',
                                  height: 15.h,
                                  color: meetingListData[index]
                                              .attendanceStatus
                                              .toString() ==
                                          "0"
                                      ? whiteColor
                                      : buttonRedColor,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  'Not Attending',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: meetingListData[index]
                                                .attendanceStatus
                                                .toString() ==
                                            "0"
                                        ? whiteColor
                                        : buttonRedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
