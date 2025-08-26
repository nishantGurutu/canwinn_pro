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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
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
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                        itemCount: attendenceController.leaveListData.length,
                        padding: EdgeInsets.all(8.w),
                        itemBuilder: (context, index) {
                          final leave = attendenceController.leaveListData[index];
                          final isPending = leave.status == 0;
                          final isApproved = leave.status == 1;

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name + Menu
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      leave.userName ?? '',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (isPending)
                                      PopupMenuButton<String>(
                                        color: whiteColor,
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.more_vert),
                                        onSelected: (String result) async {
                                          if (result == 'edit') {
                                            leaveStartDateController2.text = leave.startDate.toString();
                                            leaveEndDateController2.text = leave.endDate.toString();
                                            leaveTypeController2.text = leave.leaveType.toString();
                                            leaveDescriptionController2.text = leave.reason.toString();
                                            await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                                ),
                                                child: leaveEditingBottomSheet(
                                                  context,
                                                  leave.id.toString(),
                                                ),
                                              ),
                                            );
                                          } else if (result == 'delete') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm Deletion"),
                                                  content: Text("Are you sure you want to delete this leave?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        await attendenceController.leaveDeleting(leave.id);
                                                      },
                                                      child: Text("OK"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
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
                                  ],
                                ),
                                SizedBox(height: 8.h),

                                // Leave Type
                                Row(
                                  children: [
                                    Icon(Icons.beach_access, size: 18.sp, color: Colors.blueGrey),
                                    SizedBox(width: 6.w),
                                    Text(
                                      leave.leavetypeName ?? '',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),

                                // Reason
                                Text(
                                  leave.reason ?? '',
                                  style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 8.h),

                                // Date + Status (Column layout)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
                                        SizedBox(width: 4.w),
                                        Text(
                                          leave.leaveDateRange ?? '',
                                          style: TextStyle(fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: isApproved
                                              ? progressBackgroundColor
                                              : isPending
                                              ? softYellowColor
                                              : softredColor,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          isApproved
                                              ? "Approved"
                                              : isPending
                                              ? "Pending"
                                              : "Rejected",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isApproved
                                                ? greenColor
                                                : isPending
                                                ? secondaryPrimaryColor
                                                : slightlyDarkColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                      from: 'startDate',
                      otherController: leaveEndDateController,
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
                      from: 'dueDate',
                      otherController: leaveStartDateController,
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
                      () => SafeArea(
                        child: CustomButton(
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
                      () => SafeArea(
                        child: CustomButton(
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
