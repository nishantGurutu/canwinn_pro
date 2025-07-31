import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';

class DocumentListBotomsheet extends StatelessWidget {
  DocumentListBotomsheet({super.key});
  List<String> documentnameList = [
    'Pan Card',
    "Aadhar Card",
  ];
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
          child: Column(
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
                      child: SvgPicture.asset('assets/images/svg/cancel.svg'),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: documentnameList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${index + 1}. ${documentnameList[index]}",
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Container(
                                width: 30.w,
                                height: 30.h,
                                child: Icon(Icons.upload)),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 30.w,
                                height: 30.h,
                                child: Icon(Icons.preview),
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
              CustomButton(
                onPressed: () {},
                text: Text(
                  'Submit',
                  style: changeTextColor(rubikBlack, whiteColor),
                ),
                color: primaryColor,
                height: 45.h,
                width: double.infinity,
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
