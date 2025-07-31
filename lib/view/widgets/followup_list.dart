import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/follow_ups_list_model.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/view/screen/follow_ups.dart';
import 'package:task_management/viewmodel/followups_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUpList extends StatelessWidget {
  final RxList<FollowUpsListData> followUpsListData;
  final LeadDetailsData? leadData;
  final dynamic leadId;
  final LeadController leadController;
  FollowUpList(
      this.followUpsListData, this.leadData, this.leadId, this.leadController,
      {super.key});
  final followupsVM = Get.put(FollowupsViewModel());

  String _formatDate(String? rawDate) {
    if (rawDate == null) return 'Invalid Date';
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
      'Dec',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(
        () => followUpsListData.isEmpty
            ? Center(child: Text("No follow-ups found"))
            : ListView.builder(
                itemCount: followUpsListData.length,
                padding: EdgeInsets.all(12.w),
                itemBuilder: (context, index) {
                  final item = followUpsListData[index];
                  followupsVM.selectedStatusTypeList
                      .add(item.status.toString());
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: lightBorderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18.sp, color: Colors.green),
                            SizedBox(width: 8.w),
                            Text(
                              '${_formatDate(item.followUpDate)} at ${item.followUpTime ?? 'N/A'}',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.phone,
                                      size: 18.sp, color: Colors.blue),
                                  SizedBox(width: 8.w),
                                  Text(
                                    item.followuTypeName ?? 'N/A',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 140.w,
                              child: Obx(() {
                                final status = item.status.toString();
                                final disabled = status == "2" || status == "3";

                                final uniqueStatuses = followupsVM
                                    .followupStatusList
                                    .toSet()
                                    .toList();

                                final current = (followupsVM
                                            .selectedStatusTypeList.length >
                                        index)
                                    ? followupsVM.selectedStatusTypeList[index]
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
                                                color: darkGreyColor)),
                                      );
                                    }).toList(),
                                    value: safeValue,
                                    hint: Text(
                                      'Status type',
                                      style: TextStyle(
                                          color: disabled
                                              ? Colors.grey
                                              : darkGreyColor),
                                    ),
                                    onChanged: disabled
                                        ? null
                                        : (value) {
                                            if (value != null) {
                                              followupsVM
                                                      .selectedStatusTypeList[
                                                  index] = value;
                                              showAlertDialog(
                                                context,
                                                value,
                                                leadController
                                                    .followUpsListData[index]
                                                    .id,
                                                leadController
                                                    .followUpsListData[index],
                                              );
                                            }
                                          },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: 140.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border:
                                            Border.all(color: lightBorderColor),
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
                                        height: 8.h,
                                      ),
                                      iconSize: 14,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      width: 140.w,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(Icons.note, size: 18.sp, color: Colors.orange),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                item.note ?? 'No note',
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                            const Spacer(),
                            if (leadData?.phone != null) ...[
                              GestureDetector(
                                onTap: () =>
                                    callWhatsApp(mobileNo: leadData?.phone),
                                child: Image.asset(
                                  'assets/image/png/whatsapp (2).png',
                                  height: 20.h,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () async {
                                  final phoneno =
                                      Uri.parse('tel:${leadData?.phone}');
                                  if (!await launchUrl(phoneno)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Failed to make call')),
                                    );
                                  }
                                },
                                child: Image.asset(
                                  'assets/image/png/phone_call-removebg-preview.png',
                                  height: 20.h,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(Icons.note, size: 18.sp, color: Colors.purple),
                            SizedBox(width: 8.w),
                            Text(
                              'Remarks: ${item.remarks ?? ''}',
                              style: TextStyle(
                                  fontSize: 12.sp, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 18.sp, color: Colors.purple),
                            SizedBox(width: 8.w),
                            Text(
                              'Added by: ${item.addedBy ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 12.sp, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => FollowUpsScreen(
                leadId: leadId,
              ));
        },
        backgroundColor: primaryButtonColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController momController = TextEditingController();
  Future<void> showAlertDialog(
    BuildContext context,
    String status,
    int? id,
    FollowUpsListData followUpsListData,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 230.h,
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
                    TaskCustomTextField(
                      controller: momController,
                      textCapitalization: TextCapitalization.sentences,
                      data: 'remark',
                      hintText: 'Enter Remark',
                      labelText: 'Enter Remark',
                      maxLine: 5,
                      index: 1,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (followupsVM.isChangingStatus.value == false) {
                            followupsVM.changeFollowupStatus(
                                id: id ?? 0,
                                remarks: momController.text,
                                status: status == "Done"
                                    ? 1
                                    : status == "Not Done"
                                        ? 2
                                        : 3,
                                leadId: leadId,
                                followUpsListData: followUpsListData);
                          }
                        },
                        text: followupsVM.isChangingStatus.value == true
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
                                submit,
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
    } on Exception {}
  }
}
