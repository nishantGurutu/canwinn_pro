import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/view/screen/inscreen/inChalanDetails.dart';

class InHrScreen extends StatefulWidget {
  const InHrScreen({super.key});

  @override
  State<InHrScreen> createState() => _InHrScreenState();
}

class _InHrScreenState extends State<InHrScreen> {
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  final OutScreenController outScreenController =
      Get.put(OutScreenController());

  @override
  void initState() {
    outScreenController.inScreenChalanApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          hrScreen,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Obx(
          () => outScreenController.isInChalanLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : ListView.separated(
                  itemCount: outScreenController.inScreenChalanList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Get.to(InChalanDetails(
                            outScreenController.inScreenChalanList[index].id
                                .toString(),
                          ));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            child: Column(
                              spacing: 8.h,
                              children: [
                                InkWell(
                                  onTap: () {
                                    outScreenController.openFile(
                                        outScreenController
                                                .inScreenChalanList[index]
                                                .uploadImage ??
                                            "");
                                  },
                                  child: SizedBox(
                                    height: 60.h,
                                    width: 100.w,
                                    child: Image.network(
                                      outScreenController
                                              .inScreenChalanList[index]
                                              .uploadImage ??
                                          "",
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                          ),
                                          child: Image.asset(backgroundLogo),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  'Chalan Number :- ${outScreenController.inScreenChalanList[index].challanNumber ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date :- ${outScreenController.inScreenChalanList[index].date ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Department Name :- ${outScreenController.inScreenChalanList[index].name ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Address :- ${outScreenController.inScreenChalanList[index].address ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Contact :- ${outScreenController.inScreenChalanList[index].contact ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0.h,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
