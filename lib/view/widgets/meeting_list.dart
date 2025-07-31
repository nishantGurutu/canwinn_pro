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
import 'package:task_management/view/widgets/mom_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingList extends StatelessWidget {
  final RxList<UpcomingMeeting> meetingListData;
  final RxList<CreatedByMe> allProjectDataList;
  final RxList<PriorityData> priorityList;
  final RxList<ResponsiblePersonData> responsiblePersonList;
  MeetingList(this.meetingListData, this.allProjectDataList, this.priorityList,
      this.responsiblePersonList,
      {super.key});

  final MeetingController meetingController = Get.find();

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return meetingListData.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.h,
              children: [
                Image.asset(
                  'assets/images/png/meeting_icons.png',
                  height: 90.h,
                ),
                Text(
                  'No meeting found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: meetingListData.length,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: Text(
                                  '${index + 1}. ${meetingListData[index].title}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (meetingController
                                          .isMeetingTokenLoading.value ==
                                      false) {
                                    meetingController.meetingToken(
                                        meetingId: meetingListData[index].id);
                                  }
                                },
                                child: SizedBox(
                                  width: 35.w,
                                  child: SvgPicture.asset(
                                    'assets/images/svg/duo.svg',
                                    height: 25.h,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        InkWell(
                          onTap: () {
                            _launchURL(meetingListData[index].url.toString());
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/images/svg/attachment.svg'),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Text(
                                  '${meetingListData[index].url}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: blueColor,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          '${meetingListData[index].venue}',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                'assets/images/svg/calendar_month.svg'),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '${meetingListData[index].meetingDate}',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SvgPicture.asset('assets/images/svg/alarm.svg'),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '${meetingListData[index].meetingTime} - ${meetingListData[index].meetingEndTime}',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: MomBotomsheet(
                                        meetingListData[index].moms ?? [],
                                        allProjectDataList,
                                        priorityList,
                                        responsiblePersonList),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: lightBoxColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 5.h),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/svg/timer_10_alt_1.svg'),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(
                                        'MoM List',
                                        style: TextStyle(
                                            color: blueColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            if ((meetingListData[index]
                                        .attendingUsers
                                        ?.length ??
                                    0) >
                                0)
                              InkWell(
                                onTap: () {
                                  if (meetingController
                                          .isAttendenceLoading.value ==
                                      false) {
                                    meetingController.meetingAttendence(
                                        context, meetingListData[index].id);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 65.w,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 26.h,
                                              width: 26.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(13.r),
                                                ),
                                              ),
                                              child: meetingListData[index]
                                                          .attendingUsers !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(13.r),
                                                      ),
                                                      child: Image.network(
                                                        "${meetingListData[index].attendingUsers?.first.image}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20.r),
                                                              ),
                                                            ),
                                                            child: Image.asset(
                                                                backgroundLogo),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : SizedBox()),
                                        ],
                                      ),
                                    ),
                                    if ((meetingListData[index]
                                                .attendingUsers
                                                ?.length ??
                                            0) >
                                        1)
                                      Positioned(
                                        left: 21.w,
                                        child: Container(
                                            height: 26.h,
                                            width: 26.w,
                                            decoration: BoxDecoration(
                                              color: redColor,
                                              border:
                                                  Border.all(color: whiteColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(13.r),
                                              ),
                                            ),
                                            child: (meetingListData[index]
                                                            .attendingUsers
                                                            ?.length ??
                                                        0) >
                                                    1
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(13.r),
                                                    ),
                                                    child: Image.network(
                                                      "${meetingListData[index].attendingUsers?[1].image}",
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20.r),
                                                            ),
                                                          ),
                                                          child: Image.asset(
                                                              backgroundLogo),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : SizedBox()),
                                      ),
                                    if ((meetingListData[index]
                                                .attendingUsers
                                                ?.length ??
                                            0) >
                                        2)
                                      Positioned(
                                        left: 38.w,
                                        child: Container(
                                            height: 26.h,
                                            width: 26.w,
                                            decoration: BoxDecoration(
                                              color: greenColor,
                                              border:
                                                  Border.all(color: whiteColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(13.r),
                                              ),
                                            ),
                                            child: (meetingListData[index]
                                                            .attendingUsers
                                                            ?.length ??
                                                        0) >
                                                    2
                                                ? Text(
                                                    '${meetingListData[index].attendingUsers?.length}')
                                                : SizedBox()),
                                      )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
