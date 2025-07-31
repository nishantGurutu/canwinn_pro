import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/meeting_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/view/widgets/add_meeting.dart';
import 'package:task_management/view/widgets/done_meeting_list.dart';
import 'package:task_management/view/widgets/meeting_list.dart';
import 'package:task_management/view/widgets/ongoing_meeting_list.dart';

class MeetingListScreen extends StatefulWidget {
  const MeetingListScreen({super.key});

  @override
  State<MeetingListScreen> createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends State<MeetingListScreen> {
  final MeetingController meetingController = Get.put(MeetingController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final TaskController taskController = Get.find();
  @override
  void initState() {
    super.initState();
    callApi();
  }

  void callApi() async {
    await meetingController.meetingList();
    await meetingController.responsiblePersonListApi('', '');
    await priorityController.priorityApi();
    await taskController.allProjectListApi();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: Row(
            children: [
              Text(
                meeting,
                style: TextStyle(
                  color: textColor,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => AddMeeting());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.add,
                      color: whiteColor,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: whiteColor,
        body: Obx(
          () => meetingController.isMeetingLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: tabBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(22.r)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => InkWell(
                                    onTap: () {
                                      meetingController.isDoneSelected.value =
                                          false;
                                      meetingController
                                          .isUpcomingSelected.value = true;
                                      meetingController
                                          .isOngoingSelected.value = false;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: meetingController
                                                    .isUpcomingSelected.value ==
                                                true
                                            ? primaryButtonColor
                                            : tabBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(22.r),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/svg/event_upcoming.svg',
                                              height: 20.h,
                                              color: meetingController
                                                          .isUpcomingSelected
                                                          .value ==
                                                      true
                                                  ? whiteColor
                                                  : textColor,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              'Upcoming',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: meetingController
                                                              .isUpcomingSelected
                                                              .value ==
                                                          true
                                                      ? whiteColor
                                                      : textColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => InkWell(
                                    onTap: () {
                                      meetingController.isDoneSelected.value =
                                          false;
                                      meetingController
                                          .isUpcomingSelected.value = false;
                                      meetingController
                                          .isOngoingSelected.value = true;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: meetingController
                                                    .isOngoingSelected.value ==
                                                true
                                            ? primaryButtonColor
                                            : tabBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(22.r),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/png/ongoing.png',
                                              height: 20.h,
                                              color: meetingController
                                                          .isOngoingSelected
                                                          .value ==
                                                      true
                                                  ? whiteColor
                                                  : textColor,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              'Ongoing',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: meetingController
                                                              .isOngoingSelected
                                                              .value ==
                                                          true
                                                      ? whiteColor
                                                      : textColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => InkWell(
                                    onTap: () {
                                      meetingController.isDoneSelected.value =
                                          true;
                                      meetingController
                                          .isUpcomingSelected.value = false;
                                      meetingController
                                          .isOngoingSelected.value = false;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: meetingController
                                                    .isDoneSelected.value ==
                                                true
                                            ? primaryButtonColor
                                            : tabBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(22.r),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/svg/assignment_turned_in.svg',
                                              height: 20.h,
                                              color: meetingController
                                                          .isDoneSelected
                                                          .value ==
                                                      true
                                                  ? whiteColor
                                                  : textColor,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: meetingController
                                                              .isDoneSelected
                                                              .value ==
                                                          true
                                                      ? whiteColor
                                                      : textColor),
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
                        ),
                      ),
                      Expanded(
                        child: meetingController.isUpcomingSelected.value ==
                                true
                            ? MeetingList(
                                meetingController.upcommingMeetingData,
                                taskController.allProjectDataList,
                                priorityController.priorityList,
                                meetingController.responsiblePersonList,
                              )
                            : meetingController.isOngoingSelected.value == true
                                ? OngoingMeetingList(
                                    meetingController.ongoingMeetingData,
                                    taskController.allProjectDataList,
                                    priorityController.priorityList,
                                    meetingController.responsiblePersonList,
                                  )
                                : DoneMeetingList(
                                    meetingController.doneMeetingData,
                                    taskController.allProjectDataList,
                                    priorityController.priorityList,
                                    meetingController.responsiblePersonList,
                                  ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
