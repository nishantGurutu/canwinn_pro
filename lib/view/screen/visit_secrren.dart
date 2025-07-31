import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/screen/add_visit_screen.dart';
import 'package:task_management/viewmodel/followups_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitScreen extends StatefulWidget {
  final dynamic leadId;
  const VisitScreen({super.key, required this.leadId});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  final LeadController leadController = Get.put(LeadController());
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      leadController.listVisitApi(leadId: widget.leadId);
    });
    print("kwjhd83e iuy38 ${widget.leadId}");
  }

  String _formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return "${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}";
    } catch (e) {
      return rawDate;
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
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
            "Visit List",
            style: TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => AddVisitScreen(leadId: widget.leadId));
                },
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: primaryButtonColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.r),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: leadController.leadVisitListData.length,
                      itemBuilder: (context, index) {
                        final visit = leadController.leadVisitListData[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.w, vertical: 6.h),
                          child: Card(
                            color: whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          visit.visitorName ?? 'No Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                      Text(
                                        visit.visitorPhone ?? '',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.grey.shade700),
                                      ),
                                      Container(
                                        width: 25.w,
                                        child: Center(
                                          child: PopupMenuButton(
                                            color: whiteColor,
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  onTap: () {
                                                    showAlertDialog(
                                                        context, visit.id,
                                                        leadId: widget.leadId,
                                                        selectedValue: '');
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit),
                                                      SizedBox(width: 3.w),
                                                      Text('Visit'),
                                                    ],
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),

                                  Row(
                                    children: [
                                      Text(
                                        "Visit Type: ${visit.visitTypeName ?? 'N/A'}",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.black87),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 100.w,
                                        child: Obx(() {
                                          final status =
                                              visit.status.toString();
                                          final disabled =
                                              status == "2" || status == "3";

                                          final uniqueStatuses = leadController
                                              .visitStatustype
                                              .toSet()
                                              .toList();

                                          final current = (leadController
                                                      .selectedStatusTypeList
                                                      .length >
                                                  index)
                                              ? leadController
                                                  .selectedStatusTypeList[index]
                                              : '';

                                          final safeValue =
                                              uniqueStatuses.contains(current)
                                                  ? current
                                                  : null;

                                          return DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              items: uniqueStatuses.map((s) {
                                                return DropdownMenuItem<String>(
                                                  value: s,
                                                  child: Text(s,
                                                      style: TextStyle(
                                                          color:
                                                              darkGreyColor)),
                                                );
                                              }).toList(),
                                              value: safeValue,
                                              hint: Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: disabled
                                                        ? Colors.grey
                                                        : darkGreyColor),
                                              ),
                                              onChanged: disabled
                                                  ? null
                                                  : (value) async {
                                                      if (value != null) {
                                                        leadController
                                                                .selectedStatusTypeList[
                                                            index] = value;
                                                        leadController
                                                            .pickedFile
                                                            .value = File("");
                                                        leadController
                                                            .pickedImage
                                                            .value = '';
                                                        await showAlertDialog(
                                                            context,
                                                            leadController
                                                                .meetingList[
                                                                    index]
                                                                .id,
                                                            leadId:
                                                                widget.leadId,
                                                            selectedValue:
                                                                leadController
                                                                        .selectedStatusTypeList[
                                                                    index]);
                                                      }
                                                    },
                                              buttonStyleData: ButtonStyleData(
                                                height: 45.h,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  border: Border.all(
                                                      color: lightBorderColor),
                                                  color: disabled
                                                      ? Colors.grey[300]
                                                      : whiteColor,
                                                ),
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Image.asset(
                                                  'assets/images/png/Vector 3.png',
                                                  color: disabled
                                                      ? Colors.grey
                                                      : borderColor,
                                                  height: 5.h,
                                                ),
                                                iconSize: 14,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200,
                                                width: 100.w,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),

                                  if (visit.address != null &&
                                      visit.address!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        "Address: ${visit.address}",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black54),
                                      ),
                                    ),

                                  /// Description
                                  if (visit.description != null &&
                                      visit.description!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        "Description: ${visit.description}",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black54),
                                      ),
                                    ),

                                  Row(
                                    children: [
                                      if (visit.createdAt != null)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.h),
                                          child: Text(
                                            "Date: ${_formatDate(visit.createdAt!)}",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          await callWhatsApp(
                                              mobileNo: visit.visitorPhone);
                                        },
                                        child: Image.asset(
                                          'assets/image/png/whatsapp (2).png',
                                          height: 20.h,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      GestureDetector(
                                        onTap: () async {
                                          Uri phoneno = Uri.parse(
                                              'tel:${visit.visitorPhone}');
                                          if (await launchUrl(phoneno)) {
                                          } else {
                                            print('Not working');
                                          }
                                        },
                                        child: Image.asset(
                                          'assets/image/png/phone_call-removebg-preview.png',
                                          height: 20.h,
                                        ),
                                      )
                                    ],
                                  ),

                                  if (visit.selfieImage != null &&
                                      visit.selfieImage!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        child: Image.network(
                                          visit.selfieImage!,
                                          height: 140.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Text("Image not available"),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              )
            ],
          ),
        ));
  }

  ValueNotifier<int?> meetingControllerNotifier = ValueNotifier<int?>(null);

  final TextEditingController meetingTitleController = TextEditingController();
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

  final followupsVM = Get.put(FollowupsViewModel());
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> showAlertDialog(BuildContext context, int? id,
      {required leadId, required String selectedValue}) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: leadController.selectedVisitStatus.value == "Done"
                ? 300.h
                : leadController.selectedVisitStatus.value == "Reshedule"
                    ? 100.h
                    : 230.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leadController.selectedVisitStatus.value != "Reshedule")
                      Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Obx(
                            () => DottedBorder(
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12.r),
                              dashPattern: [6, 4],
                              strokeWidth: 1.5,
                              child: InkWell(
                                onTap: () => takePhoto(ImageSource.camera),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  height: 100.h,
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
                                                leadController
                                                    .pickedFile.value!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            )),
                                ),
                              ),
                            ),
                          ),
                          if (leadController.selectedVisitStatus.value ==
                              "Done")
                            SizedBox(
                              height: 10.h,
                            ),
                          if (leadController.selectedVisitStatus.value ==
                              "Done")
                            TaskCustomTextField(
                              controller: meetingTitleController,
                              textCapitalization: TextCapitalization.sentences,
                              data: 'Remark',
                              hintText: 'Remark',
                              labelText: 'Remark',
                              maxLine: 3,
                              index: 1,
                              focusedIndexNotifier: meetingControllerNotifier,
                            ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    CustomButton(
                      onPressed: () {
                        if (leadController.isLeadVisitStatusChanging.value ==
                            false) {
                          leadController.changeVisitStatus(
                            image: leadController.pickedFile.value,
                            latitude: "7632873",
                            longitude: '876876',
                            id: id,
                            status: leadController.selectedVisitStatus.value ==
                                    "Start"
                                ? 1
                                : leadController.selectedVisitStatus.value ==
                                        "Done"
                                    ? 2
                                    : 3,
                            remark: meetingTitleController.text,
                            leadid: leadId,
                            selectedValue: selectedValue,
                            mergedPeopleList: [],
                          );
                        }
                      },
                      text: Text(
                        leadController.selectedVisitStatus.value == "Done"
                            ? "End Visit/Meeting"
                            : leadController.selectedVisitStatus.value ==
                                    "Reshedule"
                                ? "Reshedule Visit/Meeting"
                                : "Start Visit/Meeting",
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
        );
      },
    );
  }

  Future<void> callWhatsApp({String? mobileNo}) async {
    String? mobileContact =
        mobileNo!.contains('+91') ? mobileNo : "+91$mobileNo";
    var androidUrl = "whatsapp://send?phone=$mobileContact";
    var iosUrl = "https://wa.me/$mobileContact";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }
}
