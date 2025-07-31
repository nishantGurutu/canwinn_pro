import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

class InChalanDetails extends StatefulWidget {
  final String chalanId;
  const InChalanDetails(this.chalanId, {super.key});

  @override
  State<InChalanDetails> createState() => _InChalanDetailsState();
}

class _InChalanDetailsState extends State<InChalanDetails> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    outScreenController.chalanId = int.parse(widget.chalanId.toString());
    outScreenController.inChalanDetails();
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
          chalanDetails,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: Obx(
            () => outScreenController.outScreenChalanDetailsModel.value == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  )
                : Padding(
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.h,
                              children: [
                                Column(
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
                                          child: GestureDetector(
                                            onTap: () {
                                              openFile(outScreenController
                                                      .inScreenChalanDetailsModel
                                                      .value
                                                      ?.data
                                                      ?.uploadImage ??
                                                  "");
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.r),
                                              ),
                                              child: Image.network(
                                                "${outScreenController.inScreenChalanDetailsModel.value?.data?.uploadImage ?? ""}",
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
                                                "Chalan Number : ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}",
                                                style: heading9,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Department Name :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment ?? ""}',
                                                style: heading9,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Text(
                                                'Address :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.address ?? ""}',
                                                style: heading9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Purpose :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.purpose ?? ""}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Visitor Name :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.name ?? ""}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Security Name :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.securityName ?? ""}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Status :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Chalan approved by ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment} (${outScreenController.inScreenChalanDetailsModel.value?.data?.departmentUsername})" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "Gate pass IN successfully." : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Chalan reject by ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment} (${outScreenController.inScreenChalanDetailsModel.value?.data?.departmentUsername})" : ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (outScreenController
                                                .inScreenChalanDetailsModel
                                                .value
                                                ?.data
                                                ?.status
                                                .toString() ==
                                            '1' ||
                                        outScreenController
                                                .inScreenChalanDetailsModel
                                                .value
                                                ?.data
                                                ?.status
                                                .toString() ==
                                            '2')
                                      Column(
                                        children: [
                                          SizedBox(height: 5.h),
                                          Text(
                                            '${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : ""} Time :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.deptApproveRejectTime}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
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
                                          width: 170.w,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/image/svg/calendar_today (1).svg'),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "${outScreenController.inScreenChalanDetailsModel.value?.data?.challanCreateTime ?? ""}",
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
                                                "${outScreenController.inScreenChalanDetailsModel.value?.data?.contact ?? ""}",
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        if (StorageHelper.getDepartmentId() == 12 &&
                            outScreenController.inScreenChalanDetailsModel.value
                                    ?.data?.status
                                    .toString() !=
                                '4')
                          if (outScreenController.inScreenChalanDetailsModel
                                  .value?.data?.status
                                  .toString() !=
                              "5")
                            if (outScreenController.inScreenChalanDetailsModel
                                    .value?.data?.status
                                    .toString() ==
                                "1")
                              InkWell(
                                onTap: () {
                                  if (outScreenController
                                          .inScreenChalanDetailsModel
                                          .value
                                          ?.data
                                          ?.status
                                          .toString() !=
                                      "5") {
                                    showAlertDialog(
                                      context,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
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
                        SizedBox(height: 15.h),
                        Column(
                          children: [
                            StorageHelper.getDepartmentId() == 7
                                ? Column(
                                    children: [
                                      CustomTextField(
                                        enable: outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.status
                                                    .toString() ==
                                                "0"
                                            ? true
                                            : StorageHelper.getDepartmentId() ==
                                                        12 &&
                                                    outScreenController
                                                            .inScreenChalanDetailsModel
                                                            .value
                                                            ?.data
                                                            ?.status
                                                            .toString() ==
                                                        '3'
                                                ? true
                                                : false,
                                        controller:
                                            rejectRemarkTextEditingController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        hintText: remark,
                                      ),
                                      SizedBox(height: 15.h),
                                    ],
                                  )
                                : SizedBox(),
                            StorageHelper.getDepartmentId() != 12
                                ? SizedBox(height: 10.h)
                                : SizedBox(),
                            StorageHelper.getDepartmentId() != 12 &&
                                    StorageHelper.getDepartmentId() != 11
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            if (StorageHelper
                                                        .getDepartmentId() ==
                                                    7 &&
                                                outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    '0') {
                                              outScreenController
                                                  .inupdateStatus(
                                                outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.id,
                                                1,
                                                rejectRemarkTextEditingController
                                                    .text,
                                              );
                                              rejectRemarkTextEditingController
                                                  .clear();
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    '0'
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
                                                  rubikBlack, textColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            if (outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0" ||
                                                StorageHelper
                                                            .getDepartmentId() ==
                                                        7 &&
                                                    outScreenController
                                                            .inScreenChalanDetailsModel
                                                            .value
                                                            ?.data
                                                            ?.status
                                                            .toString() ==
                                                        "0") {
                                              outScreenController
                                                  .inupdateStatus(
                                                outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.id,
                                                2,
                                                rejectRemarkTextEditingController
                                                    .text,
                                              );
                                              rejectRemarkTextEditingController
                                                  .clear();
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    '0'
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
                                                  rubikBlack, textColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        if (StorageHelper.getDepartmentId() == 12 &&
                            outScreenController.inScreenChalanDetailsModel.value
                                    ?.data?.status
                                    .toString() !=
                                '4')
                          InkWell(
                            onTap: () {
                              if (outScreenController.inScreenChalanDetailsModel
                                      .value?.data?.status
                                      .toString() ==
                                  "1") {
                                outScreenController.inupdateStatus(
                                  outScreenController.inScreenChalanDetailsModel
                                      .value?.data?.id,
                                  3,
                                  rejectRemarkTextEditingController.text,
                                );
                                rejectRemarkTextEditingController.clear();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: outScreenController
                                            .inScreenChalanDetailsModel
                                            .value
                                            ?.data
                                            ?.status
                                            .toString() ==
                                        "1"
                                    ? secondaryColor
                                    : lightSecondaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  inButton,
                                  style:
                                      changeTextColor(robotoBlack, whiteColor),
                                ),
                              ),
                            ),
                          ),
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
      print('Error picking image: $e');
    } finally {
      outScreenController.isChalanPicUploading.value = false;
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

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
                    'Chalan Number: ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    'Visitor Name: ${outScreenController.inScreenChalanDetailsModel.value?.data?.name ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Visitor Contact: ${outScreenController.inScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Secutity Name: ${outScreenController.inScreenChalanDetailsModel.value?.data?.securityName ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Created Time: ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanCreateTime ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Department: ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Address: ${outScreenController.inScreenChalanDetailsModel.value?.data?.address ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Purpose: ${outScreenController.inScreenChalanDetailsModel.value?.data?.purpose ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Status :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Chalan approved by ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment} (${outScreenController.inScreenChalanDetailsModel.value?.data?.departmentUsername})" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "Gate pass IN successfully." : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Chalan reject by ${outScreenController.inScreenChalanDetailsModel.value?.data?.entryToDepartment} (${outScreenController.inScreenChalanDetailsModel.value?.data?.departmentUsername})" : ''}',
                    style: pw.TextStyle(fontSize: 16)),
                if (outScreenController
                            .inScreenChalanDetailsModel.value?.data?.status
                            .toString() ==
                        '1' ||
                    outScreenController
                            .inScreenChalanDetailsModel.value?.data?.status
                            .toString() ==
                        '2')
                  pw.Text(
                      '${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : ''} Time :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.deptApproveRejectTime}',
                      style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
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
