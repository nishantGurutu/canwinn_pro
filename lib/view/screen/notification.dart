import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/notification_controller.dart';
import 'package:task_management/view/screen/notes.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/screen/vehical_details.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController notificationController = Get.find();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    notificationController.pageValue.value = 1;
    _scrollController.addListener(_scrollListener);
    notificationController.notificationListApi('');
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      notificationController.pageValue.value += 1;
      await notificationController.notificationListApi('scrolling');

      notificationController.notificationSelectList.assignAll(
        List<bool>.filled(notificationController.notificationList.length,
            notificationController.isAllSelect.value),
      );
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      notificationController.pageValue.value -= 1;
      await notificationController.notificationListApi('scrolling');
      notificationController.notificationSelectList.assignAll(
        List<bool>.filled(notificationController.notificationList.length,
            notificationController.isAllSelect.value),
      );
    }
  }

  @override
  void dispose() {
    notificationController.isAllSelect.value = false;
    notificationController.isUnreadSelected = true.obs;
    notificationController.isReadSelected = false.obs;
    notificationController.notificationSelectidList.clear();
    notificationController.notificationSelectTypeList.clear();
    super.dispose();
  }

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
          notification,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        // actions: [
        //   Obx(() => notificationController.isAllSelect.value == true ||
        //           notificationController.isUnreadSelected.value == true &&
        //               notificationController.notificationSelectList
        //                   .contains(true) ||
        //           notificationController.isReadSelected.value == true &&
        //               notificationController.readNotificationSelectList
        //                   .contains(true)
        //       ? InkWell(
        //           onTap: () {
        //             if (notificationController.isNotificationDeleting.value ==
        //                 false) {
        //               notificationController.deleteNotificationListApi(
        //                 notificationController.notificationSelectidList,
        //                 notificationController.notificationSelectTypeList,
        //               );
        //             }
        //           },
        //           child: Icon(Icons.delete),
        //         )
        //       : SizedBox()),
        //   SizedBox(
        //     width: 5.w,
        //   ),
        //   Padding(
        //     padding: EdgeInsets.only(right: 12.w),
        //     child: Row(
        //       children: [
        //         Text(
        //           'Select All',
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         Obx(
        //           () => Checkbox(
        //             value: notificationController.isAllSelect.value,
        //             onChanged: (value) {
        //               notificationController.isAllSelect.value = value!;
        //               if (notificationController.isUnreadSelected.value ==
        //                   true) {
        //                 notificationController.notificationSelectList.assignAll(
        //                   List<bool>.filled(
        //                       notificationController.notificationList.length,
        //                       value),
        //                 );
        //               } else {
        //                 notificationController.readNotificationSelectList
        //                     .assignAll(
        //                   List<bool>.filled(
        //                       notificationController
        //                           .readNotificationList.length,
        //                       value),
        //                 );
        //               }
        //               if (value) {
        //                 if (notificationController.isUnreadSelected.value ==
        //                     true) {
        //                   // Unread notification
        //                   notificationController.notificationSelectidList
        //                       .assignAll(
        //                     notificationController.notificationList
        //                         .map((e) => e['id'].toString())
        //                         .toList(),
        //                   );
        //                 } else {
        //                   // Read notification
        //                   notificationController.notificationSelectidList
        //                       .assignAll(
        //                     notificationController.readNotificationList
        //                         .map((e) => e['id'].toString())
        //                         .toList(),
        //                   );
        //                 }
        //                 if (notificationController.isUnreadSelected.value ==
        //                     true) {
        //                   // Unread notification
        //                   notificationController.notificationSelectTypeList
        //                       .assignAll(
        //                     notificationController.readNotificationList
        //                         .map((e) => e['type'].toString())
        //                         .toList(),
        //                   );
        //                 } else {
        //                   // Read notification
        //                   notificationController.notificationSelectTypeList
        //                       .assignAll(
        //                     notificationController.readNotificationList
        //                         .map((e) => e['type'].toString())
        //                         .toList(),
        //                   );
        //                 }
        //               } else {
        //                 notificationController.notificationSelectidList.clear();
        //                 notificationController.notificationSelectTypeList
        //                     .clear();
        //               }
        //             },
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ],
        actions: [
          Obx(() => (notificationController.notificationSelectList
                      .contains(true) ||
                  notificationController.readNotificationSelectList
                      .contains(true))
              ? InkWell(
                  onTap: () {
                    if (!notificationController.isNotificationDeleting.value) {
                      // Combine IDs and types from both lists
                      final selectedIds = <String>[
                        ...notificationController.notificationSelectidList,
                        ...notificationController.readNotificationSelectList
                            .asMap()
                            .entries
                            .where((entry) => entry.value)
                            .map((entry) => notificationController
                                .readNotificationList[entry.key]['id']
                                .toString()),
                      ];
                      final selectedTypes = <String>[
                        ...notificationController.notificationSelectTypeList,
                        ...notificationController.readNotificationSelectList
                            .asMap()
                            .entries
                            .where((entry) => entry.value)
                            .map((entry) => notificationController
                                .readNotificationList[entry.key]['type']
                                .toString()),
                      ];
                      notificationController.deleteNotificationListApi(
                        selectedIds,
                        selectedTypes,
                      );
                    }
                  },
                  child: const Icon(Icons.delete),
                )
              : const SizedBox()),
          SizedBox(width: 5.w),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Row(
              children: [
                const Text(
                  'Select All',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Checkbox(
                    value: notificationController.isAllSelect.value,
                    onChanged: (value) {
                      notificationController.isAllSelect.value = value!;
                      if (notificationController.isUnreadSelected.value) {
                        // Unread notifications
                        notificationController.notificationSelectList.assignAll(
                          List<bool>.filled(
                              notificationController.notificationList.length,
                              value),
                        );
                        if (value) {
                          notificationController.notificationSelectidList
                              .assignAll(
                            notificationController.notificationList
                                .map((e) => e['id'].toString())
                                .toList(),
                          );
                          notificationController.notificationSelectTypeList
                              .assignAll(
                            notificationController.notificationList
                                .map((e) => e['type'].toString())
                                .toList(),
                          );
                        } else {
                          notificationController.notificationSelectidList
                              .clear();
                          notificationController.notificationSelectTypeList
                              .clear();
                        }
                      } else {
                        // Read notifications
                        notificationController.readNotificationSelectList
                            .assignAll(
                          List<bool>.filled(
                              notificationController
                                  .readNotificationList.length,
                              value),
                        );
                        if (value) {
                          notificationController.notificationSelectidList
                              .assignAll(
                            notificationController.readNotificationList
                                .map((e) => e['id'].toString())
                                .toList(),
                          );
                          notificationController.notificationSelectTypeList
                              .assignAll(
                            notificationController.readNotificationList
                                .map((e) => e['type'].toString())
                                .toList(),
                          );
                        } else {
                          notificationController.notificationSelectidList
                              .clear();
                          notificationController.notificationSelectTypeList
                              .clear();
                        }
                      }
                      print(
                          'Selected IDs: ${notificationController.notificationSelectidList}');
                      print(
                          'Selected Types: ${notificationController.notificationSelectTypeList}');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: backgroundColor,
        child: Obx(
          () => notificationController.isNotificationLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: tabBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(22.r)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => InkWell(
                                  onTap: () {
                                    notificationController
                                        .isUnreadSelected.value = true;
                                    notificationController
                                        .isReadSelected.value = false;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: notificationController
                                                  .isUnreadSelected.value ==
                                              true
                                          ? primaryButtonColor
                                          : tabBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/svg/event_upcoming.svg',
                                            height: 20.h,
                                            color: notificationController
                                                        .isUnreadSelected
                                                        .value ==
                                                    true
                                                ? whiteColor
                                                : textColor,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            'Unread Notification',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: notificationController
                                                            .isUnreadSelected
                                                            .value ==
                                                        true
                                                    ? whiteColor
                                                    : textColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => InkWell(
                                  onTap: () {
                                    notificationController
                                        .isUnreadSelected.value = false;
                                    notificationController
                                        .isReadSelected.value = true;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: notificationController
                                                  .isReadSelected.value ==
                                              true
                                          ? primaryButtonColor
                                          : tabBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/png/ongoing.png',
                                            height: 20.h,
                                            color: notificationController
                                                        .isReadSelected.value ==
                                                    true
                                                ? whiteColor
                                                : textColor,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            'Read Notification',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: notificationController
                                                            .isReadSelected
                                                            .value ==
                                                        true
                                                    ? whiteColor
                                                    : textColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () =>
                          notificationController.isUnreadSelected.value == true
                              ? Expanded(
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    itemCount: notificationController
                                            .notificationList.length +
                                        1,
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          notificationController
                                              .notificationList.length) {
                                        return Obx(
                                          () => notificationController
                                                  .isScrolling.value
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth: 2),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        );
                                      }
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 5.h),
                                        child: InkWell(
                                          onTap: () async {
                                            await notificationController
                                                .readNotification(
                                                    notificationController
                                                            .notificationList[
                                                        index]["id"]);
                                            if (notificationController
                                                .notificationList[index]
                                                    ['title']
                                                .toString()
                                                .toLowerCase()
                                                .contains('task')) {
                                              Get.to(() => TaskDetails(
                                                    taskId: notificationController
                                                            .notificationList[
                                                        index]['product_id'],
                                                    assignedStatus: "",
                                                    initialIndex: 0,
                                                  ));
                                            } else if (notificationController
                                                .notificationList[index]
                                                    ['title']
                                                .toString()
                                                .toLowerCase()
                                                .contains('note')) {
                                              Get.to(() => NotesPages(
                                                    folderId: 0,
                                                    fromName: '',
                                                    from: '',
                                                  ));
                                            } else if (notificationController
                                                .notificationList[index]
                                                    ['title']
                                                .toString()
                                                .toLowerCase()
                                                .contains('emi')) {
                                              Get.to(() => VehicalDetails(
                                                    vehicleId:
                                                        notificationController
                                                                .notificationList[
                                                            index]['product_id'],
                                                  ));
                                            }
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
                                                  horizontal: 8.w,
                                                  vertical: 8.h),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45.h,
                                                    width: 45.w,
                                                    decoration: BoxDecoration(
                                                      color: lightGreyColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(25.r),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.notifications,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  Container(
                                                    width: 262.w,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 240.w,
                                                              child: Text(
                                                                "${notificationController.notificationList[index]['title'] ?? ""}",
                                                                style:
                                                                    rubikBold,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            SizedBox(
                                                              height: 20.h,
                                                              width: 20.w,
                                                              child: Obx(
                                                                () => Checkbox(
                                                                  value: notificationController
                                                                          .notificationSelectList[
                                                                      index],
                                                                  onChanged:
                                                                      (value) {
                                                                    notificationController
                                                                            .notificationSelectList[index] =
                                                                        value!;

                                                                    if (value) {
                                                                      notificationController
                                                                          .notificationSelectidList
                                                                          .add(
                                                                        notificationController
                                                                            .notificationList[index]['id']
                                                                            .toString(),
                                                                      );
                                                                      notificationController
                                                                          .notificationSelectTypeList
                                                                          .add(
                                                                        notificationController
                                                                            .notificationList[index]['type']
                                                                            .toString(),
                                                                      );
                                                                    } else {
                                                                      notificationController
                                                                          .notificationSelectidList
                                                                          .remove(
                                                                        notificationController
                                                                            .notificationList[index]['id']
                                                                            .toString(),
                                                                      );
                                                                      notificationController
                                                                          .notificationSelectTypeList
                                                                          .remove(
                                                                        notificationController
                                                                            .notificationList[index]['type']
                                                                            .toString(),
                                                                      );
                                                                    }

                                                                    notificationController
                                                                            .isAllSelect
                                                                            .value =
                                                                        notificationController
                                                                            .notificationSelectList
                                                                            .every((isSelected) =>
                                                                                isSelected);
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 6.h),
                                                        Text(
                                                          "${notificationController.notificationList[index]['description'] ?? ""}",
                                                          style:
                                                              changeTextColor(
                                                                  rubikRegular,
                                                                  subTextColor),
                                                        ),
                                                        SizedBox(height: 6.h),
                                                        Text(
                                                          "${notificationController.notificationList[index]['created_at'] ?? ""}",
                                                          style:
                                                              changeTextColor(
                                                                  rubikMedium,
                                                                  subTextColor),
                                                        )
                                                      ],
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
                                )
                              : Expanded(
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    itemCount: notificationController
                                            .readNotificationList.length +
                                        1,
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          notificationController
                                              .readNotificationList.length) {
                                        return Obx(
                                          () => notificationController
                                                  .isScrolling.value
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth: 2),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        );
                                      }
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 5.h),
                                        child: InkWell(
                                          onTap: () async {},
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.r),
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
                                                  horizontal: 8.w,
                                                  vertical: 8.h),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45.h,
                                                    width: 45.w,
                                                    decoration: BoxDecoration(
                                                      color: lightGreyColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(25.r),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.notifications,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  Container(
                                                    width: 262.w,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 240.w,
                                                              child: Text(
                                                                "${notificationController.readNotificationList[index]['title'] ?? ""}",
                                                                style:
                                                                    rubikBold,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            SizedBox(
                                                              height: 20.h,
                                                              width: 20.w,
                                                              child: Obx(
                                                                () => Checkbox(
                                                                  value: notificationController
                                                                          .readNotificationSelectList[
                                                                      index],
                                                                  onChanged:
                                                                      (value) {
                                                                    notificationController
                                                                            .readNotificationSelectList[index] =
                                                                        value!;

                                                                    if (value) {
                                                                      notificationController
                                                                          .notificationSelectidList
                                                                          .add(
                                                                        notificationController
                                                                            .readNotificationList[index]['id']
                                                                            .toString(),
                                                                      );
                                                                      notificationController
                                                                          .notificationSelectTypeList
                                                                          .add(
                                                                        notificationController
                                                                            .readNotificationList[index]['type']
                                                                            .toString(),
                                                                      );
                                                                    } else {
                                                                      notificationController
                                                                          .notificationSelectidList
                                                                          .remove(
                                                                        notificationController
                                                                            .readNotificationList[index]['id']
                                                                            .toString(),
                                                                      );
                                                                      notificationController
                                                                          .notificationSelectTypeList
                                                                          .remove(
                                                                        notificationController
                                                                            .readNotificationList[index]['type']
                                                                            .toString(),
                                                                      );
                                                                    }

                                                                    notificationController
                                                                            .isAllSelect
                                                                            .value =
                                                                        notificationController
                                                                            .readNotificationSelectList
                                                                            .every((isSelected) =>
                                                                                isSelected);
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 6.h),
                                                        Text(
                                                          "${notificationController.readNotificationList[index]['description'] ?? ""}",
                                                          style:
                                                              changeTextColor(
                                                                  rubikRegular,
                                                                  subTextColor),
                                                        ),
                                                        SizedBox(height: 6.h),
                                                        Text(
                                                          "${notificationController.readNotificationList[index]['created_at'] ?? ""}",
                                                          style:
                                                              changeTextColor(
                                                                  rubikMedium,
                                                                  subTextColor),
                                                        )
                                                      ],
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
                  ],
                ),
        ),
      ),
    );
  }

  Widget viewNotification(BuildContext context, notificationList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 200.h,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Text(
                "${notificationList['title'] ?? ""}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                width: 400,
                child: Text(
                  "${notificationList['description'] ?? ""}",
                  style: changeTextColor(rubikRegular, subTextColor),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "${notificationList['created_at'] ?? ""}",
                style: changeTextColor(rubikMedium, subTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
