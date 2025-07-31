import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/followups_type_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class UpdateFollowUpsScreen extends StatefulWidget {
  final dynamic leadId;
  // final String? phoneNumber;
  const UpdateFollowUpsScreen({
    super.key,
    required this.leadId,
  });

  @override
  State<UpdateFollowUpsScreen> createState() => _UpdateFollowUpsScreenState();
}

class _UpdateFollowUpsScreenState extends State<UpdateFollowUpsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final LeadController leadController = Get.put(LeadController());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  @override
  void initState() {
    Future.microtask(() {
      leadController.selectedFollowUpsTypeListData.value = null;
      leadController.selectedLeadStatusData.value = null;
      leadController.followUpsTypeListApi(leadId: widget.leadId);
      leadController.statusListApi(status: '');
    });
    super.initState();
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
          "Reshedule Followup",
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
                Text(
                  "Follow ups types",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<FollowUpsTypeData>(
                      isExpanded: true,
                      items: leadController.followUpsTypeListData.isEmpty
                          ? null
                          : leadController.followUpsTypeListData
                              .map((FollowUpsTypeData item) {
                              return DropdownMenuItem<FollowUpsTypeData>(
                                value: item,
                                child: Text(
                                  item.name ?? '',
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
                      value: leadController.selectedFollowUpsTypeListData.value,
                      onChanged: (FollowUpsTypeData? value) {
                        if (value != null) {
                          leadController.selectedFollowUpsTypeListData.value =
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
                        "Select Followups".tr,
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
                        width: 330.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            color: whiteColor,
                            border: Border.all(color: lightBorderColor)),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all<double>(6),
                          thumbVisibility: WidgetStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Follow ups date",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                CustomCalender(
                  hintText: 'Followups date',
                  controller: dateController,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Follow ups time",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                CustomTimer(
                  hintText: "Followups time",
                  controller: timeController,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Note",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TaskCustomTextField(
                  controller: noteController,
                  textCapitalization: TextCapitalization.sentences,
                  data: notes,
                  hintText: notes,
                  labelText: notes,
                  index: 6,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                SizedBox(
                  height: 15.h,
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
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  onPressed: () {
                    String rem =
                        "${timeTextEditingController.text} ${leadController.selectedTime?.value}";
                    if (_formKey.currentState!.validate()) {
                      leadController.addFollowup(
                        followupsType: leadController
                                .selectedFollowUpsTypeListData.value?.id
                                .toString() ??
                            "",
                        followupsDate: dateController.text,
                        followupsTime: timeController.text,
                        note: noteController.text,
                        status: leadController.selectedLeadStatusData.value?.id,
                        leadId: widget.leadId,
                        reminder: rem,
                      );
                    }
                  },
                  text: Text(
                    "Reshedule",
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
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
