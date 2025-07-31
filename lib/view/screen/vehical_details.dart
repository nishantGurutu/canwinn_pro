import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/vehicles_controller.dart';

class VehicalDetails extends StatefulWidget {
  final int? vehicleId;
  const VehicalDetails({super.key, this.vehicleId});

  @override
  State<VehicalDetails> createState() => _VehicalDetailsState();
}

class _VehicalDetailsState extends State<VehicalDetails> {
  final VehiclesController vehiclesController = Get.put(VehiclesController());
  @override
  void initState() {
    super.initState();
    print('873y98f4 398f4984 ${widget.vehicleId}');
    vehiclesController.vehicleDetailsApi(widget.vehicleId);
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
              details,
              style: TextStyle(
                  color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Obx(
        () => vehiclesController.isVehicleDetailsLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 174.w,
                        child: Image.network(
                          '${vehiclesController.vehicleDetails['vehicle_image']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/png/shopping 1.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 220.w,
                        child: RichText(
                          text: TextSpan(
                            text:
                                'BRAND - ${vehiclesController.vehicleDetails['brand'] ?? ""} ',
                            style: changeTextColor(heading7, tabTextColor),
                            children: [
                              TextSpan(
                                text:
                                    '| ${vehiclesController.vehicleDetails['model_no'] ?? ""}',
                                style:
                                    changeTextColor(heading7, secondTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'NUMBER - ',
                          style: changeTextColor(heading7, tabTextColor),
                          children: [
                            TextSpan(
                              text:
                                  '${vehiclesController.vehicleDetails['vehicle_no'] ?? ""}',
                              style: changeTextColor(heading7, secondTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'NAME - ',
                          style: changeTextColor(heading7, tabTextColor),
                          children: [
                            TextSpan(
                              text:
                                  '${vehiclesController.vehicleDetails['vehicle_name'] ?? ""}',
                              style: changeTextColor(heading7, secondTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              child: Image.network(
                                '${vehiclesController.vehicleDetails['registration_certificate'] ?? ""}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/image/png/shopping 1.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              child: Image.network(
                                '${vehiclesController.vehicleDetails['insurance_certificate'] ?? ""}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/image/png/shopping 1.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              child: Image.network(
                                '${vehiclesController.vehicleDetails['permit_certificate'] ?? ""}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/image/png/shopping 1.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              child: Image.network(
                                '${vehiclesController.vehicleDetails['pollution_certificate'] ?? ""}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/image/png/shopping 1.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              child: Hero(
                                tag: "fitness_certificate",
                                child: Image.network(
                                  '${vehiclesController.vehicleDetails['fitness_certificate'] ?? ""}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/image/png/shopping 1.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(11.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Assigned to",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['driver_name'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Assigned Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['allocation_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Phone no.",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['driver_phone'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "License no.",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['driving_license_no'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Pollution End Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['pollution_end_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "EMI Tenure",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['emi_tenure_months'] ?? ""} Months",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "EMI Start Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['emi_start_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "EMI Due Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['emi_due_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Polution Start Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['pollution_start_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Polution End Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['pollution_end_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Fitness Start Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['fitness_start_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Fitness End Date",
                                      style: changeTextColor(
                                          heading7, tabTextColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${vehiclesController.vehicleDetails['fitness_due_date'] ?? ""}",
                                      style: changeTextColor(
                                          heading7, secondTextColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "expiring Types",
                                    style:
                                        changeTextColor(heading7, tabTextColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              SizedBox(
                                height: 22.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vehiclesController
                                          .vehicleDetails['expiring_types']
                                          .length ??
                                      0,
                                  itemBuilder: (context, typeIndex) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 5.w),
                                      decoration: BoxDecoration(
                                        color: softredColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w),
                                          child: Text(
                                            '${vehiclesController.vehicleDetails['expiring_types'][typeIndex] ?? ""}',
                                            style: changeTextColor(
                                                heading7, redColor),
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
