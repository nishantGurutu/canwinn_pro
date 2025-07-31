import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/view/screen/edit_project.dart';
import 'package:task_management/view/widgets/add_task.dart';

class CreatedByMeProject extends StatefulWidget {
  final RxList<CreatedByMe> createdProjectList;
  final ProfileController profileController;
  final ProjectController projectController;
  final TaskController taskController;
  final PriorityController priorityController;
  final HomeController homeController;
  const CreatedByMeProject(
      this.createdProjectList,
      this.profileController,
      this.projectController,
      this.taskController,
      this.priorityController,
      this.homeController,
      {super.key});

  @override
  State<CreatedByMeProject> createState() => _CreatedByMeProjectState();
}

class _CreatedByMeProjectState extends State<CreatedByMeProject> {
  @override
  void initState() {
    super.initState();
    widget.taskController.responsiblePersonListApi(
        widget.profileController.selectedDepartMentListData.value?.id, "");
    widget.profileController.departmentList(
        widget.projectController.selectedAllProjectListData.value?.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.createdProjectList.isEmpty
        ? Center(
            child: Text(
              'No project available',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ListView.builder(
            itemCount: widget.createdProjectList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: newLightTextColor),
                          borderRadius:
                              BorderRadius.all(Radius.circular(11.r))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.h,
                          children: [
                            Text(
                              'Project ID ${widget.createdProjectList[index].id}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: newLightTextColor),
                            ),
                            Text(
                              '${widget.createdProjectList[index].name}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                            Text(
                              '${widget.createdProjectList[index].description}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: textColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: activeColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(11.r))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 2.h),
                                    child: Text(
                                      '${widget.createdProjectList[index].statusName}',
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/png/calendar_month.png",
                                        height: 18.h,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${widget.createdProjectList[index].startDate}',
                                        style: TextStyle(
                                            color: newLightTextColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: SizedBox(
                        height: 20.h,
                        width: 30.w,
                        child: PopupMenuButton<String>(
                          color: whiteColor,
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) async {
                            switch (result) {
                              case 'edit':
                                Get.to(EditProject(
                                    widget.createdProjectList[index]));
                                break;
                              case 'delete':
                                await widget.projectController.deleteProject(
                                  widget.createdProjectList[index].id,
                                );
                                break;
                              case 'addTask':
                                for (var deptId in widget
                                    .projectController.allProjectDataList) {
                                  if (widget.createdProjectList[index].id ==
                                      deptId.id) {
                                    widget
                                        .projectController
                                        .selectedAllProjectListData
                                        .value = deptId;

                                    await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: AddTask(
                                            widget.priorityController
                                                .priorityList,
                                            widget.projectController
                                                .allProjectDataList,
                                            widget.taskController
                                                .responsiblePersonList,
                                            widget.createdProjectList[index].id,
                                            ""),
                                      ),
                                    );
                                    return;
                                  }
                                }
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'addTask',
                              child: ListTile(
                                leading: Icon(Icons.task),
                                title: Text('Add Task'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
