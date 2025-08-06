import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/download.dart' show DownloadFile;
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/network_image_class.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';

class LeadOverviewDocumentListBotomsheet extends StatefulWidget {
  final dynamic leadId;
  final dynamic quotationId;
  const LeadOverviewDocumentListBotomsheet(
      {super.key, required this.leadId, this.quotationId});

  @override
  State<LeadOverviewDocumentListBotomsheet> createState() =>
      _LeadOverviewDocumentListBotomsheet();
}

class _LeadOverviewDocumentListBotomsheet
    extends State<LeadOverviewDocumentListBotomsheet> {
  final LeadController leadController = Get.find();

  @override
  void initState() {
    print('wjh838e3 e3uey38 4ue48 ${widget.leadId}');
    leadController.leadDocumentList(leadId: widget.leadId, from: 'initstate');
    leadController.leadpickedFile.value = File("");
    leadController.profilePicPath.value = "";
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    leadController.isDocumentCheckBoxSelected.clear();
    leadController.leadpickedFile.value = File("");
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
            () => leadController.isDocumentListLoading.value == true
                ? Center(child: CircularProgressIndicator())
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
                      leadController.leadDocumentListData.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'No uploaded document found',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount:
                                    leadController.leadDocumentListData.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${index + 1}. ${leadController.leadDocumentListData[index].fileName ?? ''}",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              DownloadFile().saveToDownloads(
                                                  leadController
                                                          .leadDocumentListData[
                                                              index]
                                                          .fileUrl ??
                                                      "",
                                                  isNetwork: true);
                                            },
                                            child: Container(
                                                width: 40.w,
                                                height: 30.h,
                                                child: Icon(
                                                  Icons.download,
                                                  size: 30.sp,
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              width: 40.w,
                                              height: 40.h,
                                              child: NetworkImageWidget(
                                                imageurl: leadController
                                                    .leadDocumentListData[index]
                                                    .fileUrl,
                                                height: 40.h,
                                                width: 40.w,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Checkbox(
                                              value: leadController
                                                      .isDocumentCheckBoxSelected[
                                                  index],
                                              onChanged: (value) async {
                                                await leadController
                                                    .approveDocument(
                                                  documentId: leadController
                                                      .leadDocumentListData[
                                                          index]
                                                      .id,
                                                  leadId: widget.leadId,
                                                );
                                                leadController
                                                        .isDocumentCheckBoxSelected[
                                                    index] = value!;
                                              },
                                            ),
                                          )
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!leadController
                                        .isDocumentCheckBoxSelected
                                        .contains(false)) {
                                      documentApprovedDialog(
                                          context, "approve");
                                    } else {
                                      CustomToast().showCustomToast(
                                          "All document not approved.");
                                    }
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      color: primaryButtonColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    documentApprovedDialog(context, "concern");
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      color: redColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Raise Concern',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController remarkControlelr = TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> documentApprovedDialog(BuildContext context, String type) async {
    leadController.leadpickedFile.value = File('');
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type == "approve"
                              ? "Approve Document"
                              : "Raise Concern",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () async {
                            Get.back();
                          },
                          child: Icon(Icons.close, size: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Remarks",
                            style: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          width: 100.w,
                          child: Text(
                            'Upload Document',
                            style: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    if (type == "approve")
                      Row(
                        children: [
                          Expanded(
                            child: TaskCustomTextField(
                              controller: remarkControlelr,
                              focusedIndexNotifier: focusedIndexNotifier,
                              index: 1,
                              textCapitalization: TextCapitalization.sentences,
                              hintText: "Enter remarks",
                              data: "",
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          InkWell(
                            onTap: () {
                              takeDocument();
                            },
                            child: Container(
                              height: 40.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Obx(
                                () {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.file(
                                      leadController.leadpickedFile.value!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              border: Border.all(
                                                  color: lightBorderColor)),
                                          height: 40.h,
                                          width: 100.w,
                                          child: Image.asset(
                                            'assets/image/png/Upload-Icon-Image-Background-PNG-Image.png',
                                            height: 15.h,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (type == "concern")
                      SizedBox(
                        height: 5.h,
                      ),
                    if (type == "concern")
                      TaskCustomTextField(
                        controller: remarkControlelr,
                        focusedIndexNotifier: focusedIndexNotifier,
                        index: 1,
                        textCapitalization: TextCapitalization.sentences,
                        hintText: "Enter remarks",
                        data: "",
                      ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () async {
                        debugPrint("Approve Button Clicked");
                        if (StorageHelper.getRoleName()
                                .toString()
                                .toLowerCase() ==
                            "branch head") {
                          if (type == "approve" &&
                              leadController
                                      .isBranchHeadManagerApproving.value ==
                                  false) {
                            if (leadController
                                .leadpickedFile.value.path.isNotEmpty) {
                              await leadController.branchheadManagerApproving(
                                leadId: widget.leadId,
                                remark: remarkControlelr.text,
                                status: type == "approve" ? 1 : 2,
                                attachment: leadController.leadpickedFile.value,
                              );
                            } else {
                              CustomToast()
                                  .showCustomToast('Please select attachment');
                            }
                          } else if (type != "approve") {
                            await leadController.branchheadManagerApproving(
                              leadId: widget.leadId,
                              remark: remarkControlelr.text,
                              status: type == "approve" ? 1 : 2,
                              attachment: leadController.leadpickedFile.value,
                            );
                          }
                        } else {
                          if (leadController
                                  .isMarketingManagerApproving.value ==
                              false) {
                            await leadController.approveMarketingManager(
                                leadId: widget.leadId,
                                remark: remarkControlelr.text,
                                status: type == "approve" ? 1 : 2);
                          }
                        }
                      },
                      child: Container(
                        width: 130.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: primaryButtonColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type == 'approve' ? 'Approve' : "Concern",
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
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> takeDocument() async {
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
        leadController.leadpickedFile.value = File(file.path);
        leadController.profilePicPath.value = file.path.toString();
        // leadController.documentIdList.add();
        // leadController.documentUplodedList
        //     .add(leadController.leadpickedFile.value);
        print(
            'selected file path from device is ${leadController.leadpickedFile.value}');
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
