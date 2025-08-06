import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/custom_widget/task_text_field.dart';

class ShowDialogClass {
  final TextEditingController remarkControlelr = TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Future<void> documentApprovedDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TaskCustomTextField(
                        controller: remarkControlelr,
                        focusedIndexNotifier: focusedIndexNotifier,
                        index: 1,
                        textCapitalization: TextCapitalization.sentences,
                        data: "",
                      ),
                      SizedBox(height: 8.h),
                      InkWell(
                        onTap: () {
                          // Get.to(() => TestResultScreen(testNumber));
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
                              'Approve',
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
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
