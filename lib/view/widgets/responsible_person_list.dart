import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class ResponsiblePersonList extends StatefulWidget {
  final String type;
  final dynamic reviewer;
  const ResponsiblePersonList(this.type, this.reviewer, {super.key});

  @override
  State<ResponsiblePersonList> createState() => _ResponsiblePersonListState();
}

class _ResponsiblePersonListState extends State<ResponsiblePersonList> {
  final TaskController taskController = Get.find();
  final HomeController homeController = Get.find();
  @override
  initState() {
    super.initState();
    updateData();
  }

  RxList<ResponsiblePersonData> filteredList = RxList<ResponsiblePersonData>();
  TextEditingController searchAssignController = TextEditingController();
  var isLoading = false.obs;
  void updateData() {
    isLoading.value = true;
    filteredList = RxList<ResponsiblePersonData>(
      homeController.responsiblePersonList,
    );
    List<String> splitReviewer = widget.reviewer.toString().split(',');
    for (int j = 0; j < splitReviewer.length; j++) {
      for (int i = 0; i < homeController.responsiblePersonList.length; i++) {
        if (homeController.responsiblePersonList[i].id.toString() ==
            splitReviewer[j].toString()) {
          taskController.responsiblePersonSelectedCheckBox2[filteredList[i]
                  .id] =
              true;
        }
      }
    }
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 600.h,
      child: SafeArea(
        child: Obx(
          () =>
              isLoading.value == true
                  ? Center(
                    child: CircularProgressIndicator(color: primaryButtonColor),
                  )
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment:
                              widget.type.toString().toLowerCase() == "assets"
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.type.toString().toLowerCase() == "assets"
                                  ? selectUser
                                  : widget.type.toString().toLowerCase() ==
                                      "reviewer"
                                  ? reviewerListTitle
                                  : assignedTaskText2,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.type.toString().toLowerCase() ==
                                "assets")
                              Row(
                                children: [
                                  Text(
                                    selectAll,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Obx(
                                    () => SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: Checkbox(
                                        value: taskController.selectAll.value,
                                        onChanged: (value) {
                                          taskController.selectAll.value =
                                              value!;
                                          taskController.assignedUserId.clear();
                                          homeController
                                              .responsiblePersonSelectedCheckBox2
                                              .clear();
                                          if (taskController.selectAll.value) {
                                            for (var person in filteredList) {
                                              homeController
                                                      .responsiblePersonSelectedCheckBox2[person
                                                      .id] =
                                                  true;
                                              taskController.assignedUserId.add(
                                                person.id.toString(),
                                              );
                                            }
                                          } else {
                                            for (var person in filteredList) {
                                              homeController
                                                      .responsiblePersonSelectedCheckBox2[person
                                                      .id] =
                                                  false;
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: searchAssignController,
                          onChanged: (value) {
                            filteredList.value =
                                homeController.responsiblePersonList
                                    .where(
                                      (person) =>
                                          person.name?.toLowerCase().contains(
                                            value.toLowerCase(),
                                          ) ??
                                          false,
                                    )
                                    .toList();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search here...',
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(color: secondaryColor),
                            counterText: "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Expanded(
                          child: Obx(
                            () => ListView.separated(
                              itemCount: filteredList.length,
                              reverse: false,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        color: thirdPrimryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.r),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.r),
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            '${filteredList[index].image ?? ""}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.asset(
                                                'assets/images/png/group_icon.png',
                                                height: 40.h,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${filteredList[index].name}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        StorageHelper.getId() ==
                                                filteredList[index].id
                                            ? Text(
                                              widget.type
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "reviewer"
                                                  ? "Self Reviewer"
                                                  : "Self Assign",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            )
                                            : SizedBox(),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: Obx(
                                        () => SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child: Checkbox(
                                            value:
                                                taskController
                                                    .responsiblePersonSelectedCheckBox2[filteredList[index]
                                                    .id] ??
                                                false,
                                            onChanged: (value) {
                                              taskController
                                                      .responsiblePersonSelectedCheckBox2[filteredList[index]
                                                      .id] =
                                                  value!;

                                              if (widget.type
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "reviewer") {
                                                if (taskController
                                                    .reviewerUserId
                                                    .contains(
                                                      filteredList[index].id
                                                          .toString(),
                                                    )) {
                                                  taskController.reviewerUserId
                                                      .remove(
                                                        filteredList[index].id
                                                            .toString(),
                                                      );
                                                } else {
                                                  taskController.reviewerUserId
                                                      .add(
                                                        filteredList[index].id
                                                            .toString(),
                                                      );
                                                }
                                              } else {
                                                if (value) {
                                                  taskController.assignedUserId
                                                      .add(
                                                        filteredList[index].id
                                                            .toString(),
                                                      );
                                                } else {
                                                  taskController.assignedUserId
                                                      .remove(
                                                        filteredList[index].id
                                                            .toString(),
                                                      );
                                                  taskController
                                                      .selectAll
                                                      .value = false;
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                return SizedBox(height: 10.h);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomButton(
                          onPressed: () {
                            Get.back();
                          },
                          text: Text(
                            done,
                            style: changeTextColor(rubikBlack, whiteColor),
                          ),
                          color: primaryColor,
                          height: 45.h,
                          width: double.infinity,
                        ),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
