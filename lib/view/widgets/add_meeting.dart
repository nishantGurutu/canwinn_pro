import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/meeting_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class AddMeeting extends StatefulWidget {
  const AddMeeting({super.key});

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final MeetingController meetingController = Get.put(MeetingController());
  final TaskController taskController = Get.find();
  final ProfileController profileController = Get.find();
  final TextEditingController reminderController = TextEditingController();
  final TextEditingController meetingTitleController = TextEditingController();
  final TextEditingController meetingVenueController = TextEditingController();
  final TextEditingController meetingDateController = TextEditingController();
  final TextEditingController meetingTimeController = TextEditingController();
  final TextEditingController meetingEndTimeController = TextEditingController();
  final TextEditingController meetingLinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  final controller = MultiSelectController<ResponsiblePersonData>();
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.departmentList(0);
    });
    meetingController.responsiblePersonListApi(0, "");
    profileController.selectedDepartMentListData.value = null;
    taskController.selectedResponsiblePersonData.value = null;
  }

  @override
  dispose() {
    super.dispose();
    meetingController.selectedMeetingType.value = '';
    meetingController.selectdePersonIds.clear();
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
          addMeeting,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => profileController.isdepartmentListLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton2<DepartmentListData>(
                              isExpanded: true,
                              hint: Text(
                                'Select Department',
                                style: changeTextColor(
                                    rubikRegular, darkGreyColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              items: profileController.departmentDataList
                                  .map(
                                    (DepartmentListData item) =>
                                        DropdownMenuItem<DepartmentListData>(
                                      value: item,
                                      child: Text(
                                        item.name ?? '',
                                        style: changeTextColor(
                                            rubikRegular, Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: profileController
                                  .selectedDepartMentListData.value,
                              onChanged: (DepartmentListData? value) {
                                profileController
                                    .selectedDepartMentListData.value = value;
                                taskController.responsiblePersonListApi(
                                    value?.id, "");
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 42.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: lightBorderColor),
                                  color: whiteColor,
                                ),
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
                                width: 325.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: whiteColor,
                                  border: Border.all(color: lightBorderColor),
                                ),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: Radius.circular(40.r),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40.h,
                                padding:
                                    EdgeInsets.only(left: 14.w, right: 14.w),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Select person',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              "Select all person",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Obx(
                              () => Checkbox(
                                value:
                                    meetingController.isAllUserSelecting.value,
                                onChanged: (value) {
                                  if (profileController
                                          .selectedDepartMentListData.value !=
                                      null) {
                                    meetingController.isAllUserSelecting.value =
                                        value!;
                                    if (value == true) {
                                      meetingController.selectdePersonIds
                                          .assignAll(taskController
                                              .responsiblePersonList);
                                    } else {
                                      meetingController.selectdePersonIds
                                          .clear();
                                    }
                                  } else {
                                    CustomToast()
                                        .showCustomToast('Select department');
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: lightBorderColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.r)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.r)),
                            child: Obx(
                              () => MultiDropdown<ResponsiblePersonData>(
                                items: meetingController.responsiblePersonList
                                    .map((item) =>
                                        DropdownItem<ResponsiblePersonData>(
                                          value: item,
                                          label: item.name ?? '',
                                        ))
                                    .toList(),
                                controller: controller,
                                enabled: true,
                                searchEnabled: true,
                                chipDecoration: ChipDecoration(
                                  backgroundColor: Colors.white,
                                  wrap: true,
                                  runSpacing: 2,
                                  spacing: 10,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14.r)),
                                ),
                                fieldDecoration: FieldDecoration(
                                  borderRadius: BorderSide.strokeAlignCenter,
                                  hintText: selectPerson,
                                  hintStyle:
                                      const TextStyle(color: Colors.black87),
                                  backgroundColor: Colors.white,
                                  showClearIcon: false,
                                  border: InputBorder.none,
                                ),
                                dropdownDecoration: DropdownDecoration(
                                  marginTop: 2,
                                  maxHeight: 500,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14.r)),
                                  header: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Select from list',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                dropdownItemDecoration: DropdownItemDecoration(
                                  selectedIcon: Icon(Icons.check_box,
                                      color: Colors.green),
                                  disabledIcon: Icon(Icons.lock,
                                      color: Colors.grey.shade300),
                                ),
                                onSelectionChange: (selectedItems) {
                                  meetingController.selectdePersonIds
                                      .assignAll(selectedItems);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Meeting title',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: meetingTitleController,
                          textCapitalization: TextCapitalization.sentences,
                          data: meetingTitle,
                          hintText: meetingTitle,
                          labelText: meetingTitle,
                          index: 0,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Meeting venue',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: meetingVenueController,
                          textCapitalization: TextCapitalization.sentences,
                          data: meetingVenue,
                          hintText: meetingVenue,
                          labelText: meetingVenue,
                          index: 1,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              'Meeting link',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TaskCustomTextField(
                              controller: meetingLinkController,
                              textCapitalization: TextCapitalization.sentences,
                              data: meetingUrl,
                              hintText: meetingUrl,
                              labelText: meetingUrl,
                              index: 2,
                              focusedIndexNotifier: focusedIndexNotifier,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Meeting date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomCalender(
                          hintText: dateFormate,
                          controller: meetingDateController,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Start time',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Expanded(
                                  child: Text(
                                    'End time',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTimer(
                                    hintText: timeFormate,
                                    controller: meetingTimeController,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Expanded(
                                  child: CustomTimer(
                                    hintText: timeFormate,
                                    controller: meetingEndTimeController,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 160.w,
                                  child: TaskCustomTextField(
                                    controller: reminderController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    data: meetingUrl,
                                    hintText: alertTime,
                                    labelText: alertTime,
                                    index: 3,
                                    focusedIndexNotifier: focusedIndexNotifier,
                                  ),
                                ),
                                SizedBox(
                                  width: 160.w,
                                  child: Obx(
                                    () => DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        items: meetingController.alertTimeType
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
                                        value: meetingController
                                                .selectedTimeType.value.isEmpty
                                            ? null
                                            : meetingController
                                                .selectedTimeType.value,
                                        onChanged: (String? value) {
                                          meetingController.selectedTimeType
                                              .value = value ?? '';
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14.r),
                                            border: Border.all(
                                                color: lightBorderColor),
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
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: lightBorderColor)),
                                          offset: const Offset(0, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                WidgetStateProperty.all<double>(
                                                    6),
                                            thumbVisibility:
                                                WidgetStateProperty.all<bool>(
                                                    true),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                          padding: EdgeInsets.only(
                                              left: 14, right: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            if (meetingController.isMeetingAdding.value ==
                                false) {
                              String reminderText =
                                  "${reminderController.text} ${meetingController.selectedTimeType}";
                              meetingController.addMeeting(
                                deptId: profileController
                                    .selectedDepartMentListData.value?.id,
                                userIds: taskController
                                    .selectedResponsiblePersonData.value,
                                meetingTitle: meetingTitleController.text,
                                meetingVinue: meetingVenueController.text,
                                meetingLink: meetingLinkController.text,
                                meetingDate: meetingDateController.text,
                                meetingTime: meetingTimeController.text,
                                meetingEndTime: meetingEndTimeController.text,
                                reminder: reminderText,
                              );
                            }
                          },
                          text: Text(
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
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
