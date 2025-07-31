import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/model/meeting_attendence_model.dart';
import 'package:task_management/model/meeting_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/service/meeting_service.dart';
import 'package:task_management/view/widgets/attendent_user_botomsheet.dart';
import 'package:task_management/view/widgets/video_call_page.dart';

class MeetingController extends GetxController {
  var isMeetingAdding = false.obs;
  var isAllUserSelecting = false.obs;
  var isUpcomingSelected = true.obs;
  var isOngoingSelected = false.obs;
  var isDoneSelected = false.obs;
  RxList<ResponsiblePersonData> selectdePersonIds =
      <ResponsiblePersonData>[].obs;

  RxList<String> alertTimeType = <String>["Minutes", "Hours"].obs;
  RxString selectedTimeType = "".obs;
  RxList<String> meetingType = <String>["Meeting Link", "In App"].obs;
  RxString selectedMeetingType = "".obs;

  Future<void> addMeeting(
      {int? deptId,
      required userIds,
      required String meetingTitle,
      required String meetingVinue,
      required String meetingLink,
      required String meetingDate,
      required String meetingTime,
      required String meetingEndTime,
      required String reminder}) async {
    isMeetingAdding.value = true;
    final result = await MeetingService().addMeeting(
      deptId,
      selectdePersonIds,
      meetingTitle,
      meetingVinue,
      meetingLink,
      meetingDate,
      meetingTime,
      meetingEndTime,
      reminder,
    );
    if (result) {
      await meetingList();
      Get.back();
    }
    isMeetingAdding.value = false;
  }

  RxList<UpcomingMeeting> upcommingMeetingData = <UpcomingMeeting>[].obs;
  RxList<DoneMeeting> doneMeetingData = <DoneMeeting>[].obs;
  RxList<OngoingMeeting> ongoingMeetingData = <OngoingMeeting>[].obs;
  var isMeetingLoading = false.obs;

