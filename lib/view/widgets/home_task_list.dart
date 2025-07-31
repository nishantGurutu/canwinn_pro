import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/custom_text_convert.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/view/screen/task_details.dart';

class HomeTaskList extends StatelessWidget {
  final RxList<LatestComments> homeTaskList;
  HomeTaskList(this.homeTaskList, {super.key});
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: homeTaskList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 4.h,
                ),
                InkWell(
                  onLongPress: () {},
                  onTap: () {
                    Get.to(TaskDetails(
                        taskId: homeTaskList[index].taskId,
                        assignedStatus:
                            taskController.selectedAssignedTask.value,
                        initialIndex: 2));
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              color: Color(0xffF4E2FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.h)),
                            ),
                            child: Center(
                              child: Text(
                                '${CustomTextConvert().getNameChar(homeTaskList[index].senderName)}',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 300.w,
                                  child: Text(
                                    '${homeTaskList[index].taskTitle ?? ""}',
                                    style: heading6,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${homeTaskList[index].message ?? ""}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: changeTextColor(
                                              heading10, timeColor)),
                                    ),
                                    Text(
                                        '${homeTaskList[index].messageDate.split(" ").last}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: changeTextColor(
                                            heading10, timeColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                homeTaskList.length - 1 == index
                    ? SizedBox(
                        height: 2.h,
                      )
                    : Divider(
                        thickness: 1,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
