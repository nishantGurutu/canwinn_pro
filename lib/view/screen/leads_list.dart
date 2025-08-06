import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/helper/call_helper.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lead_status_lead.dart';
import 'package:task_management/model/responsible_person_list_model.dart'
    show ResponsiblePersonData;
import 'package:task_management/view/screen/add_lead.dart';
import 'package:task_management/view/screen/lead_detail_update.dart';
import 'package:task_management/view/screen/lead_overview.dart';
import 'package:task_management/view/screen/update_leads.dart';

class LeadList extends StatefulWidget {
  final String? status;
  const LeadList({super.key, this.status});

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  final LeadController leadController = Get.put(LeadController());
  List<ScreenshotController> screenshotControllers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      apiCalling();
    });
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

  var isLoading = false.obs;

  Future<void> apiCalling() async {
    isLoading.value = true;
    leadController.selectedStatusPerLead.clear();
    leadController.isAllLeadSelected.value = true;
    leadController.isUploadedDocumentLeadSelected.value = false;
    if (widget.status == "total" || widget.status!.isEmpty) {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == 'pl') {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == "spl") {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == "new lead") {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == "won") {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == "quotation") {
      await leadController.offLineStatusdata(status: widget.status);
    } else if (widget.status == "lost") {
      await leadController.offLineStatusdata(status: widget.status);
    }
    if (StorageHelper.getRoleName() != null &&
        StorageHelper.getRoleName() != '') {
      await leadController.addedDocumentLeadList();
    }
    isLoading.value = false;
    await leadController.taskResponsiblePersonListApi();
  }

  @override
  void dispose() {
    Future.microtask(() {
      leadController.selectedLeadStatusData.value = null;
      leadController.selectedLeadStatusUpdateData.value = null;
      leadController.selectedLeadType.value = '';
      leadController.selectedLeadStatusData.value = null;
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
          "Leads List",
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
                Get.to(() => AddLeads());
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
      body: Obx(
        () => isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : leadController.leadsListData.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No lead data',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (StorageHelper.getRoleName()
                                    .toString()
                                    .toLowerCase() ==
                                "marketing manager" ||
                            StorageHelper.getRoleName()
                                    .toString()
                                    .toLowerCase() ==
                                "branch head" ||
                            StorageHelper.getRoleName()
                                    .toString()
                                    .toLowerCase() ==
                                "pa")
                          Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          leadController
                                              .isAllLeadSelected.value = true;
                                          leadController
                                              .isUploadedDocumentLeadSelected
                                              .value = false;
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: leadController
                                                        .isAllLeadSelected
                                                        .value ==
                                                    true
                                                ? primaryButtonColor
                                                : backgroundColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'All Lead',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: leadController
                                                            .isAllLeadSelected
                                                            .value ==
                                                        true
                                                    ? whiteColor
                                                    : primaryButtonColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          leadController
                                              .isAllLeadSelected.value = false;
                                          leadController
                                              .isUploadedDocumentLeadSelected
                                              .value = true;
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: leadController
                                                        .isUploadedDocumentLeadSelected
                                                        .value ==
                                                    true
                                                ? primaryButtonColor
                                                : backgroundColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Document Lead',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: leadController
                                                            .isUploadedDocumentLeadSelected
                                                            .value ==
                                                        true
                                                    ? whiteColor
                                                    : primaryButtonColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: boxBorderColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r))),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  child: Obx(
                                    () => DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        items: leadController.leadTypeList
                                            .map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item ?? "",
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Roboto',
                                                color: darkGreyColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        value: leadController
                                                .selectedLeadType.value.isEmpty
                                            ? null
                                            : leadController
                                                .selectedLeadType.value,
                                        onChanged: (String? value) async {
                                          leadController
                                              .selectedLeadType.value = value!;
                                          await leadController.leadsList(
                                              leadController
                                                  .selectedLeadStatusData
                                                  .value
                                                  ?.id,
                                              leadController
                                                  .selectedLeadType.value);
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: whiteColor,
                                          ),
                                        ),
                                        hint: Text(
                                          'Select Lead Type'.tr,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Roboto',
                                            color: darkGreyColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
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
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: boxBorderColor)),
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
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: boxBorderColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r))),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  child: Obx(
                                    () => DropdownButtonHideUnderline(
                                      child: DropdownButton2<LeadStatusData>(
                                        isExpanded: true,
                                        items: leadController.leadStatusData
                                            .map((LeadStatusData item) {
                                          return DropdownMenuItem<
                                              LeadStatusData>(
                                            value: item,
                                            child: Text(
                                              item.name ?? "",
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Roboto',
                                                color: darkGreyColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        value: leadController
                                                    .selectedLeadStatusData
                                                    .value ==
                                                null
                                            ? null
                                            : leadController
                                                .selectedLeadStatusData.value,
                                        onChanged:
                                            (LeadStatusData? value) async {
                                          leadController.selectedLeadStatusData
                                              .value = value;
                                          await leadController.leadsList(
                                              leadController
                                                  .selectedLeadStatusData
                                                  .value
                                                  ?.id,
                                              leadController
                                                  .selectedLeadType.value);
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 14, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: whiteColor,
                                          ),
                                        ),
                                        hint: Text(
                                          'Select Lead Type'.tr,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Roboto',
                                            color: darkGreyColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
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
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              color: whiteColor,
                                              border: Border.all(
                                                  color: boxBorderColor)),
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        leadController.isAllLeadSelected.value == true
                            ? allLeadList()
                            : documentLeadList()
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget allLeadList() {
    return Expanded(
      child: leadController.leadsListData.isEmpty
          ? Center(
              child: Text(
                'No Lead data',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: leadController.leadsListData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => LeadOverviewScreen(
                            leadId: leadController.leadsListData[index].id,
                            leadNumber:
                                leadController.leadsListData[index].leadNumber,
                          ));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: lightBorderColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: lightGreyColor.withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 2,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${leadController.leadsListData[index].leadName ?? ""}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${leadController.leadsListData[index].leadNumber ?? ""}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  width: 30.w,
                                  child: Center(
                                    child: PopupMenuButton(
                                      color: whiteColor,
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            onTap: () {
                                              Get.to(() => UpdateLeads(
                                                  leadListData: leadController
                                                      .leadsListData[index]));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit),
                                                SizedBox(width: 3.w),
                                                Text(edit),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete),
                                                SizedBox(width: 3.w),
                                                Text(delete),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              Future.delayed(Duration.zero, () {
                                                leadController.selectdePersonIds
                                                    .clear();
                                                controller.clearAll();
                                                assignandaddUser(
                                                  context,
                                                  leadController
                                                      .leadsListData[index].id,
                                                  "add-people",
                                                );
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/image/png/add_people-removebg-preview.png',
                                                  height: 1.h,
                                                ),
                                                SizedBox(width: 3.w),
                                                Text("Add People"),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              leadController.selectdePersonIds
                                                  .clear();
                                              controller.clearAll();
                                              assignandaddUser(
                                                context,
                                                leadController
                                                    .leadsListData[index].id,
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
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 16.sp,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        '${leadController.leadsListData[index].company ?? ""}',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Spacer(),
                                      if ((leadController.leadsListData[index]
                                                  .leadNumber ??
                                              "")
                                          .isEmpty)
                                        InkWell(
                                          onTap: () {
                                            leadController.uploadOfflineLead(
                                                leadController
                                                    .leadsListData[index]);
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text('Async'),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Container(
                                                  height: 12.h,
                                                  width: 12.w,
                                                  decoration: BoxDecoration(
                                                    color: redColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(6.r),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 16.sp,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        '${leadController.leadsListData[index].phone ?? ""}',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        size: 16.sp,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${leadController.leadsListData[index].email ?? ""}',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: Obx(
                                        () => DropdownButtonHideUnderline(
                                          child:
                                              DropdownButton2<LeadStatusData>(
                                            isExpanded: true,
                                            items: leadController.leadStatusData
                                                .map((LeadStatusData item) {
                                              return DropdownMenuItem<
                                                  LeadStatusData>(
                                                value: item,
                                                child: Text(
                                                  item.name ?? "",
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontFamily: 'Roboto',
                                                    color: darkGreyColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            value: leadController.leadStatusData
                                                    .contains(leadController
                                                            .selectedStatusPerLead[
                                                        index])
                                                ? leadController
                                                        .selectedStatusPerLead[
                                                    index]
                                                : null,
                                            onChanged: (LeadStatusData? value) {
                                              changeStatusDialog(
                                                  context,
                                                  leadController
                                                      .leadsListData[index].id,
                                                  value);
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 30,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: lightBorderColor),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                color: leadController
                                                            .selectedStatusPerLead[
                                                                index]
                                                            .name
                                                            ?.toLowerCase() ==
                                                        "new lead"
                                                    ? Colors.blue
                                                    : leadController
                                                                .selectedStatusPerLead[
                                                                    index]
                                                                .name
                                                                ?.toLowerCase() ==
                                                            "pl"
                                                        ? Colors.yellow
                                                        : leadController
                                                                    .selectedStatusPerLead[
                                                                        index]
                                                                    .name
                                                                    ?.toLowerCase() ==
                                                                "spl"
                                                            ? Colors.purple
                                                            : leadController
                                                                        .selectedStatusPerLead[
                                                                            index]
                                                                        .name
                                                                        ?.toLowerCase() ==
                                                                    "quotation"
                                                                ? Colors.orange
                                                                : leadController
                                                                            .selectedStatusPerLead[
                                                                                index]
                                                                            .name
                                                                            ?.toLowerCase() ==
                                                                        "won"
                                                                    ? Colors
                                                                        .green
                                                                    : leadController.selectedStatusPerLead[index].name?.toLowerCase() ==
                                                                            "lost"
                                                                        ? Colors
                                                                            .red
                                                                        : whiteColor,
                                              ),
                                            ),
                                            hint: Text(
                                              'Status'.tr,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Roboto',
                                                color: darkGreyColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
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
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200.h,
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  color: whiteColor,
                                                  border: Border.all(
                                                      color: lightBorderColor)),
                                              offset: const Offset(0, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 30,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_formatDate(leadController.leadsListData[index].createdAt ?? "")}',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await CallHelper().callWhatsApp(
                                            mobileNo: leadController
                                                .leadsListData[index].phone);
                                      },
                                      child: Image.asset(
                                        'assets/image/png/whatsapp (2).png',
                                        height: 20.h,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    GestureDetector(
                                      onTap: () async {
                                        CallHelper().callPhone(
                                            mobileNo: leadController
                                                .leadsListData[index].phone);
                                      },
                                      child: Image.asset(
                                        'assets/image/png/phone_call-removebg-preview.png',
                                        height: 20.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _shareSingleCard(index);
                                        },
                                        icon: Icon(Icons.share))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => LeadOverviewScreen(
                                          leadId: leadController
                                              .leadsListData[index].id,
                                          index: 1,
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              getPassIcon,
                                              color: textColor,
                                              height: 17.h,
                                            ),
                                            SizedBox(width: 3.w),
                                            Text(followups),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => LeadOverviewScreen(
                                            leadId: leadController
                                                .leadsListData[index].id,
                                            index: 5,
                                          ));
                                    },
                                    child: SizedBox(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/image/png/location-mark.png',
                                              height: 17.sp,
                                            ),
                                            SizedBox(width: 3.w),
                                            Text(visit),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => LeadOverviewScreen(
                                            leadId: leadController
                                                .leadsListData[index].id,
                                            index: 2,
                                            leadNumber: leadController
                                                .leadsListData[index]
                                                .leadNumber,
                                          ));
                                    },
                                    child: SizedBox(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/image/png/quotation_icon-removebg-preview.png',
                                              height: 17.sp,
                                            ),
                                            SizedBox(width: 3.w),
                                            Text('Quotation'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (StorageHelper.getId().toString() ==
                                    leadController.leadsListData[index].userId
                                        .toString())
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => LeadDetailUpdate(
                                            leadId: leadController
                                                .leadsListData[index].id,
                                            leadDetails: leadController
                                                .leadsListData[index]));
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w,
                                              top: 3.h,
                                              bottom: 3.h),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/image/png/update_icon-removebg-preview.png',
                                                height: 17.sp,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text('Update'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget documentLeadList() {
    return Obx(
      () => Expanded(
        child: leadController.addedDocumentLeadDataList.isEmpty
            ? Center(
                child: Text(
                  'No Lead data',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: leadController.addedDocumentLeadDataList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => LeadOverviewScreen(
                              leadId: leadController
                                  .addedDocumentLeadDataList[index].id,
                              leadNumber: leadController
                                  .addedDocumentLeadDataList[index].leadNumber,
                            ));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(color: lightBorderColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: lightGreyColor.withOpacity(0.1),
                              blurRadius: 6.0,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.inner,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${leadController.addedDocumentLeadDataList[index].leadName ?? ""}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${leadController.addedDocumentLeadDataList[index].leadNumber ?? ""}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    width: 30.w,
                                    child: Center(
                                      child: PopupMenuButton(
                                        color: whiteColor,
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              onTap: () {
                                                // Get.to(() => UpdateLeads(
                                                //     leadListData: leadController
                                                //             .addedDocumentLeadDataList[
                                                //         index]));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit),
                                                  SizedBox(width: 3.w),
                                                  Text(edit),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete),
                                                  SizedBox(width: 3.w),
                                                  Text(delete),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  leadController
                                                      .selectdePersonIds
                                                      .clear();
                                                  controller.clearAll();
                                                  assignandaddUser(
                                                    context,
                                                    leadController
                                                        .addedDocumentLeadDataList[
                                                            index]
                                                        .id,
                                                    "add-people",
                                                  );
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/image/png/add_people-removebg-preview.png',
                                                    height: 1.h,
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text("Add People"),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                leadController.selectdePersonIds
                                                    .clear();
                                                controller.clearAll();
                                                assignandaddUser(
                                                  context,
                                                  leadController
                                                      .addedDocumentLeadDataList[
                                                          index]
                                                      .id,
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
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.business,
                                          size: 16.sp,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          '${leadController.addedDocumentLeadDataList[index].company ?? ""}',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        if ((leadController
                                                    .addedDocumentLeadDataList[
                                                        index]
                                                    .leadNumber ??
                                                "")
                                            .isEmpty)
                                          InkWell(
                                            onTap: () {
                                              // leadController.uploadOfflineLead(
                                              //     leadController
                                              //         .leadsListData[index]);
                                            },
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text('Async'),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Container(
                                                    height: 12.h,
                                                    width: 12.w,
                                                    decoration: BoxDecoration(
                                                      color: redColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(6.r),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 16.sp,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          '${leadController.addedDocumentLeadDataList[index].phone ?? ""}',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 16.sp,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${leadController.addedDocumentLeadDataList[index].email ?? ""}',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        child: Obx(
                                          () => DropdownButtonHideUnderline(
                                            child:
                                                DropdownButton2<LeadStatusData>(
                                              isExpanded: true,
                                              items: leadController
                                                  .leadStatusData
                                                  .map((LeadStatusData item) {
                                                return DropdownMenuItem<
                                                    LeadStatusData>(
                                                  value: item,
                                                  child: Text(
                                                    item.name ?? "",
                                                    style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontFamily: 'Roboto',
                                                      color: darkGreyColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              value: leadController
                                                      .leadStatusData
                                                      .contains(leadController
                                                              .selectedStatusPerLead[
                                                          index])
                                                  ? leadController
                                                          .selectedStatusPerLead[
                                                      index]
                                                  : null,
                                              onChanged:
                                                  (LeadStatusData? value) {
                                                changeStatusDialog(
                                                    context,
                                                    leadController
                                                        .leadsListData[index]
                                                        .id,
                                                    value);
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 30,
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: lightBorderColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color: leadController
                                                              .selectedStatusPerLead[
                                                                  index]
                                                              .name
                                                              ?.toLowerCase() ==
                                                          "new lead"
                                                      ? Colors.blue
                                                      : leadController
                                                                  .selectedStatusPerLead[
                                                                      index]
                                                                  .name
                                                                  ?.toLowerCase() ==
                                                              "pl"
                                                          ? Colors.yellow
                                                          : leadController
                                                                      .selectedStatusPerLead[
                                                                          index]
                                                                      .name
                                                                      ?.toLowerCase() ==
                                                                  "spl"
                                                              ? Colors.purple
                                                              : leadController
                                                                          .selectedStatusPerLead[
                                                                              index]
                                                                          .name
                                                                          ?.toLowerCase() ==
                                                                      "quotation"
                                                                  ? Colors
                                                                      .orange
                                                                  : leadController
                                                                              .selectedStatusPerLead[
                                                                                  index]
                                                                              .name
                                                                              ?.toLowerCase() ==
                                                                          "won"
                                                                      ? Colors
                                                                          .green
                                                                      : leadController.selectedStatusPerLead[index].name?.toLowerCase() ==
                                                                              "lost"
                                                                          ? Colors
                                                                              .red
                                                                          : whiteColor,
                                                ),
                                              ),
                                              hint: Text(
                                                'Status'.tr,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: 'Roboto',
                                                  color: darkGreyColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
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
                                                iconEnabledColor:
                                                    lightGreyColor,
                                                iconDisabledColor:
                                                    lightGreyColor,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200.h,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    color: whiteColor,
                                                    border: Border.all(
                                                        color:
                                                            lightBorderColor)),
                                                offset: const Offset(0, 0),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness: WidgetStateProperty
                                                      .all<double>(6),
                                                  thumbVisibility:
                                                      WidgetStateProperty.all<
                                                          bool>(true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 30,
                                                padding: EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${_formatDate(leadController.addedDocumentLeadDataList[index].createdAt ?? "")}',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await CallHelper().callWhatsApp(
                                              mobileNo: leadController
                                                  .addedDocumentLeadDataList[
                                                      index]
                                                  .phone);
                                        },
                                        child: Image.asset(
                                          'assets/image/png/whatsapp (2).png',
                                          height: 20.h,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      GestureDetector(
                                        onTap: () async {
                                          CallHelper().callPhone(
                                              mobileNo: leadController
                                                  .addedDocumentLeadDataList[
                                                      index]
                                                  .phone);
                                        },
                                        child: Image.asset(
                                          'assets/image/png/phone_call-removebg-preview.png',
                                          height: 20.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _shareSingleCard(index);
                                          },
                                          icon: Icon(Icons.share))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => LeadOverviewScreen(
                                            leadId: leadController
                                                .addedDocumentLeadDataList[
                                                    index]
                                                .id,
                                            index: 1,
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                getPassIcon,
                                                color: textColor,
                                                height: 17.h,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text(followups),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => LeadOverviewScreen(
                                              leadId: leadController
                                                  .addedDocumentLeadDataList[
                                                      index]
                                                  .id,
                                              index: 5,
                                            ));
                                      },
                                      child: SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/image/png/location-mark.png',
                                                height: 17.sp,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text(visit),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => LeadOverviewScreen(
                                              leadId: leadController
                                                  .addedDocumentLeadDataList[
                                                      index]
                                                  .id,
                                              index: 2,
                                              leadNumber: leadController
                                                  .addedDocumentLeadDataList[
                                                      index]
                                                  .leadNumber,
                                            ));
                                      },
                                      child: SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/image/png/quotation_icon-removebg-preview.png',
                                                height: 17.sp,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text('Quotation'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (StorageHelper.getId().toString() ==
                                      leadController
                                          .addedDocumentLeadDataList[index]
                                          .userId
                                          .toString())
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.to(() => LeadDetailUpdate(
                                          //     leadId: leadController
                                          //         .leadsListData[index].id,
                                          //     leadDetails: leadController
                                          //         .leadsListData[index]));
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.w,
                                                top: 3.h,
                                                bottom: 3.h),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/image/png/update_icon-removebg-preview.png',
                                                  height: 17.sp,
                                                ),
                                                SizedBox(width: 3.w),
                                                Text('Update'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  final controller = MultiSelectController<ResponsiblePersonData>();

  Future<void> _shareSingleCard(int index) async {
    final ap = leadController.leadsListData[index];

    final locationUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(ap.latitude.toString())},${Uri.encodeComponent(ap.longitude.toString())}';

    final message = '''
      LeadName: ${ap.leadName}
      LeadNumber: ${ap.leadNumber}
      Company: ${ap.company}
      Phone: ${ap.phone}
      Location: $locationUrl
      ''';

    await Share.share(message);

    print("latitude:---${ap.latitude}");
    print("longitude:---${ap.longitude}");
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController statusRemarkController = TextEditingController();
  Future<void> changeStatusDialog(
    BuildContext context,
    int? id,
    LeadStatusData? value,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure want to\nupdate status ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 40.h,
                        child: CustomButton(
                          onPressed: () async {
                            leadController.selectedLeadStatusUpdateData.value =
                                value;
                            if (leadController.isStatusUpdating.value ==
                                false) {
                              await leadController.statusUpdate(
                                  leadId: id,
                                  status: leadController
                                      .selectedLeadStatusUpdateData.value?.id,
                                  widgetStatus: widget.status!);
                            }
                          },
                          text: Text(
                            done,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          width: double.infinity,
                          color: primaryColor,
                          height: 40.h,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 100.w,
                        height: 40.h,
                        child: CustomButton(
                          onPressed: () {
                            Get.back();
                          },
                          text: Text(
                            cancel,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          width: double.infinity,
                          color: primaryColor,
                          height: 40.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                          items: leadController.responsiblePersonList
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
                            leadController.selectdePersonIds
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
                      text: leadController.isPeopleAdding.value == true
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
                      onPressed: () {
                        if (leadController.isPeopleAdding.value == false) {
                          leadController.addPeople(
                              personid: leadController
                                  .selectedResponsiblePersonData.value?.id,
                              leadId: id,
                              from: from);
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
}