  Future<void> meetingList() async {
    isMeetingLoading.value = true;
    final result = await MeetingService().meetingList();
    if (result != null) {
      upcommingMeetingData.assignAll(result.upcoming!);
      doneMeetingData.assignAll(result.done!);
      ongoingMeetingData.assignAll(result.ongoing!);
      isMeetingLoading.value = false;

      if (upcommingMeetingData.isNotEmpty) {
        for (var dt in upcommingMeetingData) {
          String dateInput = "${dt.meetingDate} ${dt.meetingTime}";
          print('Date input format in profile: $dateInput');

          DateTime? dateTime;
          try {
            DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
            dateTime = inputFormat.parse(dateInput.toLowerCase());
          } catch (e) {
            print("Error parsing with lowercase AM/PM: $e");
          }

          if (dateTime == null) {
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
              dateTime = inputFormat.parse(dateInput.toUpperCase());
            } catch (e) {
              print("Error parsing with uppercase AM/PM: $e");
            }
          }

          if (dateTime != null) {
            DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm", 'en_US');
            String dateOutput = outputFormat.format(dateTime);

            List<String> splitDt = dateOutput.split(" ");
            List<String> splitDt2 = splitDt.first.split('-');
            List<String> splitDt3 = splitDt[1].split(':');

            String strReminder = "${dt.reminder}";
            int minute = int.parse(splitDt3.last);
            int hour = int.parse(splitDt3.first);
            print('kudh83ni3u9 3iu ${strReminder}');
            if (strReminder != "null") {
              List<String> splitReminder = strReminder.split(" ");
              int reminderTime = int.parse(splitReminder.first);
              String reminderTimeType = splitReminder.last.toLowerCase();

              if (reminderTimeType == 'minutes') {
                minute -= reminderTime;
              } else if (reminderTimeType == 'hours') {
                hour -= reminderTime;
              }
            }

            DateTime dtNow = DateTime.now();
            DateTime targetDate = DateTime(
              int.parse(splitDt2.last),
              int.parse(splitDt2[1]),
              int.parse(splitDt2.first),
              hour,
              minute,
              0,
            );
            if (dt.reminder != null && dt.reminder is int) {
              targetDate = targetDate.subtract(
                  Duration(minutes: int.parse(dt.reminder.toString())));
            }
            if (targetDate.isAfter(dtNow)) {
              final notificationId =
                  DateTime.now().millisecondsSinceEpoch % 100000;

              LocalNotificationService().scheduleNotification(
                targetDate,
                dt.id ?? 0,
                dt.title ?? "",
                'meeting',
              );
            }
          }
        }
      }
    } else {}
    isMeetingLoading.value = false;
  }

  var isAttendStatusUpdating = false.obs;

  Future<void> attendMeeting(BuildContext context,
      {int? meetingId, required int status}) async {
    isAttendStatusUpdating.value = true;
    final result = await MeetingService().attendMeeting(meetingId, status);
    await meetingList();

    isAttendStatusUpdating.value = false;
    isAttendStatusUpdating.value = false;
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController momController = TextEditingController();

  Future<void> showAlertDialog(
    BuildContext context,
    int? meetingId,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 230.h,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskCustomTextField(
                          controller: momController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'mom',
                          hintText: 'Enter MoM',
                          labelText: 'Enter MoM',
                          maxLine: 5,
                          index: 1,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            if (isMomLoading.value == false) {
                              meetingMom(momController.text, meetingId);
                            }
                          },
                          text: Text(
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
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 2.w,
                child: SizedBox(
                  height: 20.h,
                  width: 35.w,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  var isMeetingTokenLoading = false.obs;

  Future<void> meetingToken({int? meetingId}) async {
    try {
      isMeetingTokenLoading.value = true;

      final result = await MeetingService().meetingToken();

      if (result != null && result.data != null) {
        // Get.to(() =>
        // ZegoUIKitPrebuiltCall(token: result.data!, meetingId: meetingId));
        // Get.to(() => JoinPage(token: result.data!, meetingId: meetingId));
      } else {
        Get.snackbar("Error", "Failed to get meeting token");
      }
    } catch (e) {
      print("Token API Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isMeetingTokenLoading.value = false;
    }
  }

  var isMomLoading = false.obs;

  Future<void> meetingMom(String description, int? meetingId) async {
    try {
      isMomLoading.value = true;

      final result = await MeetingService().meetingMom(meetingId, description);

      isMomLoading.value = false;
      Get.back();
    } catch (e) {
      print("Token API Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isMomLoading.value = false;
    }
  }

  var isAttendenceLoading = false.obs;

  RxList<Attendees> attendeesList = <Attendees>[].obs;

  Future<void> meetingAttendence(BuildContext context, int? meetingId) async {
    try {
      isAttendenceLoading.value = true;

      final result = await MeetingService().meetingAttendence(meetingId);

      if (result != null) {
        isAttendenceLoading.value = false;
        attendeesList.assignAll(result.attendees!);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AttendentUserBotomsheet(attendeesList),
          ),
        );
      } else {
        Get.snackbar("Error", "Failed to get meeting token");
      }
    } catch (e) {
      print("Token API Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isAttendenceLoading.value = false;
    }
  }

  RxList<ResponsiblePersonData> responsiblePersonList =
      <ResponsiblePersonData>[].obs;
  Rx<ResponsiblePersonData?> selectedResponsiblePersonData =
      Rx<ResponsiblePersonData?>(null);
  var isResponsiblePersonLoading = false.obs;

  Future<void> responsiblePersonListApi(dynamic id, String fromPage) async {
    isResponsiblePersonLoading.value = true;

    try {
      final result = await MeetingService().responsiblePersonListApi();

      if (result != null && result.data != null) {
        responsiblePersonList.assignAll(result.data!);
        // await DbHelper().inserResponsiblePerson(result.data!);
      } else {
        responsiblePersonList.clear();
        print("⚠️ No data returned from API.");
      }
    } catch (e) {
      print("❌ Error fetching responsible persons: $e");
    } finally {
      isResponsiblePersonLoading.value = false;
    }
  }

  // Future<void> loadResponsiblePersonsFromDb() async {
  //   try {
  //     final data = await DbHelper().getResponsiblePersondata();
  //     responsiblePersonList.assignAll(data);
  //     print(
  //         "x3s43434s Fetched ${responsiblePersonList.length} responsible persons from local DB.");
  //   } catch (e) {
  //     print("❌ Error loading responsible persons from DB: $e");
  //   }
  // }
}

//   var responsiblePersonListModel = ResponsiblePersonListModel().obs;
//   Rx<ResponsiblePersonData?> selectedResponsiblePersonData = Rx<ResponsiblePersonData?>(null);
//   var isResponsiblePersonLoading = false.obs;
//   Future<void> responsiblePersonListApi(dynamic id, String fromPage) async {
//     Future.microtask(() {
//       isResponsiblePersonLoading.value = true;
//     });
//     final result = await MeetingService().responsiblePersonListApi();
//     if (result != null) {
//       responsiblePersonList.assignAll(result.data!);
//       isResponsiblePersonLoading.value = false;
//       print("length:---${responsiblePersonList.length}");
//     } else {}
//     Future.microtask(() {
//       isResponsiblePersonLoading.value = false;
//     });
//   }
// }
