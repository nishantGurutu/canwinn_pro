import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/vehicles_controller.dart';
import 'package:task_management/view/screen/vehical_details.dart';

class LoanDueDateexpiry extends StatefulWidget {
  final RxList loanDueDateList;
  const LoanDueDateexpiry(this.loanDueDateList, {super.key});

  @override
  State<LoanDueDateexpiry> createState() => _LoanDueDateexpiryState();
}

class _LoanDueDateexpiryState extends State<LoanDueDateexpiry> {
  final VehiclesController vehiclesController = Get.put(VehiclesController());
  @override
  void initState() {
    super.initState();
    vehiclesController.isLoanDueDateLoadingApi();
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Obx(
          () => vehiclesController.isLoanDueDateLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: vehiclesController.loanDueDateList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => VehicalDetails(
                                  vehicleId: vehiclesController
                                      .loanDueDateList[index]['vehicle_id']));
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
                                          '${vehiclesController.loanDueDateList[index]['vehicle_image']}',
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
                                                    'BRAND - ${vehiclesController.loanDueDateList[index]['brand']} ',
                                                style: changeTextColor(
                                                    heading7, tabTextColor),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '| ${vehiclesController.loanDueDateList[index]['model_no']}',
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
                                                      '${vehiclesController.loanDueDateList[index]['vehicle_no']}',
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
                                                      '${vehiclesController.loanDueDateList[index]['vehicle_name']}',
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
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                                '${vehiclesController.loanDueDateList[index]['vehicle_name']}'),
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
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
