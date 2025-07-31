import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/view/widgets/humangatepass/human_gatepass_details.dart';

class HumanDenied extends StatelessWidget {
  HumanDenied({super.key});
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
      () => employeeFormController.humanGatePassListRejectData.isEmpty
          ? Center(
              child: Text(
                "No pending data",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount:
                  employeeFormController.humanGatePassListRejectData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(
                      () => HumanGatepassDetails(
                        employeeFormController
                            .humanGatePassListRejectData[index]['id']
                            .toString(),
                        from: "denied",
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Card(
                            color: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${employeeFormController.humanGatePassListRejectData[index]['gatepass_id'] ?? ""}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '${employeeFormController.humanGatePassListRejectData[index]['name'] ?? ""}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${employeeFormController.humanGatePassListRejectData[index]['creator_department_name'] ?? ""}',
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
                                                  '${employeeFormController.humanGatePassListRejectData[index]['purpose_of_visit'] ?? ''}',
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
                                                  '${employeeFormController.humanGatePassListRejectData[index]['out_time'] ?? ''}',
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
                                                  '${employeeFormController.humanGatePassListRejectData[index]['return_time'] ?? ""}',
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
                                    color: Color(0xffFFE2E2),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.r),
                                      bottomRight: Radius.circular(12.r),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              'Denied By : ',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Human Resource Manager ',
                                                  style: TextStyle(
                                                      color: Color(0xff1B2A64),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  'Team Leader',
                                                  style: TextStyle(
                                                      color: Color(0xff1B2A64),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${employeeFormController.humanGatePassListRejectData[index]['hr_head_name'] ?? ''}',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '${employeeFormController.humanGatePassListRejectData[index]['dept_head_name'] ?? ''}',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Color(0xffFFC3C3),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w),
                                        child: Column(
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
                                                        '${employeeFormController.humanGatePassListRejectData[index]['hr_remarks'] ?? ''}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff676767),
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
                                                    text:
                                                        'Department Remark : ',
                                                    style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 12.sp),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${employeeFormController.humanGatePassListRejectData[index]['dept_remarks'] ?? ''}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff676767),
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
