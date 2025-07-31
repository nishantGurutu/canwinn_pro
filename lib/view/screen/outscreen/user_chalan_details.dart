// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:task_management/view/widgets/image_screen.dart';

class UserChalanDetails extends StatefulWidget {
  final dynamic chalanList;
  const UserChalanDetails(this.chalanList, {super.key});

  @override
  State<UserChalanDetails> createState() => _UserChalanDetailsState();
}

class _UserChalanDetailsState extends State<UserChalanDetails> {
  final OutScreenController outScreenController = Get.find();
  @override
  initState() {
    super.initState();
    outScreenController.chalanId = widget.chalanList['id'] ?? 0;
    outScreenController.outChalanDetails();
  }

  String formatDateTime(String apiDate) {
    try {
      DateTime dateTime = DateTime.parse(apiDate).toLocal();
      return DateFormat('d MMM y h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
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
          "${widget.chalanList['challan_number'] ?? ''}",
          style: TextStyle(
              color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              generatePdf();
            },
            icon: Icon(
              Icons.download,
            ),
          )
        ],
      ),
      backgroundColor: whiteColor,
      body: Container(
        height: double.infinity,
        color: backgroundColor,
        child: Obx(
          () => outScreenController.isChalanDetailsUpdating.value == true
              ? Center(child: SingleChildScrollView())
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: lightGreyColor.withOpacity(0.2),
                                blurRadius: 13.0,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.h,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 66.h,
                                          width: 66.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xffF4F4F4),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                openFile(outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.uploadImagePath ??
                                                    "");
                                              },
                                              child: Image.network(
                                                "${outScreenController.outScreenChalanDetailsModel.value?.data?.uploadImagePath ?? ""}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: SvgPicture.asset(
                                                      brokenIcon,
                                                      fit: BoxFit.cover,
                                                      height: 37.h,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6.w,
                                        ),
                                        Container(
                                          width: 240.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Chalan Number : ${outScreenController.outScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}",
                                                style: heading9,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Department Name :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.departmentName ?? ""}',
                                                style: heading9,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Dispatch To :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.dispatchTo ?? ""}',
                                                style: heading9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150.w,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/image/svg/calendar_today (1).svg'),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "${formatDateTime(outScreenController.outScreenChalanDetailsModel.value?.data?.createdAt ?? '')}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/image/svg/contact_phone (1).svg'),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "${outScreenController.outScreenChalanDetailsModel.value?.data?.contact ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Status :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "OUT" : ""}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      'HR ${outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? " Approve" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? " Reject" : ""} Time :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.hrApproveRejectTime ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      'OUT Time :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.outTime ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: backgroundColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                height: 200.h,
                                child: Obx(
                                  () => ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.r),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                lightGreyColor.withOpacity(0.2),
                                            blurRadius: 8.0,
                                            spreadRadius: 4,
                                            blurStyle: BlurStyle.inner,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: DataTable2(
                                        columnSpacing: 12,
                                        horizontalMargin: 12,
                                        minWidth: 600.w,
                                        decoration:
                                            BoxDecoration(color: whiteColor),
                                        columns: [
                                          DataColumn2(
                                              label: Text('S. No.'),
                                              size: ColumnSize.S,
                                              fixedWidth: 50.0),
                                          DataColumn2(
                                              label: Text('Items'),
                                              size: ColumnSize.S,
                                              fixedWidth: 150.0),
                                          DataColumn2(
                                              label: Text(
                                                  'RETURNABLE/NON-RETURNABLE'),
                                              size: ColumnSize.L,
                                              fixedWidth: 220.0),
                                          DataColumn2(
                                              label: Text('QTY'),
                                              size: ColumnSize.S,
                                              fixedWidth: 40.0),
                                          DataColumn2(
                                              label: Text('REMARKS'),
                                              size: ColumnSize.S,
                                              numeric: true,
                                              fixedWidth: 70.0),
                                        ],
                                        rows: List<DataRow>.generate(
                                          outScreenController
                                                  .outScreenChalanDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.items
                                                  ?.length ??
                                              0,
                                          (index) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  '${index + 1}',
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].itemName ?? ""}'),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].isReturnable.toString() == '0' ? "RETURNABLE" : "NON-RETURNABLE"}'),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].quantity ?? ""}'),
                                              ),
                                              DataCell(
                                                Text(
                                                    '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].remarks ?? ""}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: backgroundColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                height: 90.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600.w,
                                    decoration:
                                        BoxDecoration(color: whiteColor),
                                    columns: [
                                      DataColumn2(
                                          label: Text('PREPARED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 120.0),
                                      DataColumn2(
                                          label: Text('APPROVED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 120.0),
                                      DataColumn2(
                                          label: Text('RECEIVED BY'),
                                          size: ColumnSize.S,
                                          fixedWidth: 110.0),
                                    ],
                                    rows: List<DataRow>.generate(
                                      1,
                                      (index2) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.preparedBy ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.approvedBy ?? ""}'),
                                          ),
                                          DataCell(
                                            outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "3"
                                                ? Text(
                                                    '${outScreenController.outScreenChalanDetailsModel.value?.data?.receivedBy ?? ""}')
                                                : Text(''),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (StorageHelper.getDepartmentId() == 12 &&
                            outScreenController.outScreenChalanDetailsModel
                                    .value?.data?.status
                                    .toString() !=
                                "2")
                          InkWell(
                            onTap: () {
                              if (outScreenController
                                      .outScreenChalanDetailsModel
                                      .value
                                      ?.data
                                      ?.status
                                      .toString() !=
                                  "3") {
                                showAlertDialog(
                                  context,
                                );
                              }
                            },
                            child: Container(
                              height: 40.h,
                              width: 200.w,
                              decoration: BoxDecoration(
                                color: outScreenController
                                            .outScreenChalanDetailsModel
                                            .value
                                            ?.data
                                            ?.status
                                            .toString() ==
                                        "3"
                                    ? lightSecondaryColor
                                    : secondaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add Attachment',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: whiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Icon(
                                    Icons.attachment,
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 10.h),
                        StorageHelper.getDepartmentId() == 11
                            ? Column(
                                children: [
                                  CustomTextField(
                                    controller: outScreenController
                                        .rejectRemarkTextEditingController
                                        .value,
                                    enable: outScreenController
                                                .outScreenChalanDetailsModel
                                                .value
                                                ?.data
                                                ?.status
                                                .toString() ==
                                            "0"
                                        ? true
                                        : false,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    hintText: rejectRemark,
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .outScreenChalanDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.status
                                                  .toString() ==
                                              "0") {
                                            if (outScreenController
                                                    .isStatusUpdating.value ==
                                                false) {
                                              outScreenController.updateStatus(
                                                outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.id ??
                                                    0,
                                                1,
                                                outScreenController
                                                    .rejectRemarkTextEditingController
                                                    .value
                                                    .text,
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0"
                                                ? secondaryColor
                                                : lightSecondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              approve,
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .outScreenChalanDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.status
                                                  .toString() ==
                                              "0") {
                                            if (outScreenController
                                                    .isStatusUpdating.value ==
                                                false) {
                                              outScreenController.updateStatus(
                                                outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.id ??
                                                    0,
                                                2,
                                                outScreenController
                                                    .rejectRemarkTextEditingController
                                                    .value
                                                    .text,
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .outScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0"
                                                ? secondaryColor
                                                : lightSecondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              reject,
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : SizedBox(),
                        StorageHelper.getDepartmentId() == 12 &&
                                outScreenController.outScreenChalanDetailsModel
                                        .value?.data?.status
                                        .toString() !=
                                    '2'
                            ? Column(
                                children: [
                                  SizedBox(height: 10.h),
                                  InkWell(
                                    onTap: () {
                                      if (outScreenController
                                              .outScreenChalanDetailsModel
                                              .value
                                              ?.data
                                              ?.status
                                              .toString() !=
                                          "3") {
                                        outScreenController.updateStatus(
                                          outScreenController
                                                  .outScreenChalanDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.id ??
                                              0,
                                          3,
                                          '',
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: outScreenController
                                                    .outScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.status
                                                    .toString() ==
                                                "3"
                                            ? lightSecondaryColor
                                            : secondaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          out,
                                          style: changeTextColor(
                                              rubikBlack, whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.sp),
            child: Container(
              width: double.infinity,
              height: 140.h,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            takeAttachment(ImageSource.gallery);
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
                                Image.asset(
                                  'assets/images/png/gallery-icon-removebg-preview.png',
                                  height: 20.h,
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            takeAttachment(ImageSource.camera);
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
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final ImagePicker imagePicker = ImagePicker();
  Future<void> takeAttachment(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      Get.back();
      outScreenController.isChalanPicUploading.value = true;
      outScreenController.pickedFile.value = File(pickedImage.path);
      outScreenController.chalanPicPath.value = pickedImage.path.toString();
      outScreenController.isChalanPicUploading.value = false;
    } catch (e) {
      outScreenController.isChalanPicUploading.value = false;
    } finally {
      outScreenController.isChalanPicUploading.value = false;
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    Future<pw.Font> loadFont() async {
      final fontData =
          await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
      return pw.Font.ttf(fontData);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 1),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    'Chalan Number: ${outScreenController.outScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    'Date: ${formatDateTime(outScreenController.outScreenChalanDetailsModel.value?.data?.createdAt ?? '')}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Text(
                    'Department Name: ${outScreenController.outScreenChalanDetailsModel.value?.data?.departmentName ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Dispatch To: ${outScreenController.outScreenChalanDetailsModel.value?.data?.dispatchTo ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Contact: ${outScreenController.outScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Status: ${outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "OUT" : ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['S. No.', 'Items', 'Type', 'QTY', 'Remarks'],
                  data: List<List<String>>.generate(
                    outScreenController.outScreenChalanDetailsModel.value?.data
                            ?.items?.length ??
                        0,
                    (index) => [
                      '${index + 1}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].itemName ?? ""}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].isReturnable == 0 ? "RETURNABLE" : "NON-RETURNABLE"}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].quantity ?? ""}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index].remarks ?? ""}',
                    ],
                  ),
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['PREPARED BY', 'APPROVED BY', 'RECEIVED BY'],
                  data: [
                    [
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.preparedBy ?? ""}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.approvedBy ?? ""}',
                      '${outScreenController.outScreenChalanDetailsModel.value?.data?.status == 3 ? outScreenController.outScreenChalanDetailsModel.value?.data?.receivedBy ?? "" : ""}',
                    ]
                  ],
                  cellAlignment: pw.Alignment.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final folderPath = directory.path;

    final now = DateTime.now();
    final formattedDate =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
    final fileName = 'chalan_${formattedDate}.pdf';
    final filePath = '$folderPath/$fileName';
    print('afc agfgadg agfag $fileName');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (await file.exists()) {
      await downloadPDF(filePath);
    }
  }

  Future<void> downloadPDF(String filePath) async {
    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
      final downloadPath =
          '/storage/emulated/0/Download/chalan$formattedDate.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        final downloadFile = File(downloadPath);

        if (await downloadFile.exists()) {
          await downloadFile.delete();
        }

        await file.copy(downloadPath);
        Fluttertoast.showToast(
          msg: 'Download in download folder',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      } else {}
    } catch (e) {}
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Unsupported file type.')),
      // );
    }
  }
}
