// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/calender_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/callender_eventList_model.dart';
import 'package:task_management/view/screen/event_details.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class CalendarScreen extends StatefulWidget {
  final String? navigationType;
  const CalendarScreen(this.navigationType, {super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenScreenState();
}

class _CalendarScreenScreenState extends State<CalendarScreen> {
  final CalenderController calenderController = Get.find();
  // final CalenderController calenderController = Get.put(CalenderController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addEventToGoogleCalendar() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.EDIT',
        type: 'vnd.android.cursor.item/event',
        data: 'content://com.android.calendar/events',
        arguments: {
          'title': 'Test Title',
          'beginTime': "10-04-2025",
          'endTime': "10-04-2025",
          'allDay': false,
        },
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      try {
        await intent.launch();
        // After launching, fetch events (you may want to delay or trigger this manually)
        await Future.delayed(Duration(seconds: 5)); // Wait for user to return
        // await _fetchAndSaveEvents();
      } catch (e) {
        print('Error launching Google Calendar: $e');
      }
    } else {
      print('Calendar event creation not supported on this platform');
      // For iOS, use the Google Calendar API directly
      // await _fetchAndSaveEvents();
    }
  }

  // Future<void> _fetchAndSaveEvents() async {
  //   if (_authClient == null) {
  //     print('Not authenticated');
  //     return;
  //   }
  //   final calendarApi = CalendarApi(_authClient!);
  //   try {
  //     final events = await calendarApi.events.list(
  //       'primary',
  //       timeMin: DateTime.now().subtract(Duration(days: 1)),
  //       timeMax: DateTime.now().add(Duration(days: 30)),
  //     );
  //     final db = await _initDatabase();
  //     for (var event in events.items ?? []) {
  //       final title = event.summary ?? 'No Title';
  //       final startTime = event.start?.dateTime ?? event.start?.date;
  //       final endTime = event.end?.dateTime ?? event.end?.date;
  //       if (startTime != null && endTime != null) {
  //         await db.insert(
  //           'events',
  //           {
  //             'title': title,
  //             'start_time': startTime.toIso8601String(),
  //             'end_time': endTime.toIso8601String(),
  //           },
  //           conflictAlgorithm: ConflictAlgorithm.replace,
  //         );
  //       }
  //     }
  //     print('Events saved to database');
  //   } catch (e) {
  //     print('Error fetching events: $e');
  //   }
  // }

  bool _isBackButtonPressed = false;
  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      if (widget.navigationType == "notification") {
        Get.offAll(() => SplashScreen());
      } else {
        Get.back();
      }
      return true;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (widget.navigationType == "notification") {
                Get.offAll(() => SplashScreen());
              } else {
                Get.back();
              }
            },
            icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
          ),
          title: Text(
            calendar,
            style: TextStyle(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: whiteColor,
        body: Obx(
          () => calenderController.isCalenderLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CalendarControllerProvider(
                  controller: EventController()
                    ..addAll(
                      calenderController.eventsList.map(
                        (event) {
                          String dateInput =
                              "${event.eventDate} ${event.eventTime}";
                          List<String> splitDt = dateInput.split(" ");
                          List<String> splitDt2 = splitDt.first.split('-');
                          List<String> splitDt3 = splitDt[1].split(':');
                          DateTime targetDate = DateTime(
                            int.parse(splitDt2.last),
                            int.parse(splitDt2[1]),
                            int.parse(splitDt2.first),
                            int.parse(splitDt3.first),
                            int.parse(splitDt3.last),
                            0,
                          );
                          return CalendarEventData<Object?>(
                            date: targetDate,
                            title: event.eventName ?? "",
                            description: event.eventName ?? "",
                          );
                        },
                      ).toList(),
                    ),
                  child: MonthView(
                    onEventTap: (event, date) {
                      Get.to(() => EventDetails(
                            eventName: event.title,
                            eventList: calenderController.eventsList,
                            event: event,
                          ));
                    },
                    onCellTap: (events, date) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(date);
                      eventDateController.text = formattedDate.toString();
                      showAlertDialog(context);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController reminderTimeController = TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      createEvent,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TaskCustomTextField(
                      controller: eventNameController,
                      textCapitalization: TextCapitalization.sentences,
                      data: eventName,
                      hintText: eventName,
                      labelText: eventName,
                      index: 0,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: CustomCalender(
                            hintText: eventDate,
                            controller: eventDateController,
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                          child: CustomTimer(
                            controller: eventTimeController,
                            hintText: eventTime,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: CustomTextField(
                            controller: reminderTimeController,
                            textCapitalization: TextCapitalization.none,
                            hintText: alarmReminder,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icon(Icons.lock_clock),
                            data: alarmReminder,
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                          child: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: calenderController.timeList
                                    .map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Roboto',
                                        color: darkGreyColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                value: calenderController
                                        .selectedTime!.value.isEmpty
                                    ? null
                                    : calenderController.selectedTime?.value,
                                onChanged: (String? value) {
                                  calenderController.selectedTime?.value =
                                      value ?? '';
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border:
                                        Border.all(color: lightSecondaryColor),
                                    color: lightSecondaryColor,
                                  ),
                                ),
                                hint: Text(
                                  'Select type',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: secondaryColor,
                                    height: 8.h,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: lightGreyColor,
                                  iconDisabledColor: lightGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 330,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: lightSecondaryColor,
                                      border: Border.all(
                                          color: lightSecondaryColor)),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (calenderController.isEventAdding.value == false) {
                            calenderController.addEventApi(
                              eventNameController.text,
                              eventDateController.text,
                              eventTimeController.text,
                              reminderTimeController.text,
                              calenderController.selectedTime?.value,
                            );
                          }
                        },
                        text: calenderController.isEventAdding.value == true
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
                                create,
                                style: TextStyle(color: whiteColor),
                              ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget eventListWidhet(RxList<CallenderEventData> eventsList) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${eventsList[index].eventName}",
                              style: changeTextColor(rubikBold, textColor),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "${eventsList[index].eventDate}",
                              style: changeTextColor(rubikBold, textColor),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Text(
                                  "${eventsList[index].eventTime}",
                                  style: changeTextColor(rubikBold, textColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3.h,
                      right: 5.w,
                      child: SizedBox(
                        height: 30.h,
                        width: 25.w,
                        child: PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                break;
                              case 'delete':
                                calenderController
                                    .deleteEvent(eventsList[index].id);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/images/png/edit-icon.png",
                                  height: 20.h,
                                ),
                                title: Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/png/delete-icon.png',
                                  height: 20.h,
                                ),
                                title: Text(
                                  'Delete',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(),
        itemCount: eventsList.length,
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(RxList<CallenderEventData> eventList) {
    appointments = eventList
        .map((event) {
          final dateParts = event.eventDate?.split('-') ?? [];
          if (dateParts.length == 3) {
            try {
              final parsedDate = DateTime(
                int.parse(dateParts[2]),
                int.parse(dateParts[1]),
                int.parse(dateParts[0]),
              );
              return Appointment(
                startTime: parsedDate,
                endTime: parsedDate.add(Duration(hours: 1)),
                subject: event.eventName ?? "",
                color: secondaryColor,
              );
            } catch (e) {
              print('Error parsing date: $e');
              return null;
            }
          }
          return null;
        })
        .where((appointment) => appointment != null)
        .toList();
  }
}

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
