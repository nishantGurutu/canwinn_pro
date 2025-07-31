import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:task_management/view/widgets/image_screen.dart';

class HumanGatepassDetails extends StatefulWidget {
  final String humanGatePassListPendingData;
  final String from;
  const HumanGatepassDetails(this.humanGatePassListPendingData,
      {super.key, required this.from});

  @override
  State<HumanGatepassDetails> createState() => _HumanGatepassDetailsState();
}

class _HumanGatepassDetailsState extends State<HumanGatepassDetails> {
  final EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  @override
  void initState() {
    log('human gate pass id in details ${widget.humanGatePassListPendingData}');
    employeeFormController.humanGatePassDetails(
        id: widget.humanGatePassListPendingData);
    super.initState();
  }

  String formatOutTime(String inputDateTime) {
    try {
      final DateTime parsedDate =
          DateFormat("yyyy-MM-dd HH:mm").parse(inputDateTime);
      return DateFormat("yyyy-MM-dd hh:mm a").format(parsedDate);
    } catch (e) {
      return inputDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
        title: Text(
          'Gatepass Details',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
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
      body: Obx(
        () => employeeFormController.isdetailsLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    Card(
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      '${employeeFormController.humanGatepassDetailsData['proof_image'] ?? ""}',
                                      height: 55.h,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: SvgPicture.asset(
                                            brokenIcon,
                                            fit: BoxFit.cover,
                                            height: 55.h,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  '${employeeFormController.humanGatepassDetailsData['gatepass_id'] ?? ""}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Name : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['name'] ?? ""}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'EMP ID : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['employee_id'] ?? ""}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Mobile  : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['mobile'] ?? ""}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'destination  : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['purpose_of_visit'] ?? ''}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Purpose of visit  : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['purpose_of_visit'] ?? ''}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Description  : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['description'] ?? ""}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                if (employeeFormController
                                                .humanGatepassDetailsData[
                                            'dept_head_status'] ==
                                        1 ||
                                    employeeFormController
                                                .humanGatepassDetailsData[
                                            'dept_head_status'] ==
                                        2)
                                  SizedBox(height: 4),
                                if (employeeFormController
                                                .humanGatepassDetailsData[
                                            'dept_head_status'] ==
                                        1 ||
                                    employeeFormController
                                                .humanGatepassDetailsData[
                                            'dept_head_status'] ==
                                        2)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${employeeFormController.humanGatepassDetailsData['dept_head_status'] == 1 ? "Department Approve Time" : employeeFormController.humanGatepassDetailsData['dept_head_status'] == 2 ? "Department Reject Time" : ''}  : ',
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 12.sp),
                                        ),
                                        TextSpan(
                                          text:
                                              '${employeeFormController.humanGatepassDetailsData['dept_approve_reject_time'] ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xff676767),
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (employeeFormController
                                                .humanGatepassDetailsData[
                                            'hr_approve_reject_time'] ==
                                        1 ||
                                    employeeFormController
                                                .humanGatepassDetailsData[
                                            'hr_approve_reject_time'] ==
                                        2)
                                  SizedBox(height: 4),
                                if (employeeFormController
                                                .humanGatepassDetailsData[
                                            'hr_head_status'] ==
                                        1 ||
                                    employeeFormController
                                                .humanGatepassDetailsData[
                                            'hr_head_status'] ==
                                        2)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${employeeFormController.humanGatepassDetailsData['hr_head_status'] == 1 ? "HR Approve Time" : employeeFormController.humanGatepassDetailsData['hr_head_status'] == 2 ? "HR Reject Time" : ''}  : ',
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 12.sp),
                                        ),
                                        TextSpan(
                                          text:
                                              '${employeeFormController.humanGatepassDetailsData['hr_approve_reject_time'] ?? ""}',
                                          style: TextStyle(
                                              color: Color(0xff676767),
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Security  : ',
                                        style: TextStyle(
                                            color: textColor, fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text:
                                            '${employeeFormController.humanGatepassDetailsData['security_head_name'] ?? ""}',
                                        style: TextStyle(
                                            color: Color(0xff676767),
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: widget.from == 'denied'
                                  ? Color(0xffFFC3C3)
                                  : Color(0xffE3FFE4),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r),
                              ),
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.from == 'denied'
                                        ? "Denied By : "
                                        : 'Approved By : ',
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Human Resource Manager ',
                                        style: TextStyle(
                                            color: Color(0xff1B2A64),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Team Leader',
                                        style: TextStyle(
                                            color: Color(0xff1B2A64),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${employeeFormController.humanGatepassDetailsData['hr_head_name'] ?? ''}',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${employeeFormController.humanGatepassDetailsData['dept_head_name'] ?? ''}',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  if (widget.from == 'denied')
                                    Divider(
                                      color: Color(0xffFFC3C3),
                                    ),
                                  if (widget.from == 'approve')
                                    Divider(
                                      color: Color(0xffBEFFC0),
                                    ),
                                  if (widget.from == 'denied')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'HR Remark : ',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${employeeFormController.humanGatepassDetailsData['hr_remarks'] ?? ''}',
                                                style: TextStyle(
                                                    color: Color(0xff676767),
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Department Remark : ',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${employeeFormController.humanGatepassDetailsData['dept_remarks'] ?? ''}',
                                                style: TextStyle(
                                                    color: Color(0xff676767),
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                      ],
                                    ),
                                  if (widget.from == 'approve')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Punch Out Time : ',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${formatOutTime(employeeFormController.humanGatepassDetailsData['actual_out_time'] ?? '')}',
                                                style: TextStyle(
                                                    color: Color(0xff676767),
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Punch In Time : ',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${formatOutTime(employeeFormController.humanGatepassDetailsData['actual_in_time'] ?? '')}',
                                                style: TextStyle(
                                                    color: Color(0xff676767),
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
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
                  '${employeeFormController.humanGatepassDetailsData['gatepass_id'] ?? ""}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Name : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['name'] ?? ""}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'EMP ID : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['employee_id'] ?? ""}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Mobile  : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['mobile'] ?? ""}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'destination  : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['purpose_of_visit'] ?? ''}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Purpose of visit  : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['purpose_of_visit'] ?? ''}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Description  : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['description'] ?? ""}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                if (employeeFormController
                            .humanGatepassDetailsData['dept_head_status'] ==
                        1 ||
                    employeeFormController
                            .humanGatepassDetailsData['dept_head_status'] ==
                        2)
                  pw.SizedBox(height: 4),
                if (employeeFormController
                            .humanGatepassDetailsData['dept_head_status'] ==
                        1 ||
                    employeeFormController
                            .humanGatepassDetailsData['dept_head_status'] ==
                        2)
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text:
                              '${employeeFormController.humanGatepassDetailsData['dept_head_status'] == 1 ? "Department Approve Time" : employeeFormController.humanGatepassDetailsData['dept_head_status'] == 2 ? "Department Reject Time" : ''}  : ',
                          style: pw.TextStyle(fontSize: 12.sp),
                        ),
                        pw.TextSpan(
                          text:
                              '${employeeFormController.humanGatepassDetailsData['dept_approve_reject_time'] ?? ""}',
                          style: pw.TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                if (employeeFormController.humanGatepassDetailsData[
                            'hr_approve_reject_time'] ==
                        1 ||
                    employeeFormController.humanGatepassDetailsData[
                            'hr_approve_reject_time'] ==
                        2)
                  pw.SizedBox(height: 4),
                if (employeeFormController
                            .humanGatepassDetailsData['hr_head_status'] ==
                        1 ||
                    employeeFormController
                            .humanGatepassDetailsData['hr_head_status'] ==
                        2)
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text:
                              '${employeeFormController.humanGatepassDetailsData['hr_head_status'] == 1 ? "HR Approve Time" : employeeFormController.humanGatepassDetailsData['hr_head_status'] == 2 ? "HR Reject Time" : ''}  : ',
                          style: pw.TextStyle(fontSize: 12.sp),
                        ),
                        pw.TextSpan(
                          text:
                              '${employeeFormController.humanGatepassDetailsData['hr_approve_reject_time'] ?? ""}',
                          style: pw.TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                pw.SizedBox(height: 4),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Security : ',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                      pw.TextSpan(
                        text:
                            '${employeeFormController.humanGatepassDetailsData['security_head_name'] ?? ""}',
                        style: pw.TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Approved By : ',
                        style: pw.TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Human Resource Manager ',
                            style: pw.TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                          pw.Text(
                            'Team Leader',
                            style: pw.TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            '${employeeFormController.humanGatepassDetailsData['hr_head_name'] ?? ''}',
                            style: pw.TextStyle(fontSize: 12.sp),
                          ),
                          pw.Text(
                            '${employeeFormController.humanGatepassDetailsData['dept_head_name'] ?? ''}',
                            style: pw.TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                      pw.Divider(),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                  text: 'Punch Out Time : ',
                                  style: pw.TextStyle(fontSize: 12.sp),
                                ),
                                pw.TextSpan(
                                  text:
                                      '${formatOutTime(employeeFormController.humanGatepassDetailsData['actual_out_time'] ?? '')}',
                                  style: pw.TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            height: 5.h,
                          ),
                          pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                pw.TextSpan(
                                  text: 'Punch In Time : ',
                                  style: pw.TextStyle(fontSize: 12.sp),
                                ),
                                pw.TextSpan(
                                  text:
                                      '${formatOutTime(employeeFormController.humanGatepassDetailsData['actual_in_time'] ?? '')}',
                                  style: pw.TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    ],
                  ),
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
    } else {}
  }
}
