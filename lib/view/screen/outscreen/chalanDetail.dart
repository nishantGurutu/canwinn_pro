import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/outScreenChalanListModel.dart';

class ChalanDetails extends StatefulWidget {
  final ChalanData chalanList;
  final String from;
  const ChalanDetails(this.chalanList, this.from, {super.key});

  @override
  State<ChalanDetails> createState() => _ChalanDetailsState();
}

class _ChalanDetailsState extends State<ChalanDetails> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    outScreenController.chalanId = widget.chalanList.id ?? 0;
    outScreenController.outChalanDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
      ),
      backgroundColor: whiteColor,
      body: Container(
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
                              spacing: 8.h,
                              children: [
                                Text(
                                  'Chalan Number :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.date ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  width: 100.w,
                                  child: Image.network(
                                    outScreenController
                                            .outScreenChalanDetailsModel
                                            .value
                                            ?.data
                                            ?.uploadImagePath ??
                                        "",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                        ),
                                        child: Image.asset(backgroundLogo),
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  'Department Name :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.departmentName ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Dispatch To :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.dispatchTo ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Contact :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Status :- ${outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    decoration: BoxDecoration(
                                        color: lightSecondaryColor),
                                    columns: [
                                      DataColumn2(
                                          label: Text('S. No.'),
                                          size: ColumnSize.S,
                                          fixedWidth: 50.0),
                                      DataColumn2(
                                          label: Text('Items'),
                                          size: ColumnSize.S),
                                      DataColumn2(
                                          label:
                                              Text('RETURNABLE/NON-RETURNABLE'),
                                          size: ColumnSize.L),
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
                                      (index2) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index2].id ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index2].itemName ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index2].isReturnable ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index2].quantity ?? ""}'),
                                          ),
                                          DataCell(
                                            Text(
                                                '${outScreenController.outScreenChalanDetailsModel.value?.data?.items?[index2].remarks ?? ""}'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 90.h,
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600.w,
                                    decoration: BoxDecoration(
                                        color: lightSecondaryColor),
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
                                                    '3'
                                                ? Text(
                                                    '${outScreenController.outScreenChalanDetailsModel.value?.data?.receivedBy ?? ""}')
                                                : Text(''),
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
                        SizedBox(height: 30.h),
                        if (widget.from == "security")
                          InkWell(
                            onTap: () {
                              outScreenController.pickedFile.value = File('');
                              outScreenController.chalanPicPath.value = "";
                              showAlertDialog(
                                context,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  out,
                                  style:
                                      changeTextColor(rubikBlack, whiteColor),
                                ),
                              ),
                            ),
                          ),
                        if (widget.from != "security")
                          Column(
                            children: [
                              CustomTextField(
                                controller: rejectRemarkTextEditingController,
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
                                              .isStatusUpdating.value ==
                                          false) {
                                        outScreenController.updateStatus(
                                          outScreenController
                                              .outScreenChalanDetailsModel
                                              .value
                                              ?.data
                                              ?.id,
                                          1,
                                          rejectRemarkTextEditingController
                                              .text,
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 100.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
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
                                              .isStatusUpdating.value ==
                                          false) {
                                        outScreenController.updateStatus(
                                          outScreenController
                                              .outScreenChalanDetailsModel
                                              .value
                                              ?.data
                                              ?.id,
                                          2,
                                          rejectRemarkTextEditingController
                                              .text,
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 100.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
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

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
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

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext builderContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.sp),
            child: Container(
              width: double.infinity,
              height: 220.h,
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
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Image",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            takePhoto(ImageSource.camera);
                          },
                          child: Obx(
                            () => outScreenController
                                    .chalanPicPath.value.isEmpty
                                ? Container(
                                    height: 90.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Center(
                                      child: Text('Upload Image'),
                                    ),
                                  )
                                : Container(
                                    height: 90.h,
                                    width: 90.w,
                                    child: Image.file(
                                      File(
                                        outScreenController.chalanPicPath.value,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (outScreenController.isStatusUpdating.value ==
                                false) {
                              outScreenController.updateStatus(
                                outScreenController.outScreenChalanDetailsModel
                                    .value?.data?.id,
                                3,
                                rejectRemarkTextEditingController.text,
                              );
                              Get.back();
                            }
                          },
                          child: Container(
                            width: 200.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                submit,
                                style: changeTextColor(rubikBlack, whiteColor),
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
          );
        });
  }
}
