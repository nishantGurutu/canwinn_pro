import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/report_controller.dart';
import 'package:task_management/model/report_model.dart';
import 'package:task_management/view/widgets/pdf_generate.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportController reportController = Get.put(ReportController());
  @override
  void initState() {
    reportController.reportApi('', '');
    super.initState();
  }

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreyColor,
      body: Obx(
        () => reportController.isReportingLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              'My Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${reportController.reportModelData.value?.data?.completedTask ?? ""}',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Completed Task',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'From Date',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150.w,
                                            child: TextField(
                                              controller: fromDateController,
                                              decoration: InputDecoration(
                                                fillColor: lightSecondaryColor,
                                                filled: true,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(9.0),
                                                  child: Image.asset(
                                                    'assets/images/png/callender.png',
                                                    color: secondaryColor,
                                                    height: 10.h,
                                                  ),
                                                ),
                                                hintText: dateFormate,
                                                hintStyle: rubikRegular,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          lightSecondaryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.r)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          lightSecondaryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.r)),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          lightSecondaryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.r)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          lightSecondaryColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.r)),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.w,
                                                        vertical: 10.h),
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2100),
                                                );

                                                if (pickedDate != null) {
                                                  String formattedDate =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(pickedDate);
                                                  fromDateController.text =
                                                      formattedDate;
                                                  await reportController
                                                      .reportApi(
                                                          fromDateController
                                                              .text,
                                                          toDateController
                                                              .text);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'To Date',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150.w,
                                            child: SizedBox(
                                              width: 150.w,
                                              child: TextField(
                                                controller: toDateController,
                                                decoration: InputDecoration(
                                                  fillColor:
                                                      lightSecondaryColor,
                                                  filled: true,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            9.0),
                                                    child: Image.asset(
                                                      'assets/images/png/callender.png',
                                                      color: secondaryColor,
                                                      height: 10.h,
                                                    ),
                                                  ),
                                                  hintText: dateFormate,
                                                  hintStyle: rubikRegular,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            lightSecondaryColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r)),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            lightSecondaryColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r)),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            lightSecondaryColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            lightSecondaryColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.r)),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10.w,
                                                          vertical: 10.h),
                                                ),
                                                readOnly: true,
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100),
                                                  );

                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(pickedDate);
                                                    toDateController.text =
                                                        formattedDate;
                                                    await reportController
                                                        .reportApi(
                                                            fromDateController
                                                                .text,
                                                            toDateController
                                                                .text);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${reportController.reportModelData.value?.data?.avgCompletedTask ?? ""}%',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Text(
                                        '${reportController.selectedReport?.value} *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          final pdfGenerator = CustomPdf(
                                              reportController
                                                  .reportModelData.value?.data);
                                          await pdfGenerator.generatePDF();
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(22.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Download',
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  chartWidget(reportController
                                      .reportModelData.value?.data?.weekly),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.sp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Task Status",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Total Task',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: secondTextColor),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: secondaryColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${reportController.reportModelData.value?.data?.totalTask ?? ""}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Complete Task',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: secondTextColor),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: blueColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${reportController.reportModelData.value?.data?.completedTask ?? ""}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: thirdPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Progress Task',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: secondTextColor),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: thirdPrimaryColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${reportController.reportModelData.value?.data?.progressTask ?? ""}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: thirdPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: redColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.done,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Pending Task',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: secondTextColor),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: redColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${reportController.reportModelData.value?.data?.newTask ?? ""}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: redColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget chartWidget(Weekly? weekly) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Container(
                    height: weekly?.sunday == null ? 10.h : weekly?.sunday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'S',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height: weekly?.monday == null ? 10.h : weekly?.monday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'M',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height: weekly?.tuesday == null ? 10.h : weekly?.tuesday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: mediumColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'T',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height:
                        weekly?.wednesday == null ? 10.h : weekly?.wednesday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'W',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height:
                        weekly?.thursday == null ? 10.h : weekly?.thursday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'T',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height: weekly?.friday == null ? 10.h : weekly?.friday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'F',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                children: [
                  Container(
                    height:
                        weekly?.saturday == null ? 10.h : weekly?.saturday?.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'S',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
