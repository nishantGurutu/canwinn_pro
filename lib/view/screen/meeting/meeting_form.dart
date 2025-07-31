import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/lead_details_model.dart';
import '../../../controller/meeting_controller.dart';
import '../../../controller/metting_controller/metting_controller.dart';
import '../../../data/model/visit_type_list.dart';

class MeetingScreens extends StatefulWidget {
  final dynamic leadId;
  final List<AssignedToUsers> mergedPeopleList;

  const MeetingScreens({
    super.key,
    this.leadId,
    required this.mergedPeopleList,
  });

  @override
  State<MeetingScreens> createState() => _MeetingScreensState();
}

class _MeetingScreensState extends State<MeetingScreens> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> meetingControllerNotifier = ValueNotifier<int?>(null);

  final TextEditingController meetingTitleController = TextEditingController();
  final TextEditingController meetingDateController = TextEditingController();
  final TextEditingController meetingTimeController = TextEditingController();
  final TextEditingController meetingVenueController = TextEditingController();
  final TextEditingController attendPersonController = TextEditingController();
  final TextEditingController meetingLinkController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  final LeadController leadController = Get.put(LeadController());
  final LeadMeetingController leadMeetingController =
      Get.put(LeadMeetingController());

  final MultiSelectController<AssignedToUsers> controller =
      MultiSelectController<AssignedToUsers>();
  final MeetingController meetingController = Get.put(MeetingController());

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      leadController.leadContactList(leadId: widget.leadId);
      leadController.listVisitTypeApi();
      meetingController.selectedMeetingType.value = '';
      leadController.selectedVisitTypeListData.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF000000),
            size: 20,
          ),
        ),
        title: const Text(
          "Create Visit/Meeting",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Title"),
                TaskCustomTextField(
                  controller: meetingTitleController,
                  textCapitalization: TextCapitalization.sentences,
                  data: 'title',
                  hintText: 'title',
                  labelText: 'title',
                  index: 4,
                  focusedIndexNotifier: meetingControllerNotifier,
                ),
                SizedBox(height: 10.h),
                _buildLabel('Select Type'),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<VisitTypeData>(
                      isExpanded: true,
                      items: leadController.leadVisitTypeListData
                          .map((VisitTypeData item) {
                        return DropdownMenuItem<VisitTypeData>(
                          value: item,
                          child: Text(
                            item.name ?? 'Unnamed',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: darkGreyColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      value: leadController.selectedVisitTypeListData.value,
                      onChanged: (VisitTypeData? value) {
                        if (value != null) {
                          leadController.selectedVisitTypeListData.value =
                              value;
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: lightBorderColor),
                          color: whiteColor,
                        ),
                      ),
                      hint: Text(
                        "Select visit type".tr,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: darkGreyColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      iconStyleData: IconStyleData(
                        icon:
                            Icon(Icons.arrow_drop_down, color: secondaryColor),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200.h,
                        width: 330.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          color: whiteColor,
                          border: Border.all(color: lightBorderColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _buildLabel("Date"),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: TaskCustomTextField(
                      controller: meetingDateController,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.none,
                      data: 'date',
                      hintText: 'dd-MM-yyyy',
                      labelText: 'date',
                      index: 1,
                      focusedIndexNotifier: meetingControllerNotifier,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _buildLabel("Time"),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: IgnorePointer(
                    child: TaskCustomTextField(
                      controller: meetingTimeController,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.none,
                      data: 'Time',
                      hintText: 'hh:mm AM/PM',
                      labelText: 'time',
                      index: 2,
                      focusedIndexNotifier: meetingControllerNotifier,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _buildLabel("Venue"),
                TaskCustomTextField(
                  controller: meetingVenueController,
                  textCapitalization: TextCapitalization.sentences,
                  data: 'venue',
                  hintText: 'venue',
                  labelText: 'venue',
                  index: 3,
                  focusedIndexNotifier: meetingControllerNotifier,
                ),
                SizedBox(height: 10.h),
                _buildLabel("Attend Person"),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: lightBorderColor),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: MultiDropdown<AssignedToUsers>(
                        controller: controller,
                        items: widget.mergedPeopleList
                            .map((item) => DropdownItem<AssignedToUsers>(
                                  value: item,
                                  label: item.name ?? 'Unnamed',
                                ))
                            .toList(),
                        onSelectionChange: (selectedItems) {
                          leadController.selectedMergeContactData
                              .assignAll(selectedItems);
                        },
                        searchEnabled: true,
                        enabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor: Colors.white,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Select responsible persons',
                          hintStyle: const TextStyle(color: Colors.black87),
                          backgroundColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        dropdownDecoration: DropdownDecoration(
                          marginTop: 2,
                          maxHeight: 500,
                          borderRadius: BorderRadius.circular(14.r),
                          header: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Select from list',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        dropdownItemDecoration: DropdownItemDecoration(
                          selectedIcon:
                              const Icon(Icons.check_box, color: Colors.green),
                          disabledIcon: Icon(Icons.lock, color: Colors.grey),
                        ),
                      )),
                ),
                Obx(() {
                  return leadController.selectedVisitTypeListData.value?.name
                              ?.toLowerCase() ==
                          "meeting"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            _buildLabel("Meeting Link"),
                            SizedBox(
                              height: 5.h,
                            ),
                            TaskCustomTextField(
                              controller: meetingLinkController,
                              textCapitalization: TextCapitalization.words,
                              data: 'Meeting Link',
                              hintText: 'meeting_link',
                              labelText: 'meeting_link',
                              index: 4,
                              focusedIndexNotifier: meetingControllerNotifier,
                            ),
                          ],
                        )
                      : SizedBox();
                }),
                SizedBox(
                  height: 10.h,
                ),
                _buildLabel("Reminder "),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: CustomTextField(
                        controller: timeTextEditingController,
                        textCapitalization: TextCapitalization.none,
                        hintText: alarmReminder,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.lock_clock),
                        data: alarmReminder,
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: leadController.timeList.map((String item) {
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
                            value: leadController.selectedTime!.value.isEmpty
                                ? null
                                : leadController.selectedTime?.value,
                            onChanged: (String? value) {
                              leadController.selectedTime?.value = value ?? '';
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50.h,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 14.w, right: 14.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: lightBorderColor),
                                color: whiteColor,
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
                              maxHeight: 200.h,
                              width: 160.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: whiteColor,
                                  border: Border.all(color: lightBorderColor)),
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
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        List<String> selectedPersonIds = meetingController
                            .selectdePersonIds
                            .map((e) => e.id.toString())
                            .toList();
                        String rem =
                            "${timeTextEditingController.text} ${leadController.selectedTime!.value}";
                        print(
                            "meeting time kajud98eu9 ${meetingTimeController.text}");
                        final visitType =
                            leadController.selectedVisitTypeListData.value?.id;
                        if (leadMeetingController.isAdding.value == false) {
                          leadMeetingController.createLeadMeeting(
                            leadId: widget.leadId?.toString() ?? "",
                            meetingTitle: meetingTitleController.text.trim(),
                            meetingDate: meetingDateController.text.trim(),
                            meetingTime: meetingTimeController.text.trim(),
                            meetingVenue: meetingVenueController.text.trim(),
                            attendPersons: selectedPersonIds,
                            visitType: visitType.toString(),
                            meetingLink: meetingLinkController.text.trim(),
                            reminder: rem,
                          );
                        }
                      }
                    },
                    text: leadMeetingController.isAdding.value == true
                        ? Row(
                            children: [
                              CircularProgressIndicator(color: whiteColor),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                "Loading...",
                                style: TextStyle(
                                    fontSize: 13.sp, color: whiteColor),
                              )
                            ],
                          )
                        : Text(
                            creates,
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 14.sp));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      meetingDateController.text = formattedDate;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? "AM" : "PM";
      final formattedTime = "$hour:$minute $period";
      meetingTimeController.text = formattedTime;
    }
  }
}
