import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/vehicles_controller.dart';
import 'package:task_management/view/widgets/list_box_design.dart';
import 'package:task_management/view/widgets/loan_due_dateExpiry.dart';
import 'package:task_management/view/widgets/puc_expire_list.dart';
import 'package:task_management/view/widgets/wheeler_list.dart';

class Vehiclemanagement extends StatefulWidget {
  const Vehiclemanagement({super.key});

  @override
  State<Vehiclemanagement> createState() => _VehiclemanagementState();
}

class _VehiclemanagementState extends State<Vehiclemanagement> {
  final VehiclesController vehiclesController = Get.put(VehiclesController());
  @override
  void initState() {
    vehiclesController.apiCall();
    super.initState();
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
      body: Obx(
        () => vehiclesController.isApiCalling.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => PUCExpireList());
                            },
                            child: ListBoxDesign(
                                image: insuranceIcon,
                                title: "Document\nExpiry",
                                value: "20 vehicles"),
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => LoanDueDateexpiry(
                                  vehiclesController.loanDueDateList));
                            },
                            child: ListBoxDesign(
                                image: hygieneIcon,
                                title: "Loan\nExpiry",
                                value: "20 vehicles"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 34.h,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(22.r),
                        ),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vehiclesController.vehiclesTypeList.length,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () async {
                                vehiclesController
                                    .allVehiclesTypeSelected.value = index;
                                await vehiclesController.listVehicleApi(index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 9.w),
                                decoration: BoxDecoration(
                                  color: vehiclesController
                                              .allVehiclesTypeSelected.value ==
                                          index
                                      ? selectedTabBarColor
                                      : whiteColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22.r),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${vehiclesController.vehiclesTypeList[index]['name']}",
                                  style:
                                      changeTextColor(heading8, tabTextColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(() =>
                        vehiclesController.isVehicleListLoading.value == true
                            ? Center(child: CircularProgressIndicator())
                            : WheelerList(vehiclesController.vehicleList)),
                  ],
                ),
              ),
      ),
    );
  }
}
