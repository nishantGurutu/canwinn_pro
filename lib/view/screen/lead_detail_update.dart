import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/followups_type_list_model.dart';
import 'package:task_management/model/lead_list_model.dart';
import 'package:task_management/model/lead_status_lead.dart';
import 'package:task_management/model/source_list_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class LeadDetailUpdate extends StatefulWidget {
  final dynamic leadId;
  final LeadListData leadDetails;
  const LeadDetailUpdate(
      {super.key, required this.leadId, required this.leadDetails});

  @override
  State<LeadDetailUpdate> createState() => _LeadDetailUpdateState();
}

class _LeadDetailUpdateState extends State<LeadDetailUpdate> {
  final LeadController leadController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController leadNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController noofprojectController = TextEditingController();
  final TextEditingController regionalOfficeController =
      TextEditingController();
  final TextEditingController refdetailsController = TextEditingController();
  final TextEditingController descrioptionController = TextEditingController();
  final TextEditingController siteaddressController = TextEditingController();
  final TextEditingController officeaddressController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      leadController.selectedSourceListData.value = null;
      leadController.selectedLeadStatusData.value = null;
    });

    super.initState();
    Future.microtask(() {
      apiCalling();
    });
  }

  var isLoading = false.obs;
  void apiCalling() async {
    isLoading.value = true;
    await leadController.leadDetailsApi(leadId: widget.leadId);
    await leadController.followUpsTypeListApi(leadId: widget.leadId);
    await leadController.statusListApi(status: '');
    leadNameController.text = widget.leadDetails.leadName ?? "";
    companyNameController.text = widget.leadDetails.company ?? "";
    phoneController.text = widget.leadDetails.phone ?? "";
    emailController.text = widget.leadDetails.email ?? "";
    companyNameController.text = widget.leadDetails.company ?? "";
    descrioptionController.text = widget.leadDetails.description ?? "";
    siteaddressController.text = '${widget.leadDetails.addressLine1 ?? ""}';
    officeaddressController.text = '${widget.leadDetails.addressLine2 ?? ""}';
    designationController.text = widget.leadDetails.designation ?? "";
    cityController.text = widget.leadDetails.cityTown ?? '';
    isLoading.value = false;
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
          "Leads Details Update",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Obx(
        () => leadController.isLeadDetailsLoading.value == true &&
                isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Lead Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: leadNameController,
                          textCapitalization: TextCapitalization.sentences,
                          data: leadName,
                          hintText: leadName,
                          labelText: leadName,
                          index: 0,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Company Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: companyNameController,
                          textCapitalization: TextCapitalization.sentences,
                          data: companyName,
                          hintText: companyName,
                          labelText: companyName,
                          index: 1,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Phone",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: phoneController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.number,
                          data: phone,
                          hintText: phone,
                          labelText: phone,
                          index: 2,
                          maxLength: 10,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: emailController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          data: email,
                          hintText: email,
                          labelText: email,
                          index: 11,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Designation",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: designationController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          data: 'designation',
                          hintText: 'Designation',
                          labelText: 'Designation',
                          index: 15,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Source",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton2<SourceListData>(
                              isExpanded: true,
                              items: leadController.sourceListData.isEmpty
                                  ? null
                                  : leadController.sourceListData
                                      .map((SourceListData item) {
                                      return DropdownMenuItem<SourceListData>(
                                        value: item,
                                        child: Text(
                                          item.sourceName ?? '',
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
                              value:
                                  leadController.selectedSourceListData.value,
                              onChanged: (SourceListData? value) {
                                if (value != null) {
                                  leadController.selectedSourceListData.value =
                                      value;
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: lightBorderColor),
                                  color: whiteColor,
                                ),
                              ),
                              hint: Text(
                                "Select Source".tr,
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
                                    border:
                                        Border.all(color: lightBorderColor)),
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "No of project",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: noofprojectController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.number,
                          data: 'project',
                          hintText: 'No of project',
                          labelText: 'No of project',
                          index: 16,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Regional office",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: regionalOfficeController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          data: 'office',
                          hintText: 'Regional office',
                          labelText: 'Regional office',
                          index: 17,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Status",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton2<LeadStatusData>(
                              isExpanded: true,
                              items: leadController.leadStatusData.isEmpty
                                  ? null
                                  : leadController.leadStatusData
                                      .map((LeadStatusData item) {
                                      return DropdownMenuItem<LeadStatusData>(
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
                              value:
                                  leadController.selectedLeadStatusData.value,
                              onChanged: (LeadStatusData? value) {
                                if (value != null) {
                                  leadController.selectedLeadStatusData.value =
                                      value;
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: lightBorderColor),
                                  color: whiteColor,
                                ),
                              ),
                              hint: Text(
                                "Select Status".tr,
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
                                    border: Border.all(color: whiteColor)),
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Reference Details",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: refdetailsController,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          data: 'reference',
                          hintText: 'Reference details',
                          labelText: 'Reference details',
                          index: 18,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Type",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(() => Row(
                              children: [
                                Radio<String>(
                                  value: 'developer',
                                  groupValue:
                                      leadController.selectedUserType.value,
                                  onChanged: (value) {
                                    leadController.selectedUserType.value =
                                        value!;
                                  },
                                ),
                                Text('Developer',
                                    style: TextStyle(fontSize: 14.sp)),
                                SizedBox(width: 20.w),
                                Radio<String>(
                                  value: 'contractor',
                                  groupValue:
                                      leadController.selectedUserType.value,
                                  onChanged: (value) {
                                    leadController.selectedUserType.value =
                                        value!;
                                  },
                                ),
                                Text('Contractor',
                                    style: TextStyle(fontSize: 14.sp)),
                              ],
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: descrioptionController,
                          textCapitalization: TextCapitalization.sentences,
                          data: description,
                          hintText: description,
                          labelText: description,
                          index: 7,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Site Address",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: siteaddressController,
                          textCapitalization: TextCapitalization.sentences,
                          data: address,
                          hintText: "Site Address",
                          labelText: "Site Address",
                          index: 17,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Office Address",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: officeaddressController,
                          textCapitalization: TextCapitalization.sentences,
                          data: address,
                          hintText: "Office Address",
                          labelText: "Office Address",
                          index: 20,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "City/Town",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: cityController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'city',
                          hintText: "City/Town",
                          labelText: "City/Town",
                          index: 17,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
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
                              items:
                                  leadController.followUpsTypeListData.isEmpty
                                      ? null
                                      : leadController.followUpsTypeListData
                                          .map((FollowUpsTypeData item) {
                                          return DropdownMenuItem<
                                              FollowUpsTypeData>(
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
                              value: leadController
                                  .selectedFollowUpsTypeListData.value,
                              onChanged: (FollowUpsTypeData? value) {
                                if (value != null) {
                                  leadController.selectedFollowUpsTypeListData
                                      .value = value;
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                                    border:
                                        Border.all(color: lightBorderColor)),
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
                                    items: leadController.timeList
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
                                    value: leadController
                                            .selectedTime!.value.isEmpty
                                        ? null
                                        : leadController.selectedTime?.value,
                                    onChanged: (String? value) {
                                      leadController.selectedTime?.value =
                                          value ?? '';
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 45.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          left: 14.w, right: 14.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        border:
                                            Border.all(color: lightBorderColor),
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
                                              BorderRadius.circular(14.r),
                                          color: whiteColor,
                                          border: Border.all(
                                              color: lightBorderColor)),
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Upload Selfie Image",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(() => DottedBorder(
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12.r),
                              dashPattern: [6, 4],
                              strokeWidth: 1.5,
                              child: InkWell(
                                onTap: () => takePhoto(ImageSource.camera),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  height: 120.h,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: leadController.isImageLoading.value
                                      ? CircularProgressIndicator()
                                      : (leadController
                                              .pickedImage.value.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt_outlined,
                                                    size: 28.sp,
                                                    color: Colors.grey),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  "Upload live image",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: Image.file(
                                                leadController.pickedFile.value,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Upload visiting card",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => DottedBorder(
                            color: Colors.grey,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12.r),
                            dashPattern: [6, 4],
                            strokeWidth: 1.5,
                            child: InkWell(
                              onTap: () => uploadFile(),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                height: 120.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: leadController
                                        .pickedVisitingCard.value.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt_outlined,
                                              size: 28.sp, color: Colors.grey),
                                          SizedBox(height: 8.h),
                                          Text(
                                            "Upload Visiting Card",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Image.file(
                                        leadController
                                            .pickedVisitingFile.value!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Obx(
                          () => CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String rem =
                                    "${timeTextEditingController.text} ${leadController.selectedTime?.value}";
                                if (leadController.isDetailsUpdating.value ==
                                    false) {
                                  if (leadController
                                          .selectedSourceListData.value !=
                                      null) {
                                    if (leadController
                                            .selectedLeadStatusData.value !=
                                        null) {
                                      await leadController.updateDetails(
                                        name: leadNameController.text,
                                        companyName: companyNameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        designation: designationController.text,
                                        source: leadController
                                            .selectedSourceListData.value,
                                        noofProject: noofprojectController.text,
                                        regionalOffice:
                                            regionalOfficeController.text,
                                        status: leadController
                                            .selectedLeadStatusData.value,
                                        refDetails: refdetailsController.text,
                                        type: leadController
                                            .selectedUserType.value,
                                        descriptin: descrioptionController.text,
                                        siteAddress: siteaddressController.text,
                                        officeAddress:
                                            officeaddressController.text,
                                        city: cityController.text,
                                        leadId: widget.leadId,
                                        followupType: leadController
                                            .selectedFollowUpsTypeListData
                                            .value
                                            ?.id,
                                        followupDate: dateController.text,
                                        followupTime: timeController.text,
                                        reminder: rem,
                                      );
                                    } else {
                                      CustomToast().showCustomToast(
                                          "Please select status data.");
                                    }
                                  } else {
                                    CustomToast().showCustomToast(
                                        "Please select source data.");
                                  }
                                }
                              }
                            },
                            text: leadController.isDetailsUpdating.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: whiteColor,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: whiteColor),
                                      )
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
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  File? pickedFile;
  String fileName = "";
  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        leadController.pickedVisitingFile.value = File(file.path);
        leadController.pickedVisitingCard.value =
            leadController.pickedVisitingFile.value.toString();
        print(
            'selected file path from device is ${leadController.pickedVisitingFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  final ImagePicker imagePicker = ImagePicker();
  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      leadController.isImageLoading.value = true;
      leadController.pickedFile.value = File(pickedImage.path);
      leadController.pickedImage.value = pickedImage.path.toString();
      leadController.isImageLoading.value = false;
      // Get.back();
    } catch (e) {
      leadController.isImageLoading.value = false;
    } finally {
      leadController.isImageLoading.value = false;
    }
  }
}
