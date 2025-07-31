// ignore_for_file: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final FeedController feedController = Get.find();
  final TaskController taskController = Get.find();
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
            : SingleChildScrollView(
                child: Padding(
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
                        TaskCustomTextField(
                          controller: eventVenueController,
                          textCapitalization: TextCapitalization.sentences,
                          data: eventVenue,
                          hintText: eventVenue,
                          labelText: eventVenue,
                          index: 3,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: lightSecondaryColor),
                            color: lightSecondaryColor,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          child: MultiDropdown<ResponsiblePersonData>(
                            items: taskController.responsiblePersonList
                                .map((person) =>
                                    DropdownItem<ResponsiblePersonData>(
                                      value: person,
                                      label: person.name,
                                    ))
                                .toList(),
                            enabled: true,
                            searchEnabled: true,
                            fieldDecoration: FieldDecoration(
                              hintText: 'Guest',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(left: 26.w),
                                child: SizedBox(
                                  width: 5.w,
                                  child: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: secondaryColor,
                                    height: 2.h,
                                    width: 8.w,
                                  ),
                                ),
                              ),
                              // showClearIcon: false,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            dropdownDecoration: DropdownDecoration(
                              marginTop: 2,
                              maxHeight: 500,
                              header: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  selectGuest,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                            dropdownItemDecoration: DropdownItemDecoration(
                              selectedIcon: const Icon(Icons.check_box,
                                  color: Colors.green),
                              disabledIcon:
                                  Icon(Icons.lock, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return selectGuest;
                              }
                              return null;
                            },
                            onSelectionChange: (selectedItems) {
                              feedController.selectedGuest.clear();
                              feedController.selectedGuest
                                  .assignAll(selectedItems);
                            },
                          ),
                        ),
                        Obx(
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
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border:
                                      Border.all(color: lightSecondaryColor),
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
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: lightSecondaryColor,
                                    border:
                                        Border.all(color: lightSecondaryColor)),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
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
                        Obx(
                          () => CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (feedController.isEventAdding.value ==
                                    false) {
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
                                    urlTextController.text ?? "",
                                  );
                                  isLoading.value = true;
                                  Future.delayed(Duration(seconds: 2)).then(
                                    (value) => calllingAddevent(),
                                  );
                                }
                              }
                            },
                            text: isLoading.value == true
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
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  RxBool isLoading = false.obs;
  void calllingAddevent() {
    Get.back();
    CustomToast()
        .showCustomToast("Event added! Can't wait to see everyone there!");
    isLoading.value = false;
  }
}
