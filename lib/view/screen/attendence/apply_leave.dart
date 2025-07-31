import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/leave_type_model.dart';
import 'package:task_management/view/widgets/customCalender2.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final AttendenceController attendenceController = Get.find();
  final TextEditingController leaveStartDateController =
      TextEditingController();
  final TextEditingController leaveEndDateController = TextEditingController();
  final TextEditingController leaveDurationController = TextEditingController();
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController leaveDescriptionController =
      TextEditingController();
  final TextEditingController leaveStartDateController2 =
      TextEditingController();
  final TextEditingController leaveEndDateController2 = TextEditingController();
  final TextEditingController leaveDurationController2 =
      TextEditingController();
  final TextEditingController leaveTypeController2 = TextEditingController();
  final TextEditingController leaveDescriptionController2 =
      TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    attendenceController.leaveTypeLoading();
    attendenceController.leaveLoading();
    super.initState();
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
          applyLeave,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Obx(
          () => attendenceController.isLeaveLoading.value == true &&
                  attendenceController.isLeaveTypeLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: applyLeaveBottomSheet(
                                  context,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: secondaryColor),
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 5.h),
                              child: Text(
                                'Apply Leave',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Expanded(
                      child: attendenceController.leaveListData.isEmpty
                          ? Center(
                              child: Text(
                                'No leave data',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  attendenceController.leaveListData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.r)),
                                            border: Border.all(
                                                color: lightGreyColor)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.h, vertical: 5.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${attendenceController.leaveListData[index].userName}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                '${attendenceController.leaveListData[index].leavetypeName}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                '${attendenceController.leaveListData[index].reason}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${attendenceController.leaveListData[index].leaveDateRange}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Container(
                                                    width: 80.w,
                                                    height: 25.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12.r)),
                                                        color: attendenceController
                                                                    .leaveListData[
                                                                        index]
                                                                    .status ==
                                                                1
                                                            ? progressBackgroundColor
                                                            : attendenceController
                                                                        .leaveListData[
                                                                            index]
                                                                        .status ==
                                                                    0
                                                                ? softYellowColor
                                                                : softredColor),
                                                    child: Center(
                                                      child: Text(
                                                        '${attendenceController.leaveListData[index].status == 1 ? "Approved" : attendenceController.leaveListData[index].status == 0 ? "Pending" : "Reject"}',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: attendenceController
                                                                        .leaveListData[
                                                                            index]
                                                                        .status ==
                                                                    1
                                                                ? greenColor
                                                                : attendenceController
                                                                            .leaveListData[
                                                                                index]
                                                                            .status ==
                                                                        0
                                                                    ? secondaryPrimaryColor
                                                                    : slightlyDarkColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (attendenceController
                                              .leaveListData[index].status ==
                                          0)
                                        Positioned(
                                          top: 5.h,
                                          right: 2.w,
                                          child: SizedBox(
                                            height: 20.h,
                                            width: 30.w,
                                            child: PopupMenuButton<String>(
                                              color: whiteColor,
                                              padding: const EdgeInsets.all(0),
                                              icon: const Icon(Icons.more_vert),
                                              onSelected:
                                                  (String result) async {
                                                switch (result) {
                                                  case 'edit':
                                                    leaveStartDateController2
                                                            .text =
                                                        attendenceController
                                                            .leaveListData[
                                                                index]
                                                            .startDate
                                                            .toString();
                                                    leaveEndDateController2
                                                            .text =
                                                        attendenceController
                                                            .leaveListData[
                                                                index]
                                                            .endDate
                                                            .toString();
                                                    leaveTypeController2.text =
                                                        attendenceController
                                                            .leaveListData[
                                                                index]
                                                            .leaveType
                                                            .toString();
                                                    leaveDescriptionController2
                                                            .text =
                                                        attendenceController
                                                            .leaveListData[
                                                                index]
                                                            .reason
                                                            .toString();
                                                    await showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (context) =>
                                                          Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: leaveEditingBottomSheet(
                                                            context,
                                                            attendenceController
                                                                .leaveListData[
                                                                    index]
                                                                .id
                                                                .toString()),
                                                      ),
                                                    );
                                                    break;
                                                  case 'delete':
                                                    attendenceController
                                                        .leaveDeleting(
                                                      attendenceController
                                                          .leaveListData[index]
                                                          .id,
                                                    );
                                                    break;
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: ListTile(
                                                    leading: Icon(Icons.edit),
                                                    title: Text('Edit'),
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text('Delete'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget applyLeaveBottomSheet(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 420.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Leave Start Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender2(
                      hintText: dateFormate2,
                      controller: leaveStartDateController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave End Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender2(
                      hintText: dateFormate2,
                      controller: leaveEndDateController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomDropdown<LeaveTypeData>(
                      items: attendenceController.leaveTypeList,
                      itemLabel: (item) => item.name ?? "",
                      selectedValue: null,
                      onChanged: (value) {
                        attendenceController.selectedLeaveType.value = value;
                        leaveTypeController.text =
                            (attendenceController.selectedLeaveType.value?.id ??
                                    "")
                                .toString();
                      },
                      hintText: selectPriority,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TaskCustomTextField(
                      controller: leaveDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      data: taskName,
                      hintText: enterLeaveDescription,
                      labelText: enterLeaveDescription,
                      index: 4,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: () async {
                          if (attendenceController.isApplyingLeave.value ==
                              false) {
                            await attendenceController.aplyingLeave(
                              leaveStartDateController.text,
                              leaveEndDateController.text,
                              leaveDurationController.text,
                              leaveTypeController.text,
                              leaveDescriptionController.text,
                            );
                          }
                        },
                        text: attendenceController.isApplyingLeave.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    loading,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor),
                                  ),
                                ],
                              )
                            : Text(
                                submit,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Positioned(
                  right: 1,
                  child: Container(
                    width: 20.w,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget leaveEditingBottomSheet(BuildContext context, String leaveId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 420.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Leave Start Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender2(
                      hintText: dateFormate2,
                      controller: leaveStartDateController2,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave End Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender2(
                      hintText: dateFormate2,
                      controller: leaveEndDateController2,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomDropdown<LeaveTypeData>(
                      items: attendenceController.leaveTypeList,
                      itemLabel: (item) => item.name ?? "",
                      selectedValue: null,
                      onChanged: (value) {
                        attendenceController.selectedLeaveType.value = value;
                        leaveTypeController2.text =
                            (attendenceController.selectedLeaveType.value?.id ??
                                    "")
                                .toString();
                      },
                      hintText: selectPriority,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TaskCustomTextField(
                      controller: leaveDescriptionController2,
                      textCapitalization: TextCapitalization.sentences,
                      data: taskName,
                      hintText: enterLeaveDescription,
                      labelText: enterLeaveDescription,
                      index: 4,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: () async {
                          if (attendenceController.isApplyingLeave.value ==
                              false) {
                            await attendenceController.leaveEditing(
                              leaveStartDateController2.text,
                              leaveEndDateController2.text,
                              leaveDurationController2.text,
                              leaveTypeController2.text,
                              leaveDescriptionController2.text,
                              leaveId,
                            );
                          }
                        },
                        text: attendenceController.isApplyingLeave.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    loading,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor),
                                  ),
                                ],
                              )
                            : Text(
                                submit,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Positioned(
                  right: 1,
                  child: Container(
                    width: 20.w,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
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
