import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/view/screen/add_company.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
          company,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            createdByMe(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddCompany());
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
          size: 30.h,
        ),
      ),
    );
  }

  Widget createdByMe() {
    return Expanded(
      child: ListView.separated(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          String itemString = index.toString();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
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
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Center(
                        child: Text('$itemString', style: rubikBlack),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 270.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Clampett Oil and Gas Corp.',
                              style: changeTextColor(rubikBold, darkGreyColor)),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '9999999999',
                                style: rubikMedium,
                              ),
                              Spacer(),
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  'Andover Court',
                                  style: rubikMedium,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Soylent Corp, India',
                            style: changeTextColor(rubikMedium, darkGreyColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 15.h);
        },
      ),
    );
  }
}
