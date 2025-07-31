// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/view/widgets/add_event.dart';
import 'package:readmore/readmore.dart';
import 'package:task_management/view/widgets/edit_feed_event.dart';
import 'package:url_launcher/url_launcher.dart';

class EventList extends StatelessWidget {
  final RxList feedEventList;
  EventList(this.feedEventList, {super.key});

  final FeedController feedController = Get.find();

  List<Color> colorList = <Color>[
    feedFirstColor,
    feedSecondColor.withOpacity(0.24),
    feedThirdColor,
  ];

  _launchURL(param0) async {
    final Uri url = Uri.parse('$param0');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddEvent(),
                          ),
                        );
                      },
                      child: Container(
                        height: 30.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Add event',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
          feedController.feedEventList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No event data',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    itemCount: feedController.feedEventList.length + 1,
                    itemBuilder: (context, index) {
                      return index <= feedController.feedEventList.length - 1
                          ? Stack(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          colorList[index % colorList.length],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 15.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${feedController.feedEventList[index]['title'] ?? ""}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: textColor),
                                          ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          ReadMoreText(
                                            '${feedController.feedEventList[index]['description'] ?? ""}',
                                            trimMode: TrimMode.Line,
                                            trimLines: 2,
                                            colorClickableText: Colors.pink,
                                            trimCollapsedText: 'Read more',
                                            trimExpandedText: '  Show less',
                                            lessStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink),
                                            moreStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor),
                                          ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          Text(
                                            '${feedController.feedEventList[index]['event_venue'] ?? ""}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: textColor),
                                          ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          Text(
                                            '${feedController.feedEventList[index]['event_date'] ?? ""} ${feedEventList[index]['event_time'] ?? ""}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: textColor),
                                          ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _launchURL(feedController
                                                          .feedEventList[index]
                                                      ['link'] ??
                                                  "");
                                            },
                                            child: Text(
                                              '${feedController.feedEventList[index]['link'] ?? ""}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: textColor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          feedController
                                                  .feedEventList[index]
                                                      ['attend_user_details']
                                                  .isEmpty
                                              ? SizedBox()
                                              : Text(
                                                  'Attending User',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textColor),
                                                ),
                                          SizedBox(
                                            height: 5.w,
                                          ),
                                          feedController
                                                  .feedEventList[index]
                                                      ['attend_user_details']
                                                  .isEmpty
                                              ? SizedBox()
                                              : ReadMoreText(
                                                  "${feedController.feedEventList[index]['attend_user_details'] ?? ""}",
                                                  trimMode: TrimMode.Line,
                                                  trimLines: 2,
                                                  colorClickableText:
                                                      Colors.pink,
                                                  trimCollapsedText:
                                                      'Read more',
                                                  trimExpandedText:
                                                      '  Show less',
                                                  lessStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.pink),
                                                  moreStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: secondaryColor),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: PopupMenuButton<String>(
                                    constraints: BoxConstraints(
                                      maxWidth: 150.w,
                                    ),
                                    color: whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    icon: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onSelected: (String result) {
                                      switch (result) {
                                        case 'edit':
                                          Get.back();

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: EditFeedEvent(
                                                  feedController
                                                      .feedEventList[index]),
                                            ),
                                          );
                                          break;
                                        case 'delete':
                                          Get.back();
                                          if (feedController
                                                  .isEventDeleting.value ==
                                              false) {
                                            feedController.deleteEventList(
                                                feedEventList[index]['id']);
                                          }
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: ListTile(
                                          leading: Image.asset(
                                            'assets/images/png/edit_image.png',
                                            height: 20.h,
                                          ),
                                          title: Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: ListTile(
                                          leading: Image.asset(
                                            'assets/images/png/delete_image.png',
                                            height: 20.h,
                                          ),
                                          title: Text(
                                            'Delete',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 60.h,
                            );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10.h,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
