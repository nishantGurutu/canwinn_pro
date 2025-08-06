import 'dart:io';
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
import 'package:task_management/model/follow_ups_list_model.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/follow_ups.dart';
import 'package:task_management/viewmodel/followups_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUpList extends StatefulWidget {
  final RxList<FollowUpsListData> followUpsListData;
  final LeadController leadController;
  final LeadDetailsData? leadData;
  final dynamic leadId;
  const FollowUpList(
      this.followUpsListData, this.leadData, this.leadId, this.leadController,
      {super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

class _FollowUpListState extends State<FollowUpList> {
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
  dispose() {
    super.dispose();
    widget.leadController.selectdePersonIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(
        () => widget.followUpsListData.isEmpty
            ? Center(child: Text("No follow-ups found"))
            : ListView.builder(
                itemCount: widget.followUpsListData.length,
                padding: EdgeInsets.all(12.w),
                itemBuilder: (context, index) {
                  final item = widget.followUpsListData[index];
                  followupsVM.selectedStatusTypeList
                      .add(item.status.toString());
                  return Stack(
                    children: [
                      Container(
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
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
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
                                  width: 120.w,
                                  child: Obx(() {
                                    final status = item.status.toString();
                                    final disabled =
                                        status == "2" || status == "3";

                                    final uniqueStatuses = followupsVM
                                        .followupStatusList
                                        .toSet()
                                        .toList();

                                    final current = (followupsVM
                                                .selectedStatusTypeList.length >
                                            index)
                                        ? followupsVM
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
                                                    widget
                                                        .leadController
                                                        .followUpsListData[
                                                            index]
                                                        .id,
                                                    widget.leadController
                                                            .followUpsListData[
                                                        index],
                                                  );
                                                }
                                              },
                                        buttonStyleData: ButtonStyleData(
                                          height: 40.h,
                                          width: 120.w,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
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
                                            height: 8.h,
                                          ),
                                          iconSize: 14,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200.h,
                                          width: 120.w,
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          height: 40.h,
                                          padding: EdgeInsets.only(
                                              left: 14, right: 14),
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
                                Icon(Icons.note,
                                    size: 18.sp, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    item.note ?? 'No note',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ),
                                const Spacer(),
                                if (widget.leadData?.phone != null) ...[
                                  GestureDetector(
                                    onTap: () => callWhatsApp(
                                        mobileNo: widget.leadData?.phone),
                                    child: Image.asset(
                                      'assets/image/png/whatsapp (2).png',
                                      height: 20.h,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () async {
                                      final phoneno = Uri.parse(
                                          'tel:${widget.leadData?.phone}');
                                      if (!await launchUrl(phoneno)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Failed to make call')),
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
                                Icon(Icons.note,
                                    size: 18.sp, color: Colors.purple),
                                SizedBox(width: 8.w),
                                Text(
                                  'Remarks: ${item.remarks ?? ''}',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontStyle: FontStyle.italic),
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
                                      fontSize: 12.sp,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        child: Container(
                          width: 30.w,
                          child: Center(
                            child: PopupMenuButton(
                              color: whiteColor,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      widget.leadController.selectdePersonIds
                                          .clear();
                                      controller.clearAll();
                                      assignandaddUser(
                                        context,
                                        widget.leadController
                                            .followUpsListData[index].id,
                                        "assign",
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/png/assign_people-removebg-preview.png',
                                          height: 1.h,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text("Assign Lead"),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => FollowUpsScreen(
                leadId: widget.leadId,
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

  final controller = MultiSelectController<ResponsiblePersonData>();
  Future<void> assignandaddUser(
    BuildContext context,
    int? id,
    String from,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: lightBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(14.r)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(14.r)),
                      child: Obx(
                        () => MultiDropdown<ResponsiblePersonData>(
                          items: widget.leadController.responsiblePersonList
                              .map(
                                  (item) => DropdownItem<ResponsiblePersonData>(
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
                            hintStyle: const TextStyle(color: Colors.black87),
                            backgroundColor: Colors.white,
                            showClearIcon: false,
                            border: InputBorder.none,
                          ),
                          dropdownDecoration: DropdownDecoration(
                            maxHeight: 500.h,
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.r)),
                            header: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Select Person',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon:
                                Icon(Icons.check_box, color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          onSelectionChange: (selectedItems) {
                            widget.leadController.selectdePersonIds
                                .assignAll(selectedItems);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(
                    () => CustomButton(
                      text: widget.leadController.isPeopleAdding.value == true
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
                                  "Loading...",
                                  style: TextStyle(color: whiteColor),
                                )
                              ],
                            )
                          : Text(
                              from == "add-people" ? "Add People" : 'Assign',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor),
                            ),
                      onPressed: () async {
                        if (widget.leadController.isPeopleAdding.value ==
                            false) {
                          await widget.leadController.assignFollowup(
                            personid: widget.leadController.selectdePersonIds,
                            followupId: id,
                          );
                          // addPeople(
                          //     personid: leadController
                          //         .selectedResponsiblePersonData.value?.id,
                          //     leadId: id,
                          //     from: from);
                        }
                      },
                      color: primaryButtonColor,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                                leadId: widget.leadId,
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
