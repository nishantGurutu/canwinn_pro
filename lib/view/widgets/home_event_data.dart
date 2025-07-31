import 'package:calendar_view/calendar_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/calender_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/view/screen/event_details.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/home_title.dart';

class HomeEventSummary extends StatefulWidget {
  const HomeEventSummary({
    Key? key,
  }) : super(key: key);

  @override
  _HomeEventSummaryState createState() => _HomeEventSummaryState();
}

class _HomeEventSummaryState extends State<HomeEventSummary> {
  final CalenderController calenderController = Get.put(CalenderController());
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => calenderController.eventListApi());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeTitle(eventSumary),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Obx(
            () => calenderController.isCalenderLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 400.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: boxBorderColor),
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: lightGreyColor.withOpacity(0.1),
                          blurRadius: 13.0,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CalendarControllerProvider(
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
        ],
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
}
