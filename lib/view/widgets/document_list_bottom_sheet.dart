import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class DocumentListBotomsheet extends StatefulWidget {
  final String? from;
  final dynamic leadId;
  final dynamic quotationId;
  const DocumentListBotomsheet(
      {super.key, required this.from, required this.leadId, this.quotationId});

  @override
  State<DocumentListBotomsheet> createState() => _DocumentListBotomsheetState();
}

class _DocumentListBotomsheetState extends State<DocumentListBotomsheet> {
  final LeadController leadController = Get.find();

  @override
  void initState() {
    print("eh9849 4u49h94 4f9u4h9 ${widget.quotationId}");
    leadController.documentType();
    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    leadController.leadpickedFile.value = File("");
    leadController.documentUplodedList.clear();
    leadController.documentUplodedList.clear();
    leadController.profilePicPath.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 620.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SafeArea(
          child: Obx(
            () => leadController.isDocumentTypeLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : leadController.documentTypeListData.isEmpty
                    ? Center(
                        child: Text(
                          'No document list',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Document List",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: textColor),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SizedBox(
                                  width: 25.w,
                                  height: 35.h,
                                  child: SvgPicture.asset(
                                      'assets/images/svg/cancel.svg'),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  leadController.documentTypeListData.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${index + 1}. ${leadController.documentTypeListData[index].name ?? ''}",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            leadController.documentIdList[
                                                index] = leadController
                                                    .documentTypeListData[index]
                                                    .id ??
                                                0;
                                            takeDocument(
                                                index: index,
                                                documentId: leadController
                                                        .documentTypeListData[
                                                            index]
                                                        .id ??
                                                    0);
                                          },
                                          child: Container(
                                            width: 40.w,
                                            height: 30.h,
                                            child: Icon(
                                              Icons.upload,
                                              size: 30.sp,
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => leadController
                                                  .documentUplodedList[index]
                                                  .path
                                                  .isEmpty
                                              ? Container(
                                                  width: 40.w,
                                                  height: 30.h,
                                                  child: Icon(
                                                    Icons.preview,
                                                    size: 30.sp,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                      () => ImageScreen(
                                                        file: leadController
                                                                .documentUplodedList[
                                                            index],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 40.w,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              lightBorderColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.r)),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.r)),
                                                      child: Image.file(
                                                        leadController
                                                                .documentUplodedList[
                                                            index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (widget.from == "quotation")
                            CustomButton(
                              onPressed: () async {
                                if (leadController.isDocumentUploading.value ==
                                    false) {
                                  if (leadController
                                      .documentUplodedList.isNotEmpty) {
                                    await leadController.documentUploading(
                                      documentId: leadController.documentIdList,
                                      ducument:
                                          leadController.documentUplodedList,
                                      leadId: widget.leadId,
                                      quotationId: widget.quotationId,
                                    );
                                  } else {
                                    CustomToast()
                                        .showCustomToast('Upload Document.');
                                  }
                                }
                              },
                              text: Text(
                                'Submit',
                                style: changeTextColor(rubikBlack, whiteColor),
                              ),
                              color: primaryColor,
                              height: 45.h,
                              width: double.infinity,
                            ),
                          if (widget.from == "quotation")
                            SizedBox(
                              height: 10.h,
                            ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Future<void> takeDocument({required int index, int? documentId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        leadController.documentUplodedList[index] = file;
        leadController.documentUplodedList.refresh();
        print('File selected for index $index: ${file.path}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }
}
