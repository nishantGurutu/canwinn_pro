import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/view/screen/vehical_details.dart';

class WheelerList extends StatelessWidget {
  final RxList vehicleList;
  const WheelerList(this.vehicleList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: vehicleList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => VehicalDetails(vehicleId: vehicleList[index]['id']));
            },
            child: Card(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(11.r),
                ),
              ),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 85.w,
                        child: Image.network(
                          '${vehicleList[index]['vehicle_image']}',
                          fit: BoxFit.cover,
                          width: 85.w,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/png/shopping 1.png',
                              fit: BoxFit.cover,
                              width: 85.w,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: RichText(
                              text: TextSpan(
                                text: 'BRAND - ${vehicleList[index]['brand']} ',
                                style: changeTextColor(heading7, tabTextColor),
                                children: [
                                  TextSpan(
                                    text: '| ${vehicleList[index]['model_no']}',
                                    style: changeTextColor(
                                        heading7, secondTextColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'NUMBER - ',
                              style: changeTextColor(heading7, tabTextColor),
                              children: [
                                TextSpan(
                                  text: '${vehicleList[index]['vehicle_no']}',
                                  style: changeTextColor(
                                      heading7, secondTextColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'NAME - ',
                              style: changeTextColor(heading7, tabTextColor),
                              children: [
                                TextSpan(
                                  text: '${vehicleList[index]['vehicle_name']}',
                                  style: changeTextColor(
                                      heading7, secondTextColor),
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
            ),
          );
        },
      ),
    );
  }
}
