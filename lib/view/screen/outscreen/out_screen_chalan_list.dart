import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/view/screen/outscreen/widget/in_chalan_list.dart';
import 'package:task_management/view/screen/outscreen/widget/out_chalan_list.dart';

class OutScreenChalanList extends StatefulWidget {
  const OutScreenChalanList({super.key});

  @override
  State<OutScreenChalanList> createState() => _OutScreenChalanListState();
}

class _OutScreenChalanListState extends State<OutScreenChalanList> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  @override
  void initState() {
    outScreenController.outScreenChalanApi();
    outScreenController.inScreenChalanApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
        title: Text(
          gatePasList,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: Obx(
          () => outScreenController.isChalanLoading.value == true &&
                  outScreenController.isInChalanLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : outScreenController.chalanList.isEmpty
                  ? Center(
                      child: Text(
                        'No chalan created',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Container(
                            height: 35.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.r),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (outScreenController
                                              .isOutSelected.value ==
                                          false) {
                                        outScreenController
                                            .isOutSelected.value = true;
                                        outScreenController.isInSelected.value =
                                            false;
                                      }
                                    },
                                    child: Container(
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        color: outScreenController
                                                    .isOutSelected.value ==
                                                true
                                            ? Color(0xffDDE4FF)
                                            : whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(replyAllIcon),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "Out Chalan List",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff263B8D)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (outScreenController
                                              .isInSelected.value ==
                                          false) {
                                        outScreenController.isInSelected.value =
                                            true;
                                        outScreenController
                                            .isOutSelected.value = false;
                                      }
                                    },
                                    child: Container(
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        color: outScreenController
                                                    .isInSelected.value ==
                                                true
                                            ? Color(0xffDDE4FF)
                                            : whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(forwardIcon),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "In Chalan List",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff263B8D)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: outScreenController.isOutSelected.value == true
                              ? OutChalanlist(outScreenController.chalanList)
                              : InChalanlist(
                                  outScreenController.inScreenChalanList,
                                  outScreenController),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
