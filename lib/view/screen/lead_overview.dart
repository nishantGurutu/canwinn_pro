import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/network_image_class.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/model/lead_visit_list_model.dart';
import 'package:task_management/view/screen/lead_note.dart';
import 'package:task_management/view/screen/quotation_list.dart';
import 'package:task_management/view/widgets/add_assign_user.dart';
import 'package:task_management/view/widgets/add_lead_contact.dart';
import 'package:task_management/view/widgets/assign_user.dart';
import 'package:task_management/view/widgets/customAudioPlayer.dart';
import 'package:task_management/view/widgets/followup_list.dart';
import 'package:task_management/view/widgets/lead_discussion_list.dart';
import 'package:task_management/view/widgets/lead_overview_document_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'meeting/get_meeting.dart';

class LeadOverviewScreen extends StatefulWidget {
  final dynamic leadId;
  final int? index;
  final String? leadNumber;
  const LeadOverviewScreen({
    super.key,
    required this.leadId,
    this.index,
    this.leadNumber,
  });

  @override
  State<LeadOverviewScreen> createState() => _LeadOverviewScreenState();
}

class _LeadOverviewScreenState extends State<LeadOverviewScreen>
    with TickerProviderStateMixin {
  List<String> priorityList = ['High', "Low"].obs;
  RxString selectedPriority = 'High'.obs;
  final LeadController leadController = Get.put(LeadController());
  late TabController _tabController;
  @override
  void initState() {
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: widget.index ?? 0);
    callingApi();
    super.initState();
  }

  void callingApi() async {
    print('leadoverview lead id ${widget.leadId}');
    print('leadoverview lead id ${widget.leadNumber}');
    await leadController.leadContactList(
        leadId: int.parse(widget.leadId.toString()));
    await leadController.leadDetailsApi(
        leadId: int.parse(widget.leadId.toString()));
    await leadController.followUpsListApi(
        leadId: int.parse(widget.leadId.toString()));

    await SosPusherConfig()
        .initPusher(_onPusherEvent, channelName: "lead", context: context);
  }

  Future<void> _onPusherEvent(PusherEvent event) async {
    log("Pusher lead discussion event received: ${event.eventName} - ${event.data}");
  }

  @override
  void dispose() {
    SosPusherConfig().disconnect();
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
          "Leads Overview",
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
                leadController.isFollowupsListLoading.value == true &&
                leadController.isListVisitLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    color: whiteColor,
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/assignment_late.svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Overview',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/assignment_late.svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Followups',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/done_all (1).svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Quotation',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/done_all (1).svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Discussion',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/done_all (1).svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Notes',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/image/svg/done_all (1).svg'),
                              SizedBox(width: 5.w),
                              Text(
                                'Visits/meeting',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        leadOverview(leadController.leadDetails.value),
                        FollowUpList(
                          leadController.followUpsListData,
                          leadController.leadDetails.value,
                          widget.leadId,
                          leadController,
                        ),
                        QuotationListScreen(
                          leadId: widget.leadId,
                          leadNumber: widget.leadNumber,
                          from: "overview",
                          leadDetails: leadController.leadDetails,
                        ),
                        LeadDiscussionList(leadId: widget.leadId),
                        LeadNoteScreen(
                          leadId: widget.leadId,
                          index: 0,
                        ),
                        Obx(
                          () => GetMeetingList(
                            leadId: widget.leadId,
                            contactList: leadController.leadContactData,
                            from: "lead",
                            assignPeople: leadController
                                    .leadDetails.value?.assignedToUsers ??
                                [],
                            addPeople:
                                leadController.leadDetails.value?.addedUsers ??
                                    [],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget leadOverview(LeadDetailsData? leadDatavalue) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${leadDatavalue?.leadName ?? ""}',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
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
                                '${leadDatavalue?.company ?? ""}',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400),
                              ),
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
                                '${leadDatavalue?.phone ?? ""}',
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
                                  '${leadDatavalue?.email ?? ""}',
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
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 65.w,
                                decoration: BoxDecoration(
                                  color: meetingBoxColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: Center(
                                    child: Text(
                                      '${leadDatavalue?.statusName ?? ""}',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(
                          leadDatavalue?.createdAt != null
                              ? DateFormat('dd MMM yyyy').format(
                                  DateTime.parse(leadDatavalue!.createdAt!))
                              : "",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400),
                        )),
                        GestureDetector(
                          onTap: () async {
                            await callWhatsApp(mobileNo: leadDatavalue?.phone);
                          },
                          child: Image.asset(
                            'assets/image/png/whatsapp (2).png',
                            height: 20.h,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () async {
                            Uri phoneno =
                                Uri.parse('tel:${leadDatavalue?.phone}');
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            leadInfo(leadDatavalue),
            SizedBox(height: 15.h),
            if ((leadDatavalue?.approvalData ?? []).isNotEmpty)
              agrementWidget(leadDatavalue),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget agrementWidget(LeadDetailsData? leadDatavalue) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Document Uploaded || Successfully Added || Check and approved",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: LeadOverviewDocumentListBotomsheet(
                          leadId: widget.leadId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      color: primaryButtonColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    ),
                    child: Center(
                      child: Text(
                        'View Document',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            for (int i = 0; i < (leadDatavalue?.approvalData?.length ?? 0); i++)
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: lightGreyColor.withOpacity(0.1),
                  //     blurRadius: 6,
                  //     spreadRadius: 5,
                  //     blurStyle: BlurStyle.inner,
                  //     offset: Offset(2, 2),
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (leadDatavalue?.approvalData?[i].managerStatus
                              .toString()
                              .toLowerCase() !=
                          "pending")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Approved by Marketing Manager :',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  Expanded(
                                      child: Text(
                                    'Date',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Container(
                              height: 30.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: lightBorderColor)),
                                      child: Center(
                                        child: Text(
                                            '${leadDatavalue?.approvalData?[i].managerName ?? ""}'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: lightBorderColor)),
                                      child: Center(
                                        child: Text(
                                            '${leadDatavalue?.approvalData?.first.managerTime ?? ""}'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 10.h),
                      if (leadDatavalue?.approvalData?[i].branchheadStatus
                              .toString()
                              .toLowerCase() !=
                          "pending")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document Approved by Branch Head :',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                                child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                )),
                                Expanded(
                                    child: Text(
                                  'Date',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                )),
                              ],
                            )),
                            SizedBox(
                              height: 4.h,
                            ),
                            Container(
                              height: 40.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: lightBorderColor),
                                      ),
                                      child: Center(
                                        child: Text(
                                            '${leadDatavalue?.approvalData?.first.branchheadName ?? ""}'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: lightBorderColor)),
                                      child: Center(
                                        child: Text(
                                            '${leadDatavalue?.approvalData?.first.brancheadTime ?? ""}'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Attachment',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              height: 80.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: lightBorderColor,
                                ),
                              ),
                              child: (leadDatavalue?.approvalData?.first
                                          .branchheadAgreement !=
                                      null)
                                  ? ((leadDatavalue?.approvalData?.first
                                                      .branchheadAgreement ??
                                                  "")
                                              .toLowerCase()
                                              .endsWith('.png') ||
                                          (leadDatavalue?.approvalData?.first
                                                      .branchheadAgreement ??
                                                  "")
                                              .toLowerCase()
                                              .endsWith('.jpg') ||
                                          (leadDatavalue?.approvalData!.first
                                                      .branchheadAgreement ??
                                                  '')
                                              .toString()
                                              .toLowerCase()
                                              .endsWith('.jpeg'))
                                      ? Image.network(
                                          leadDatavalue?.approvalData?.first
                                                  .branchheadAgreement ??
                                              '',
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: InkWell(
                                            onTap: () {
                                              launchUrl(Uri.parse(leadDatavalue
                                                      ?.approvalData
                                                      ?.first
                                                      .branchheadAgreement ??
                                                  ""));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.insert_drive_file,
                                                    size: 30),
                                                SizedBox(height: 5),
                                                Text(
                                                  'View File',
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : Center(child: Text('No File')),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget leadInfo(LeadDetailsData? leadDataValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Information',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Create Date',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        leadDataValue?.createdAt != null
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(leadDataValue!.createdAt!))
                            : "",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Source',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${leadDataValue?.sourceName ?? ""}",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Owner',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                      child: Image.asset(
                        backgroundLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${leadDataValue?.ownerName ?? ""}',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                if ((leadDataValue?.image ?? "").isNotEmpty ||
                    (leadDataValue?.audio ?? "").isNotEmpty)
                  SizedBox(height: 10.h),
                if ((leadDataValue?.image ?? "").isNotEmpty ||
                    (leadDataValue?.audio ?? "").isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NetworkImageWidget(
                          imageurl: leadDataValue?.image ?? "",
                          height: 60.h,
                          width: 80.w),
                      if ((leadDataValue?.audio ?? "").isNotEmpty)
                        CustomAudioPlayer(
                          audioUrl: leadDataValue?.audio ?? '',
                          chatId: '',
                        )
                    ],
                  ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Last Modified',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        leadDataValue?.createdAt != null
                            ? DateFormat('dd MMM yyyy').format(
                                DateTime.parse(leadDataValue!.updatedAt!))
                            : "",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      'Added User',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if ((leadDataValue?.addedUsers?.length ?? 0) > 0)
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: LeadAddUserList(
                                    addUser: leadDataValue?.addedUsers ?? []),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Stack(
                              children: List.generate(
                                (leadDataValue?.addedUsers?.length ?? 0) > 3
                                    ? 4
                                    : (leadDataValue?.addedUsers?.length ?? 0),
                                (index) {
                                  if (index < 3) {
                                    final leftPosition = index == 0
                                        ? 0.0
                                        : (index == 1 ? 22.w : 44.w);
                                    final bgColor = index == 0
                                        ? redColor
                                        : index == 1
                                            ? blueColor
                                            : secondaryColor;

                                    return Positioned(
                                      left: leftPosition,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          child: Image.network(
                                            '${leadDataValue?.addedUsers?[index].image ?? ""}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.r)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final extraCount =
                                        (leadDataValue?.addedUsers?.length ??
                                                0) -
                                            3;
                                    return Positioned(
                                      left: 65.w,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: primaryButtonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+$extraCount',
                                            style: changeTextColor(
                                                heading9, whiteColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
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
                Row(
                  children: [
                    Text(
                      'Assigned User',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if ((leadDataValue?.assignedToUsers?.length ?? 0) > 0)
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: LeadAssignUserList(
                                    assignUser:
                                        leadDataValue?.assignedToUsers ?? []),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Stack(
                              children: List.generate(
                                (leadDataValue?.assignedToUsers?.length ?? 0) >
                                        3
                                    ? 4
                                    : (leadDataValue?.assignedToUsers?.length ??
                                        0),
                                (index) {
                                  if (index < 3) {
                                    final leftPosition = index == 0
                                        ? 0.0
                                        : (index == 1 ? 22.w : 44.w);
                                    final bgColor = index == 0
                                        ? redColor
                                        : index == 1
                                            ? blueColor
                                            : secondaryColor;

                                    return Positioned(
                                      left: leftPosition,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          child: Image.network(
                                            '${leadDataValue?.assignedToUsers?[index].image ?? ""}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.r)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final extraCount = (leadDataValue
                                                ?.assignedToUsers?.length ??
                                            0) -
                                        3;
                                    return Positioned(
                                      left: 65.w,
                                      child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: primaryButtonColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+$extraCount',
                                            style: changeTextColor(
                                                heading9, whiteColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddLeadContactShet(leadId: widget.leadId),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: blueColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: blueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Add New',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: blueColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                if (leadController.leadContactData.length > 0)
                  Obx(
                    () => leadController.isLeadContactLoading.value == true
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              for (int i = 0;
                                  i < leadController.leadContactData.length;
                                  i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 35.h,
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.r),
                                          ),
                                        ),
                                        child: Image.asset(
                                          backgroundLogo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${leadController.leadContactData[i].name ?? ""}',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget visitList(List<ListVisitData> visitDatavalue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          SizedBox(height: 10.h),
          Expanded(
            child: visitDatavalue.isEmpty
                ? Center(
                    child: Text(
                      "No visit data",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: visitDatavalue.length,
                    itemBuilder: (context, index) {
                      final item = visitDatavalue[index];

                      String formattedDate = '';
                      if (item.createdAt != null) {
                        DateTime date = DateTime.parse(item.createdAt!);
                        formattedDate =
                            DateFormat('dd MMM yyyy, hh:mm a').format(date);
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Visitor Name & Type
                            Row(
                              children: [
                                Icon(Icons.person,
                                    size: 18.sp, color: Colors.blue),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    '${item.visitorName ?? "No Name"} (${item.visitTypeName ?? "Visit"})',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Phone and Email
                            Row(
                              children: [
                                Icon(Icons.phone,
                                    color: Colors.green, size: 18.sp),
                                SizedBox(width: 6.w),
                                Text(item.visitorPhone ?? '',
                                    style: TextStyle(fontSize: 13.sp)),
                                SizedBox(
                                  width: 35.w,
                                ),
                                Icon(Icons.email,
                                    color: Colors.orange, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.visitorEmail ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Address
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.red, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.address ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Description
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.notes,
                                    color: Colors.teal, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(item.description ?? '',
                                      style: TextStyle(fontSize: 13.sp)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            /// Visit Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18.sp, color: Colors.deepPurple),
                                SizedBox(width: 6.w),
                                Text('Visited on: $formattedDate',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontStyle: FontStyle.italic)),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await callWhatsApp(
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
                                    Uri phoneno = Uri.parse(
                                        'tel:${leadController.leadsListData[index].phone}');
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
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

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
