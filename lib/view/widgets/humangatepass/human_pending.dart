import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/widgets/humangatepass/human_gatepass_details.dart';

class HumanPending extends StatelessWidget {
  HumanPending({super.key});
  String formatOutTime(String inputDateTime) {
    try {
      final DateTime parsedDate =
          DateFormat("yyyy-MM-dd HH:mm").parse(inputDateTime);
      return DateFormat("yyyy-MM-dd hh:mm a").format(parsedDate);
    } catch (e) {
      return inputDateTime;
    }
  }

  final EmployeeFormController employeeFormController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => employeeFormController.humanGatePassListPendingData.isEmpty
          ? Center(
              child: Text(
                "No pending data",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount:
                  employeeFormController.humanGatePassListPendingData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => HumanGatepassDetails(
                        employeeFormController
                            .humanGatePassListPendingData[index]['id']
                            .toString(),
                        from: "pending"));
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
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
                                    Text(
                                      '${employeeFormController.humanGatePassListPendingData[index]['gatepass_id'] ?? ""}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      '${employeeFormController.humanGatePassListPendingData[index]['name'] ?? ""}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${employeeFormController.humanGatePassListPendingData[index]['creator_department_name'] ?? ''}',
                                      style: TextStyle(
                                          color: textColor, fontSize: 12.sp),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Purpose of visit : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${employeeFormController.humanGatePassListPendingData[index]['purpose_of_visit'] ?? ""}',
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
                                            text: 'Expected Out Time : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${formatOutTime(employeeFormController.humanGatePassListPendingData[index]['out_time'] ?? '')}',
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
                                            text: 'Expected Return Time : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${employeeFormController.humanGatePassListPendingData[index]['return_time'] ?? ""}',
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
                              if ((StorageHelper.getDepartmentId() == 11 &&
                                      employeeFormController
                                                  .humanGatePassListPendingData[
                                              index]['hr_head_status'] ==
                                          0) ||
                                  (StorageHelper.getDepartmentId() == 7 &&
                                      employeeFormController
                                                  .humanGatePassListPendingData[
                                              index]['dept_head_status'] ==
                                          0 &&
                                      StorageHelper.getIsHead() == 1))
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                remarkControlelr.clear();
                                                showAlertDialog(
                                                  context,
                                                  id: employeeFormController
                                                              .humanGatePassListPendingData[
                                                          index]['id'] ??
                                                      "",
                                                  status: 1,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xff00AD03),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8.r),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.h),
                                                  child: Center(
                                                    child: Text(
                                                      "Approve",
                                                      style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                remarkControlelr.clear();
                                                showAlertDialog(context,
                                                    id: employeeFormController
                                                                .humanGatePassListPendingData[
                                                            index]['id'] ??
                                                        "",
                                                    status: 2);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xffFF0005),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8.r),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.h),
                                                  child: Center(
                                                    child: Text(
                                                      "Deny",
                                                      style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                    ],
                                  ),
                                ),
                              if (StorageHelper.getDepartmentId() == 12)
                                InkWell(
                                  onTap: () async {
                                    if (employeeFormController
                                            .isStatusUpdating.value ==
                                        false) {
                                      await employeeFormController
                                          .updateHumanGatePassStatus(
                                        id: employeeFormController
                                                    .humanGatePassListPendingData[
                                                index]['id'] ??
                                            "",
                                        remark: remarkControlelr.text,
                                        status: 3,
                                        from: '',
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff00AD03),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      child: Center(
                                        child: Text(
                                          'In By Security',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (StorageHelper.getDepartmentId() == 11)
                        Positioned(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.h, right: 8.w),
                              child: Container(
                                child: Icon(
                                  Icons.more_vert,
                                  color: Color(0xff1B2A64),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController remarkControlelr = TextEditingController();
  Future<void> showAlertDialog(BuildContext context,
      {required id, required int status}) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 230.h,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskCustomTextField(
                          controller: remarkControlelr,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'remark',
                          hintText: 'Enter Remark',
                          labelText: 'Enter Remark',
                          maxLine: 5,
                          index: 1,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (employeeFormController
                                        .isStatusUpdating.value ==
                                    false) {
                                  employeeFormController
                                      .updateHumanGatePassStatus(
                                    id: id,
                                    remark: remarkControlelr.text,
                                    status: status,
                                    from: '',
                                  );
                                }
                              },
                              child: Container(
                                height: 35.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff1E94FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    submit,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 35.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF0004),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    cancel,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
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
              Positioned(
                top: 2.h,
                right: 2.w,
                child: SizedBox(
                  height: 20.h,
                  width: 35.w,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
