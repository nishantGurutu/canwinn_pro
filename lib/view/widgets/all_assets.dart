import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';

class AllAssetsList extends StatefulWidget {
  const AllAssetsList({super.key});

  @override
  State<AllAssetsList> createState() => _AllAssetsListState();
}

class _AllAssetsListState extends State<AllAssetsList> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.assignAssetsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
          userAssetsList,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => profileController.isAssestAssigningList.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100.w,
                          child: Center(
                            child: Text(
                              'Sr no.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            'Name',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 90.w,
                          child: Center(
                            child: Text(
                              'User Name',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                          child: Center(
                            child: Text(
                              '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    profileController.allocatedAssignList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "No assets assign",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  profileController.allocatedAssignList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: assetsDetails(
                                                context,
                                                profileController
                                                        .allocatedAssignList[
                                                    index]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.r),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: lightGreyColor
                                                  .withOpacity(0.2),
                                              blurRadius: 13.0,
                                              spreadRadius: 2,
                                              blurStyle: BlurStyle.normal,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 30.w,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      child: Text(
                                                        '${index + 1}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120.w,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      child: Text(
                                                        '${profileController.allocatedAssignList[index]['asset_name'] ?? ""}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120.w,
                                                    child: Text(
                                                      '${profileController.allocatedAssignList[index]['assigned_user'] ?? ""}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 20.w,
                                                    child: Center(
                                                      child: PopupMenuButton(
                                                        itemBuilder: (context) {
                                                          return [
                                                            // PopupMenuItem(
                                                            //   onTap: () {
                                                            //     // showModalBottomSheet(
                                                            //     //   isDismissible:
                                                            //     //       true,
                                                            //     //   context:
                                                            //     //       context,
                                                            //     //   isScrollControlled:
                                                            //     //       true,
                                                            //     //   builder:
                                                            //     //       (context) =>
                                                            //     //           editBottomSheet(

                                                            //     //   ),
                                                            //     // );
                                                            //   },
                                                            //   child: Text(edit),
                                                            // ),
                                                            PopupMenuItem(
                                                              onTap: () async {
                                                                if (profileController
                                                                        .isAllocatedAssestAssignDeleting
                                                                        .value ==
                                                                    false) {
                                                                  await profileController
                                                                      .deleteAllocatedAssignAssets(
                                                                    profileController
                                                                            .allocatedAssignList[
                                                                        index]['id'],
                                                                    profileController
                                                                            .allocatedAssignList[index]
                                                                        [
                                                                        'allocation_date'],
                                                                    profileController
                                                                            .allocatedAssignList[index]
                                                                        [
                                                                        'release_date'],
                                                                  );
                                                                }
                                                              },
                                                              child:
                                                                  Text(delete),
                                                            ),
                                                          ];
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
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

  Widget assetsDetails(BuildContext context, allocatedAssignList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 400.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Assign user ',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['assigned_user']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Assets ',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['asset_name']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Assets Model',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['asset_model_name']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Assets Serial no',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['asset_serial_no']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Allocation Date',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['allocation_date']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Release Date',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    ':  ${allocatedAssignList['release_date']}',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
