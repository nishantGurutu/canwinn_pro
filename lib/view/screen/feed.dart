import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/widgets/event_list.dart';
import 'package:task_management/view/widgets/feed_list.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FeedController feedController = Get.put(FeedController());
  final TaskController taskController = Get.put(TaskController());
  RxString firstLetters = ''.obs;
  RxString userName = ''.obs;

  @override
  void initState() {
    if (feedController.fromPage.value == 'home') {
      feedController.feedTabList.clear();
      feedController.feedTabList.addAll(List<bool>.filled(3, false));
      feedController.feedTabList[1] = true;
    } else {
      feedController.feedTabList.addAll(List<bool>.filled(3, false));
      feedController.feedTabList[0] = true;
    }
    apiCalling();
    super.initState();
  }

  @override
  void dispose() {
    feedController.fromPage.value == '';
    super.dispose();
  }

  void apiCalling() async {
    await feedController.feedListApi();
    await feedController.eventList();
    await taskController.responsiblePersonListApi(0, "");

    String sn = StorageHelper.getName().toString();
    userName.value = StorageHelper.getName().toString();
    List<String> splitString = sn.split(" ");
    firstLetters.value = splitString.map((word) => word[0]).join('');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => feedController.isFeedListLoading.value == true &&
              taskController.isResponsiblePersonLoading.value == true &&
              feedController.isEventLoading.value == true
          ? Scaffold(
              backgroundColor: whiteColor,
              body:
                  Center(child: CircularProgressIndicator(color: primaryColor)),
            )
          : Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Text(
                          'Feeds',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        Spacer(),
                        Container(
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: feedTabColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(22.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  feedController.feedTabList.clear();
                                  feedController.feedTabList
                                      .addAll(List<bool>.filled(3, false));
                                  feedController.feedTabList[0] = true;
                                },
                                child: Container(
                                  width: 57.w,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: feedController.feedTabList[0] == true
                                        ? primaryColor
                                        : feedTabColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Recent',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: feedController.feedTabList[0] ==
                                                true
                                            ? whiteColor
                                            : Color(0xffAF52DE)
                                                .withOpacity(0.31),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  feedController.feedTabList.clear();
                                  feedController.feedTabList
                                      .addAll(List<bool>.filled(3, false));
                                  feedController.feedTabList[1] = true;
                                },
                                child: Container(
                                  width: 57.w,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: feedController.feedTabList[1] == true
                                        ? primaryColor
                                        : feedTabColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Event',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: feedController.feedTabList[1] ==
                                                true
                                            ? whiteColor
                                            : Color(0xffAF52DE)
                                                .withOpacity(0.31),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  feedController.feedTabList.clear();
                                  feedController.feedTabList
                                      .addAll(List<bool>.filled(3, false));
                                  feedController.feedTabList[2] = true;
                                },
                                child: Container(
                                  width: 57.w,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    color: feedController.feedTabList[2] == true
                                        ? primaryColor
                                        : feedTabColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Tasks',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: feedController.feedTabList[2] ==
                                                true
                                            ? whiteColor
                                            : Color(0xffAF52DE)
                                                .withOpacity(0.31),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  feedController.feedTabList[0] == true
                      ? Expanded(
                          child: feedController.feedList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No feed data',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                )
                              : FeedList(feedController.feedList),
                        )
                      : feedController.feedTabList[1] == true
                          ? Expanded(
                              child: EventList(feedController.feedEventList),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'No data',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ),
                            ),
                ],
              ),
            ),
    );
  }
}
