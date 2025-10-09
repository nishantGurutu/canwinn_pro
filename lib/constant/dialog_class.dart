import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_contact_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/view/screen/leads_list.dart';
import 'package:task_management/view/screen/meeting/get_meeting.dart';
import 'package:task_management/view/screen/meeting_screen.dart';
import 'package:task_management/view/screen/task_screen.dart';
import 'package:task_management/view/widgets/pending_box.dart';

class ShowDialogFunction {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> sosMsg(BuildContext context, eventData, DateTime dt) async {
    await _audioPlayer.play(AssetSource('mp3/emergency_alarm_69780.mp3'));
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/png/sos_image.png",
                        height: 80.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$eventData',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    await StorageHelper.setSosMessage(false);
                    Get.back();
                    await _audioPlayer.stop();
                  },
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> dailyMessage(
    BuildContext context,
    eventData,
    DateTime dt,
    title,
  ) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/gif/67d94892d4d5fd717399b48f24e2138e2f4b3458 (1).gif",
                        height: 80.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$title',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '$eventData',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    await StorageHelper.setDailyMessage(false);
                    Get.back();
                  },
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pendingDialog(
    BuildContext context,
    pendingTask,
    int pendingLeadMeeting,
    pendingTaskmeeting,
    int newLead,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/image/svg/hourglass_bottom (1).svg',
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Your Pending',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => TaskScreenPage(
                                    taskType: 'Progress',
                                    assignedType: "Assigned to me",
                                    '',
                                    '',
                                  ),
                                );
                              },
                              child: PendingBox(
                                image: totalTaskSvgIcon,
                                text: "Task",
                                data: pendingTask,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => LeadList(status: 'new lead'));
                              },
                              child: PendingBox(
                                image: pendingProjectIcon,
                                text: "Lead",
                                data: newLead,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => MeetingListScreen());
                              },
                              child: PendingBox(
                                image: pendingTodoIcon,
                                text: "Meeting",
                                data: pendingTaskmeeting,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => GetMeetingList(
                                    contactList: <LeadContactData>[].obs,
                                    from: 'home',
                                    leadId: '',
                                    addPeople: [],
                                    assignPeople: [],
                                  ),
                                );
                              },
                              child: PendingBox(
                                image: pendingMeetingIcon,
                                text: "Lead Visit",
                                data: pendingLeadMeeting,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> priorityDialog(
    BuildContext context, PriorityData? value, PriorityController priorityController,  
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xffFFF4F4),
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '⚠️ Use High Priority Wisely For urgent, business-critical tasks only.',
                        style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                     SizedBox(height: 5.h,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      GestureDetector(
                        onTap: () { 
                          Get.back();
                           priorityController.selectedPriorityData
                                                  .value = value;
                        },
                        child: Container(height: 30.h, width: 70.w,
                        decoration: BoxDecoration(
                          color: primaryButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.r),
                          ),
                          ),
                          child: Center(child: Text("Yes", style: TextStyle(
                            color: whiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500
                          ),),)
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(height: 30.h, width: 70.w,
                        decoration: BoxDecoration(
                          color: primaryButtonColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.r),
                          ),
                          ),
                          child: Center(child: Text("No", style: TextStyle(
                            color: whiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500
                          ),),)
                        ),
                      ),
                     ],
                     ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  final TextEditingController selectedDateTextController =
    TextEditingController();
  Future<void> salarySlipDialog(
    BuildContext context, AttendenceController attendenceController  
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: TextField(
                                    controller: selectedDateTextController,
                                    decoration: InputDecoration(
                                      fillColor: whiteColor,
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Image.asset(
                                          'assets/images/png/callender.png',
                                          color: secondaryColor,
                                          height: 10.h,
                                        ),
                                      ),
                                      hintText: 'yyyy-MM',
                                      hintStyle: rubikRegular,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: lightBorderColor),
                                        borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: lightBorderColor),
                                        borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: lightBorderColor),
                                        borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: secondaryColor),
                                        borderRadius: BorderRadius.all(Radius.circular(14.r)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime initialDate = DateTime.now();
                                      DateTime firstDate = DateTime(1900);  
                                      DateTime lastDate = DateTime(2200);
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: initialDate,
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      );
                                      if (pickedDate != null) {
                                        final formattedDate = DateFormat('yyyy-MM').format(pickedDate);
                                        selectedDateTextController.text = formattedDate;
                                        print('837y8e7 e3873563 ${selectedDateTextController.text}');
                                      }
                                    }
                                  ),
                                  // CustomCalender(
                                  //   hintText: dateFormate,
                                  //   controller: selectedDateTextController,
                                  //   from: 'report',
                                  // ),
                                ),
                                SizedBox(width: 15.w),
                                InkWell(
                                  onTap: () async {
                                    // await downloadReport(
                                    //   date: selectedDateTextController.text,
                                    // );
                                    attendenceController.sallarySlipDownload(selectedDateTextController.text);
                                  },
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/png/download_image.png',
                                        height: 30.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), 
                  ],
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
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
