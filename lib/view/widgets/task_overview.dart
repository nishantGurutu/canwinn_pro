import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart' show ReadMoreText, TrimMode;
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/discussion_controller.dart';
import 'package:task_management/model/task_details_model.dart';
import 'package:task_management/view/widgets/task_contact_list.dart';
import 'package:task_management/view/widgets/task_details_user_list.dart';

class TaskOverview extends StatelessWidget {
  final TaskDetailsData? data;
  final int? taskId;
  final DiscussionController discussionController;
  const TaskOverview(this.data, this.taskId, this.discussionController,
      {super.key});
  String _formatDate(String dateStr) {
    try {
      final inputFormat = DateFormat('dd-MM-yyyy');
      final date = inputFormat.parse(dateStr);
      final outputFormat = DateFormat('d MMM');
      return outputFormat.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Text(
                "${data?.title ?? ''}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Expanded(
              child: ReadMoreText(
                "${data?.description ?? ''}",
                trimMode: TrimMode.Line,
                trimLines: 3,
                colorClickableText: Colors.pink,
                trimCollapsedText: ' Show more',
                trimExpandedText: '  Show less',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                moreStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
                lessStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child:
                        progressListBottomSheet(context, data?.progress ?? []),
                  ),
                );
              },
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: selectedTabColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: SvgPicture.asset(timerIcon),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        children: [
                          Text(
                            "Progress",
                            style: changeTextColor(heading9, whiteColor),
                          ),
                          Text(
                            "Status",
                            style: changeTextColor(heading20, whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child:
                        progressListBottomSheet(context, data?.progress ?? []),
                  ),
                );
              },
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: selectedTabColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: SvgPicture.asset(hourglassIcon),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        children: [
                          Text(
                            "${data?.dueTime ?? ''}",
                            style: changeTextColor(heading9, whiteColor),
                          ),
                          Text(
                            "Due Time",
                            style: changeTextColor(heading20, whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child:
                        progressListBottomSheet(context, data?.progress ?? []),
                  ),
                );
              },
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: selectedTabColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        height: 20.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: SvgPicture.asset(
                          calenderTaskicon,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        children: [
                          Text(
                            _formatDate(data?.dueDate ?? ''),
                            style: changeTextColor(heading9, whiteColor),
                          ),
                          Text(
                            "Due Date",
                            style: changeTextColor(heading20, whiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              child: Text(
                "Contacts",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            if ((data?.contacts?.length ?? 0) > 0)
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => TaskContactList(
                        data!.contacts?.obs ?? <ContactsData>[].obs));
                  },
                  child: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: Stack(
                      children: List.generate(
                        (data?.contacts?.length ?? 0) > 3
                            ? 4
                            : (data?.contacts?.length ?? 0),
                        (index) {
                          if (index < 3) {
                            final contact = data?.contacts?[index];
                            final firstChar = contact!.name!.isNotEmpty
                                ? contact.name![0]
                                : '?';
                            final leftPosition =
                                index == 0 ? 0.0 : (index == 1 ? 22.w : 44.w);
                            final bgColor = index == 0
                                ? redColor
                                : index == 1
                                    ? blueColor
                                    : secondaryColor;

                            return Positioned(
                              left: leftPosition,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: Center(
                                  child: Text(
                                    firstChar,
                                    style:
                                        changeTextColor(heading9, whiteColor),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final extraCount = data?.contacts?.length ?? 0 - 3;
                            return Positioned(
                              left: 65.w,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: primaryButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: Center(
                                  child: Text(
                                    '+$extraCount',
                                    style:
                                        changeTextColor(heading9, whiteColor),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 5.h),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Priority', textAlign: TextAlign.end, style: heading7),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: data?.priorityName.toString().toLowerCase() ==
                              'medium'
                          ? warmYellowColor
                          : data?.priorityName.toString().toLowerCase() == 'low'
                              ? secondaryTextColorLow
                              : blueColor.withOpacity(0.28),
                      borderRadius: BorderRadius.all(
                        Radius.circular(11.r),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3),
                      child: Text(
                        "${data?.priorityName ?? ''}",
                        style: changeTextColor(
                            heading11,
                            data?.priorityName.toString().toLowerCase() ==
                                    'medium'
                                ? mediumColor
                                : data?.priorityName.toString().toLowerCase() ==
                                        'low'
                                    ? secondaryTextColor
                                    : blueColor),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Task Created by',
                        textAlign: TextAlign.start, style: heading7),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${data?.creatorName}",
                    style: heading11,
                  )
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('& Date Time',
                        textAlign: TextAlign.start, style: heading7),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${data?.taskDate}",
                    style: heading11,
                  )
                ],
              ),
            )
          ],
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: Text(
                "Assigned to",
                textAlign: TextAlign.start,
                style: heading7,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            if ((data?.assignedUsers?.length ?? 0) > 0)
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TaskDetailsUserList(
                            data?.assignedUsersList ?? [], "Assigned"),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: Stack(
                      children: List.generate(
                        (data?.assignedUsersList?.length ?? 0) > 3
                            ? 4
                            : (data?.assignedUsersList?.length ?? 0),
                        (index) {
                          if (index < 3) {
                            final leftPosition =
                                index == 0 ? 0.0 : (index == 1 ? 22.w : 44.w);
                            final bgColor = index == 0
                                ? redColor
                                : index == 1
                                    ? blueColor
                                    : secondaryColor;

                            return Positioned(
                              left: leftPosition,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                  child: Image.network(
                                    '${data?.assignedUsersList?[index].image ?? ""}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final extraCount =
                                (data?.assignedUsersList?.length ?? 0) - 3;
                            return Positioned(
                              left: 65.w,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: primaryButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: Center(
                                  child: Text(
                                    '+$extraCount',
                                    style:
                                        changeTextColor(heading9, whiteColor),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Status',
                        textAlign: TextAlign.start, style: heading6),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: data?.effectiveStatus.toString().toLowerCase() ==
                              'pending'
                          ? buttonRedColor.withOpacity(0.28)
                          : data?.effectiveStatus.toString().toLowerCase() ==
                                  'progress'
                              ? warmYellowColor
                              : blueColor.withOpacity(0.28),
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3),
                      child: Text(
                        "${data?.effectiveStatus}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              data?.effectiveStatus.toString().toLowerCase() ==
                                      "pending"
                                  ? buttonRedColor
                                  : data?.effectiveStatus
                                              .toString()
                                              .toLowerCase() ==
                                          "progress"
                                      ? mediumColor
                                      : blueColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: Text(
                "Reviewer to",
                textAlign: TextAlign.start,
                style: heading7,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            if ((data?.assignedReviewers?.length ?? 0) > 0)
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TaskDetailsUserList(
                            data?.assignedReviewersList ?? [], "Reviewer"),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: Stack(
                      children: List.generate(
                        (data?.assignedReviewersList?.length ?? 0) > 3
                            ? 4
                            : (data?.assignedReviewersList?.length ?? 0),
                        (index) {
                          if (index < 3) {
                            final leftPosition =
                                index == 0 ? 0.0 : (index == 1 ? 22.w : 44.w);
                            final bgColor = index == 0
                                ? redColor
                                : index == 1
                                    ? blueColor
                                    : secondaryColor;

                            return Positioned(
                              left: leftPosition,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                  child: Image.network(
                                    "${data?.assignedReviewersList?[index].image ?? ''}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final extraCount =
                                (data?.assignedReviewersList?.length ?? 0) - 3;
                            return Positioned(
                              left: 65.w,
                              child: Container(
                                height: 30.h,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  color: primaryButtonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r)),
                                ),
                                child: Center(
                                  child: Text(
                                    '+$extraCount',
                                    style:
                                        changeTextColor(heading9, whiteColor),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Divider(),
        // TaskComments(
        //   taskId,
        //   discussionController,
        // ),
      ],
    );
  }

  Widget progressListBottomSheet(
    BuildContext context,
    List<ProgressData> progressList,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 450.h,
      child: progressList.isEmpty
          ? Center(
              child: Text(
                'No progress list data',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor),
              ),
            )
          : ListView.separated(
              itemCount: progressList.length,
              reverse: false,
              itemBuilder: (context, index) {
                DateTime dateTime =
                    DateTime.parse(progressList[index].createdAt.toString());
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(dateTime);
                return Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: progressDetailsBottomSheet(
                                context, progressList[index], formattedDate),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(
                          width: double.infinity,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Task ID ${progressList[index].taskId}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Text(
                                  "${progressList[index].remarks ?? ""}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Text(
                                  "${progressList[index].userName ?? ""}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Text(
                                        '${progressList[index].status.toString() == "0" ? "Pending" : progressList[index].status.toString() == "1" ? "Process" : "Complete"}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: progressList[index]
                                                      .status
                                                      .toString() ==
                                                  '0'
                                              ? redColor
                                              : progressList[index]
                                                          .status
                                                          .toString() ==
                                                      '1'
                                                  ? thirdPrimaryColor
                                                  : blueColor,
                                        ),
                                      ),
                                    ),
                                    Center(
                                        child: Text(
                                            '${progressList[index].createddate}'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 2.h,
                );
              },
            ),
    );
  }

  Widget progressDetailsBottomSheet(
    BuildContext context,
    ProgressData progressList,
    String formattedDate,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 450.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Progress ID : ${progressList.id ?? ''}",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Status',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: lightSecondaryPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 3),
                                child: Center(
                                  child: Text(
                                    '${progressList.status.toString() == "0" ? "Pending" : progressList.status.toString() == "1" ? "Process" : "Complete"}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: progressList.status.toString() ==
                                              '0'
                                          ? redColor
                                          : progressList.status.toString() ==
                                                  '1'
                                              ? thirdPrimaryColor
                                              : blueColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: secondaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Date',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Text(
                          "$formattedDate",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Remark',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${progressList.remarks ?? ""}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            progressList.attachment != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'ATTACHMENT',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: secondTextColor),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 100.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                              child: Image.network(
                                '${progressList.attachment ?? ''}',
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
                        ],
                      ),
                    ],
                  )
                : SizedBox(
                    height: 20.h,
                  ),
          ],
        ),
      ),
    );
  }
}
