import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/activity_controller.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/activity_list_model.dart';
import 'package:task_management/view/screen/new_activity.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final ActivityController activityController = Get.put(ActivityController());
  @override
  void initState() {
    activityController.activityListApi();
    super.initState();
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
          activities,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => activityController.isActivityListLoading.value == true
            ? Container(
                color: backgroundColor,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    createdByMe(activityController.activityList),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const NewActivity());
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
          size: 30.h,
        ),
      ),
    );
  }

  List<Color> colorList = [backgroundColor, Colors.white];

  Widget createdByMe(List<ActivityData> activityList) {
    return Expanded(
      child: ListView.separated(
        itemCount: activityList.length,
        itemBuilder: (BuildContext context, int index) {
          String dt = activityList[index].createdAt.toString();
          DateTime dateTime = DateTime.parse(dt);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.r),
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: SizedBox(
                  width: 275.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${activityList[index].title}',
                              style:
                                  changeTextColor(rubikBlack, darkGreyColor)),
                          SizedBox(
                            height: 30.h,
                            width: 25.w,
                            child: PopupMenuButton<String>(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String result) {
                                switch (result) {
                                  // case 'edit':
                                  //   // Get.to(
                                  //   // EditTask(
                                  //   //   taskController.todayTask[i],
                                  //   // ),
                                  //   // );
                                  //   break;
                                  case 'delete':
                                    activityController.deleteActivityApi(
                                        activityList[index].id);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                // const PopupMenuItem<String>(
                                //   value: 'edit',
                                //   child: ListTile(
                                //     leading: Icon(Icons.edit),
                                //     title: Text('Edit'),
                                //   ),
                                // ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Type : ',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                          Text('${activityList[index].activityType}',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Owner : ',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                          SizedBox(width: 10.w),
                          Text('${activityList[index].guest}',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Due date : ',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                          SizedBox(width: 10.w),
                          Text('${activityList[index].dueDate}',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Created At : ',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                          SizedBox(width: 10.w),
                          Text('${DateConverter.formatDate(dateTime)}',
                              style:
                                  changeTextColor(rubikRegular, darkGreyColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5.h);
        },
      ),
    );
  }
}
