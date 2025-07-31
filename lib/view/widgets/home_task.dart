import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/widgets/home_title.dart';

class HomeTask extends StatelessWidget {
  final RxList<Tasklist> homeTaskList;
  final TaskController taskController;
  const HomeTask(this.homeTaskList, this.taskController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeTitle('My Task'),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: boxBorderColor),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: lightGreyColor.withOpacity(0.1),
                  blurRadius: 13.0,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Task Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Due Date",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Status",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: homeTaskList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => TaskDetails(
                                    taskId: homeTaskList[index].id,
                                    assignedStatus: taskController
                                        .selectedAssignedTask.value,
                                    initialIndex: 0,
                                  ));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      homeTaskList[index].title ?? "",
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        homeTaskList[index].dueDate ?? "",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: homeTaskList[index]
                                                    .effectiveStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                'pending'
                                            ? Color(0xffD045FF)
                                            : homeTaskList[index]
                                                        .status
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'progress'
                                                ? Color(0xff10BE13)
                                                : Color(0xff8C8AFE),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          homeTaskList[index]
                                              .effectiveStatus
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: lightBorderColor,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
