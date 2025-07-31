import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class ChalanListBox extends StatelessWidget {
  final String image;
  final String chalanNumber;
  final String deptName;
  final String dispatchTo;
  final String from;
  final String date;
  final String contact;
  final dynamic status;
  const ChalanListBox(
      {super.key,
      required this.image,
      required this.chalanNumber,
      required this.deptName,
      required this.dispatchTo,
      required this.from,
      required this.date,
      required this.contact,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Card(
        color: whiteColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(11.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 66.h,
                    width: 66.w,
                    decoration: BoxDecoration(
                      color: Color(0xffF4F4F4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        openFile(image);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: SvgPicture.asset(
                                brokenIcon,
                                fit: BoxFit.cover,
                                height: 37.h,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Container(
                    width: 240.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Chalan Number : $chalanNumber",
                                style: heading9,
                              ),
                            ),
                            SvgPicture.asset(
                                'assets/image/svg/chevron_right.svg'),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "Department Name : $deptName",
                          style: heading9,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        from == "inchalan"
                            ? Text(
                                "Address : $dispatchTo",
                                style: heading9,
                              )
                            : Text(
                                "Dispatch To : $dispatchTo",
                                style: heading9,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90.w,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            'assets/image/svg/calendar_today (1).svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "$date",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: status.toString() == "0"
                          ? Color(0xffDFAF00)
                          : status.toString() == "2"
                              ? Color(0xffFF5959)
                              : Color(0xff1E94FF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${status.toString() == "0" ? "Pending" : status.toString() == "2" ? "Rejected" : "Approved"}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: whiteColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                            'assets/image/svg/contact_phone (1).svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "$contact",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Unsupported file type.')),
      // );
    }
  }
}
