import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/vehicles_controller.dart';
import 'package:task_management/view/screen/vehical_details.dart';

class PUCExpireList extends StatefulWidget {
  const PUCExpireList({super.key});

  @override
  State<PUCExpireList> createState() => _PUCExpireListState();
}

class _PUCExpireListState extends State<PUCExpireList> {
  final VehiclesController vehiclesController = Get.put(VehiclesController());
  @override
  void initState() {
    super.initState();
    vehiclesController.expiringDocumentsApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Row(
          children: [
            Text(
              vehicleManagement,
              style: TextStyle(
                  color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Obx(
          () => vehiclesController.isexpiringDocumentsLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            vehiclesController.expiringDocumentsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => VehicalDetails(
                                  vehicleId: vehiclesController
                                          .expiringDocumentsList[index]
                                      ['vehicle_id']));
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 5.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 85.w,
                                        child: Image.network(
                                          '${vehiclesController.expiringDocumentsList[index]['vehicle_image']}',
                                          fit: BoxFit.cover,
                                          width: 85.w,
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 220.w,
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    'BRAND - ${vehiclesController.expiringDocumentsList[index]['brand'] ?? ""} ',
                                                style: changeTextColor(
                                                    heading7, tabTextColor),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '| ${vehiclesController.expiringDocumentsList[index]['model_no'] ?? ""}',
                                                    style: changeTextColor(
                                                        heading7,
                                                        secondTextColor),
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
                                              style: changeTextColor(
                                                  heading7, tabTextColor),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${vehiclesController.expiringDocumentsList[index]['vehicle_no'] ?? ""}',
                                                  style: changeTextColor(
                                                      heading7,
                                                      secondTextColor),
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
                                              style: changeTextColor(
                                                  heading7, tabTextColor),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${vehiclesController.expiringDocumentsList[index]['vehicle_name'] ?? ""}',
                                                  style: changeTextColor(
                                                      heading7,
                                                      secondTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          SizedBox(
                                            height: 22.h,
                                            width: 220.w,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: vehiclesController
                                                      .expiringDocumentsList[
                                                          index]
                                                          ['expiring_types']
                                                      .length ??
                                                  0,
                                              itemBuilder:
                                                  (context, typeIndex) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      right: 5.w),
                                                  decoration: BoxDecoration(
                                                    color: softredColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8.r),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w),
                                                      child: Text(
                                                        '${vehiclesController.expiringDocumentsList[index]['expiring_types'][typeIndex] ?? ""}',
                                                        style: changeTextColor(
                                                            heading7, redColor),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
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
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
