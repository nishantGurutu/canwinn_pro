import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/model/lead_status_lead.dart';
import 'package:task_management/model/source_list_model.dart';
import 'package:task_management/view/widgets/voiceRecorderButton.dart';

class AddLeads extends StatefulWidget {
  const AddLeads({super.key});

  @override
  State<AddLeads> createState() => _AddLeadsState();
}

class _AddLeadsState extends State<AddLeads> {
  final LeadController leadController = Get.find();
  final TextEditingController leadNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController surceController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    Future.microtask(() {
      leadController.selectedSourceListData.value = null;
      leadController.addselectedLeadStatusData.value = null;
      leadController.selectedLeadStatusData.value = null;
      leadController.offLineSourcedata();
      leadController.offLineStatusdata();
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.microtask(() {
      leadController.selectedSourceListData.value = null;
      leadController.addselectedLeadStatusData.value = null;
    });
    super.dispose();
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
          "Add Leads",
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
        () => leadController.isStatusListLoading.value == true &&
                leadController.isSourceLoading.value == true
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
                          data: "",
                          hintText: email,
                          labelText: email,
                          index: 11,
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
                              value: leadController
                                  .addselectedLeadStatusData.value,
                              onChanged: (LeadStatusData? value) {
                                if (value != null) {
                                  leadController
                                      .addselectedLeadStatusData.value = value;
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
                          "Description",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: descriptionController,
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
                          "Address",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: addressController,
                          textCapitalization: TextCapitalization.sentences,
                          data: address,
                          hintText: address,
                          labelText: address,
                          index: 8,
                          focusedIndexNotifier: focusedIndexNotifier,
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
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                takePhoto(ImageSource.camera);
                              },
                              child: Container(
                                height: 40.h,
                                width: 130.w,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera,
                                      color: whiteColor,
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            VoiceRecorderButton(
                              onRecordingComplete: (File audioFile) async {
                                attachment = audioFile;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Obx(
                          () => CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (leadController.isLeadAdding.value ==
                                    false) {
                                  if (leadController
                                          .selectedSourceListData.value !=
                                      null) {
                                    if (leadController
                                            .addselectedLeadStatusData.value !=
                                        null) {
                                      bool isConnected =
                                          await checkInternetConnection();

                                      if (isConnected) {
                                        leadController.addLeads(
                                          leadName: leadNameController.text,
                                          companyName:
                                              companyNameController.text,
                                          phone: phoneController.text,
                                          email: emailController.text,
                                          source: leadController
                                                  .selectedSourceListData
                                                  .value
                                                  ?.id
                                                  ?.toString() ??
                                              '',
                                          status: leadController
                                                  .addselectedLeadStatusData
                                                  .value
                                                  ?.id
                                                  .toString() ??
                                              "",
                                          description:
                                              descriptionController.text,
                                          audio: attachment,
                                        );
                                      } else {
                                        await DatabaseHelper.instance
                                            .insertLead(
                                          leadName: leadNameController.text,
                                          companyName:
                                              companyNameController.text,
                                          phone: phoneController.text,
                                          email: emailController.text,
                                          source: leadController
                                                  .selectedSourceListData
                                                  .value
                                                  ?.id
                                                  ?.toString() ??
                                              '',
                                          status: leadController
                                                  .addselectedLeadStatusData
                                                  .value
                                                  ?.id
                                                  ?.toString() ??
                                              '',
                                          description:
                                              descriptionController.text,
                                          address: addressController.text,
                                          imagePath: leadController
                                              .pickedFile.value.path,
                                          audioPath: attachment.path,
                                          latitude: LocationHandler
                                              .currentPosition?.latitude,
                                          longitude: LocationHandler
                                              .currentPosition?.longitude,
                                          timestamp:
                                              DateTime.now().toIso8601String(),
                                        );

                                        leadController.leadsList(
                                            leadController
                                                .addselectedLeadStatusData
                                                .value
                                                ?.id,
                                            leadController
                                                .selectedLeadType.value);
                                      }
                                      attachment = File('');
                                      leadController.pickedFile.value =
                                          File('');
                                      leadController.pickedImage.value = '';
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
                            text: leadController.isLeadAdding.value == true
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

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      // Try pinging Google
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  File attachment = File('');
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
