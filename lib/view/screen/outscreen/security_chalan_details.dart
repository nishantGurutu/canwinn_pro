import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/in_screen_chalan_list.dart';

class SecurityChalanDetails extends StatefulWidget {
  final InScreenData chalanList;
  const SecurityChalanDetails(this.chalanList, {super.key});

  @override
  State<SecurityChalanDetails> createState() => _SecurityChalanDetailsState();
}

class _SecurityChalanDetailsState extends State<SecurityChalanDetails> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    outScreenController.chalanId = widget.chalanList.id ?? 0;
    outScreenController.inChalanDetails();
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
                                  'Chalan Number :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.date ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Address :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.address ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Purpose :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.purpose ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Contact :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Status :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: rejectRemarkTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                          hintText: rejectRemark,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (outScreenController
                                        .isStatusUpdating.value ==
                                    false) {
                                  outScreenController.updateStatus(
                                    outScreenController
                                        .inScreenChalanDetailsModel
                                        .value
                                        ?.data
                                        ?.id,
                                    1,
                                    rejectRemarkTextEditingController.text,
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
                                    style:
                                        changeTextColor(rubikBlack, whiteColor),
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
                                        .inScreenChalanDetailsModel
                                        .value
                                        ?.data
                                        ?.id,
                                    2,
                                    rejectRemarkTextEditingController.text,
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
                                    style:
                                        changeTextColor(rubikBlack, whiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
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
                                style: changeTextColor(rubikBlack, whiteColor),
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
}
