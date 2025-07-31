// ignore_for_file: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class EditFeedEvent extends StatefulWidget {
  final dynamic feedEventList;
  const EditFeedEvent(this.feedEventList, {super.key});

  @override
  State<EditFeedEvent> createState() => _EditFeedEventState();
}

class _EditFeedEventState extends State<EditFeedEvent> {
  final FeedController feedController = Get.find();
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();
  final TextEditingController urlTextController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  final TextEditingController eventVenueController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RxList<String> timeList = <String>[
    "Minutes",
    "Hours",
  ].obs;
  RxString? selectedTime = "".obs;
  RxList<String> eventTypeList = <String>[
    "Global",
    "Personal",
  ].obs;
  RxString? selectedEventType = "".obs;
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    List<String> splitReminder =
        widget.feedEventList['reminder'].toString().split(' ');
    titleTextController.text = widget.feedEventList['title'];
    descriptionTextController.text = widget.feedEventList['description'];
    dueDateController.text = widget.feedEventList['event_date'];
    dueTimeController.text = widget.feedEventList['event_time'];
    reminderController.text = splitReminder.first;
    selectedTime?.value = splitReminder.last;
    eventVenueController.text = widget.feedEventList['event_venue'];
    eventVenueController.text = widget.feedEventList['event_venue'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Obx(
        () => taskController.isResponsiblePersonLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15.h,
                    children: [
                      SizedBox(
                        height: 0.h,
                      ),
                      Text(
                        'Add Event',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      TaskCustomTextField(
                        controller: titleTextController,
                        textCapitalization: TextCapitalization.sentences,
                        data: title,
                        hintText: title,
                        labelText: title,
                        index: 0,
                        focusedIndexNotifier: focusedIndexNotifier,
                      ),
                      TaskCustomTextField(
                        controller: descriptionTextController,
                        textCapitalization: TextCapitalization.sentences,
                        data: description,
                        hintText: description,
                        labelText: description,
                        index: 1,
                        maxLine: 4,
                        focusedIndexNotifier: focusedIndexNotifier,
                      ),
                      TaskCustomTextField(
                        controller: urlTextController,
                        textCapitalization: TextCapitalization.sentences,
                        data: addUrl,
                        hintText: addUrl,
                        labelText: addUrl,
                        index: 4,
                        focusedIndexNotifier: focusedIndexNotifier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 161.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${eventDate} *",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 3.w,
                                ),
                                CustomCalender(
                                  hintText: dateFormate,
                                  controller: dueDateController,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 161.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${eventTime} *",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 3.w,
                                ),
                                CustomTimer(
                                  hintText: timeFormate,
                                  controller: dueTimeController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TaskCustomTextField(
                                  controller: reminderController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  data: reminder,
                                  hintText: reminder,
                                  labelText: reminder,
                                  index: 2,
                                  focusedIndexNotifier: focusedIndexNotifier,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 160.w,
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: timeList.map((String item) {
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
                                  value: selectedTime!.value.isEmpty
                                      ? null
                                      : selectedTime?.value,
                                  onChanged: (String? value) {
                                    selectedTime?.value = value ?? '';
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                          color: lightSecondaryColor),
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
                                        borderRadius:
                                            BorderRadius.circular(5.r),
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
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TaskCustomTextField(
                        controller: eventVenueController,
                        textCapitalization: TextCapitalization.sentences,
                        data: eventVenue,
                        hintText: eventVenue,
                        labelText: eventVenue,
                        index: 3,
                        focusedIndexNotifier: focusedIndexNotifier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton2<ResponsiblePersonData>(
                                  isExpanded: true,
                                  items: taskController.responsiblePersonList
                                      .map((ResponsiblePersonData item) {
                                    return DropdownMenuItem<
                                        ResponsiblePersonData>(
                                      value: item,
                                      child: Text(
                                        item.name ?? "",
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
                                  value: taskController
                                              .selectedResponsiblePersonData
                                              .value ==
                                          null
                                      ? null
                                      : taskController
                                          .selectedResponsiblePersonData.value,
                                  onChanged: (ResponsiblePersonData? value) {
                                    taskController.selectedResponsiblePersonData
                                        .value = value;
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                          color: lightSecondaryColor),
                                      color: lightSecondaryColor,
                                    ),
                                  ),
                                  hint: Text(
                                    selectGuest,
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
                                        borderRadius:
                                            BorderRadius.circular(5.r),
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
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 160.w,
                          //   child: CustomDropdown<ResponsiblePersonData>(
                          //     items: taskController.responsiblePersonList,
                          //     itemLabel: (item) => item.name ?? '',
                          //     onChanged: (value) {
                          //       taskController.selectedResponsiblePersonData
                          //           .value = value;
                          //     },
                          //     hintText: selectGuest,
                          //   ),
                          // ),
                          SizedBox(
                            width: 160.w,
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: eventTypeList.map((String item) {
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
                                  value: selectedEventType!.value.isEmpty
                                      ? null
                                      : selectedEventType?.value,
                                  onChanged: (String? value) {
                                    selectedEventType?.value = value ?? '';
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                          color: lightSecondaryColor),
                                      color: lightSecondaryColor,
                                    ),
                                  ),
                                  hint: Text(
                                    'Select venue type',
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
                                        borderRadius:
                                            BorderRadius.circular(5.r),
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
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              feedController.addEvent(
                                  titleTextController.text,
                                  descriptionTextController.text,
                                  dueDateController.text,
                                  dueTimeController.text,
                                  taskController.selectedResponsiblePersonData
                                          .value?.id ??
                                      0,
                                  reminderController.text,
                                  eventVenueController.text,
                                  selectedTime?.value,
                                  selectedEventType?.value ?? '',
                                  '');
                            }
                          },
                          text: feedController.isEventAdding.value == true
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
