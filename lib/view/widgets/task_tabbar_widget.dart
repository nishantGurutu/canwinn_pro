import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/task_controller.dart';

class TaskTabBar extends StatelessWidget {
  const TaskTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 40.h,
        width: 580.w,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: secondaryBorderColor),
          ),
        ),
        child: Row(
          children: [
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 0;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 0
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Total Task",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 1;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 1
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 100,
                  child: Center(
                    child: Text(
                      "New Task",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 2;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 2
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Assigned",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 3;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 3
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Due Today",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 4;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 4
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 130,
                  child: Center(
                    child: Text(
                      "Past due date",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () {
                  taskController.taskTabIndex.value = 5;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: taskController.taskTabIndex.value == 5
                        ? Border(
                            bottom: BorderSide(color: darkGreyColor),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  height: 40.h,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Closed Task",
                      style: rubikRegular,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
