import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/view/widgets/task_tabbar_widget.dart';

class MyTask extends StatefulWidget {
  const MyTask({super.key});

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  final TaskController taskController = Get.put(TaskController());
  List<TaskModel> headingText = [];

  @override
  void initState() {
    super.initState();
    headingText = [
      TaskModel(
        id: 1,
        taskName: "Task 1",
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assign: "John Doe",
        status: "Pending",
      ),
      TaskModel(
        id: 2,
        taskName: "Task 2",
        dueDate: DateTime.now().add(const Duration(days: 4)),
        assign: "Jane Doe",
        status: "In Progress",
      ),
      TaskModel(
        id: 3,
        taskName: "Task 3",
        dueDate: DateTime.now().add(const Duration(days: 6)),
        assign: "Alice",
        status: "Completed",
      ),
    ];
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
          myTask,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          const TaskTabBar(),
          Expanded(child: totalTaskWidget()),
        ],
      ),
    );
  }

  Widget totalTaskWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 530.w,
        child: Column(
          children: [
            Container(
              height: 40.h,
              color: backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200.w,
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      'Task Name',
                      style: rubikBold,
                    ),
                  ),
                  Container(
                    width: 110.w,
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      'Due Date',
                      style: rubikBold,
                    ),
                  ),
                  Container(
                    width: 110.w,
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      'Assigned To',
                      style: rubikBold,
                    ),
                  ),
                  Container(
                    width: 110.w,
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      'Status',
                      style: rubikBold,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: headingText.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, rowIndex) {
                  final task = headingText[rowIndex];
                  return SizedBox(
                    height: 40.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            children: [
                              Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.done,
                                    color: whiteColor,
                                    size: 15.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                task.taskName,
                                style: rubikRegular,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 110.w,
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            "${task.dueDate.toLocal()}".split(' ')[0],
                            style: rubikRegular,
                          ),
                        ),
                        Container(
                          width: 110.w,
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            task.assign,
                            style: rubikRegular,
                          ),
                        ),
                        Container(
                          width: 110.w,
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            task.status,
                            style: rubikRegular,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
