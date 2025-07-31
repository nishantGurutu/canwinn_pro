import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
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
          email,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inbox,
                    style: robotoRegular,
                  ),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(starred, style: robotoRegular),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(draft, style: robotoRegular),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sent, style: robotoRegular),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(trash, style: robotoRegular),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(work, style: robotoRegular),
                  const Spacer(),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(office, style: robotoRegular),
                  const Spacer(),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(personal, style: robotoRegular),
                  const Spacer(),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(company, style: robotoRegular),
                  const Spacer(),
                  Image.asset(
                    rightArrowIcon,
                    height: 25.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: primaryColor,
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.add,
      //     color: whiteColor,
      //     size: 30.h,
      //   ),
      // ),
    );
  }
}
