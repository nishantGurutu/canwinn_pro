import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/priority_model.dart';

class PriorityPage extends StatefulWidget {
  const PriorityPage({super.key});

  @override
  State<PriorityPage> createState() => _PriorityPageState();
}

class _PriorityPageState extends State<PriorityPage> {
  final PriorityController priorityController = Get.put(PriorityController());
  @override
  void initState() {
    priorityController.priorityApi();
    super.initState();
  }

  final TextEditingController priorityNameTextEditingControlelr =
      TextEditingController();
  final TextEditingController priorityNameTextEditingControlelr2 =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Image.asset(
                backArrowIcon,
                color: whiteColor,
              ),
            ),
          ),
        ),
        title: Text(
          priority,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => priorityController.isPriorityLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : priorityController.priorityList.isEmpty
                ? Center(
                    child: Text(
                      noPriority,
                      style: rubikBold,
                    ),
                  )
                : Column(
                    children: [
                      priorityList(priorityController.priorityList),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPriorityWidget();
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

  List<Color> colorList = [backgroundColor, whiteColor];
  Widget priorityList(List<PriorityData> priorityDataList) {
    return Expanded(
      child: ListView.separated(
        itemCount: priorityDataList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          DateTime? dt =
              DateTime.parse(priorityDataList[index].createdAt.toString());
          return Container(
            color: colorList[colorIndex],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${priorityDataList[index].priorityName}',
                            style: changeTextColor(rubikBold, darkGreyColor)),
                        PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                editPriorityWidget(
                                    priorityDataList[index].priorityName,
                                    priorityDataList[index].status,
                                    priorityDataList[index].id);

                                break;
                              case 'delete':
                                priorityController
                                    .deletePriority(priorityDataList[index].id);
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
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateConverter.formatDate(dt),
                          style: changeTextColor(rubikMedium, darkGreyColor),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.r))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            child: Center(
                              child: Text(
                                '${priorityDataList[index].status.toString() == "1" ? "Active" : ""}',
                                style: changeTextColor(rubikBold, whiteColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
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

  Future<void> addPriorityWidget() {
    priorityController.selectedStatus.value = '';
    priorityNameTextEditingControlelr.clear();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            height: 300.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addPriority,
                        style: robotoBlack,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 35.h,
                          width: 35.w,
                          child: const Center(
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 0.5),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        priority,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: priority,
                        keyboardType: TextInputType.emailAddress,
                        controller: priorityNameTextEditingControlelr,
                        textCapitalization: TextCapitalization.sentences,
                        data: sourceName,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        status,
                        style: rubikRegular,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15.w,
                                child: Obx(
                                  () => Radio(
                                    value: 'active',
                                    groupValue:
                                        priorityController.selectedStatus.value,
                                    onChanged: (value) {
                                      priorityController.selectedStatus.value =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                active,
                                style: robotoRegular,
                              )
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Row(
                            children: [
                              SizedBox(
                                width: 15.w,
                                child: Obx(
                                  () => Radio(
                                    value: 'inactive',
                                    groupValue:
                                        priorityController.selectedStatus.value,
                                    onChanged: (value) {
                                      priorityController.selectedStatus.value =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                inActive,
                                style: robotoRegular,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
                const Divider(thickness: 0.5),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        color: whiteColor,
                        onPressed: () {
                          Get.back();
                        },
                        text: Text(
                          cancel,
                          style: TextStyle(color: darkGreyColor),
                        ),
                        width: 100.w,
                        height: 45.h,
                      ),
                      SizedBox(width: 15.w),
                      Obx(
                        () => CustomButton(
                          color: secondaryColor,
                          onPressed: () {
                            if (priorityController.isPriorityAdding.value !=
                                true) {
                              priorityController.addPriority(
                                  priorityNameTextEditingControlelr.text,
                                  priorityController.selectedStatus.value);
                            }
                          },
                          text:
                              priorityController.isPriorityAdding.value == true
                                  ? Center(
                                      child: SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: CircularProgressIndicator(
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      submit,
                                      style: TextStyle(color: whiteColor),
                                    ),
                          width: 100.w,
                          height: 45.h,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> editPriorityWidget(
      String? sourceName2, int? statusVal, int? sourceId) {
    priorityController.selectedStatus.value = '';
    priorityNameTextEditingControlelr2.text = sourceName2.toString();
    priorityController.selectedStatus2.value =
        statusVal.toString() == '1' ? "active" : "inactive";
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            height: 300.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        editPriority,
                        style: robotoBlack,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 35.h,
                          width: 35.w,
                          child: const Center(
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 0.5),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        priority,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: priority,
                        keyboardType: TextInputType.emailAddress,
                        controller: priorityNameTextEditingControlelr2,
                        textCapitalization: TextCapitalization.sentences,
                        data: sourceName,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        status,
                        style: rubikRegular,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15.w,
                                child: Obx(
                                  () => Radio(
                                    value: 'active',
                                    groupValue: priorityController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      priorityController.selectedStatus2.value =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                active,
                                style: robotoRegular,
                              )
                            ],
                          ),
                          SizedBox(width: 10.w),
                          Row(
                            children: [
                              SizedBox(
                                width: 15.w,
                                child: Obx(
                                  () => Radio(
                                    value: 'inactive',
                                    groupValue: priorityController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      priorityController.selectedStatus2.value =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                inActive,
                                style: robotoRegular,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
                const Divider(thickness: 0.5),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        color: whiteColor,
                        onPressed: () {
                          Get.back();
                        },
                        text: Text(
                          cancel,
                          style: TextStyle(color: darkGreyColor),
                        ),
                        width: 100.w,
                        height: 45.h,
                      ),
                      SizedBox(width: 15.w),
                      Obx(
                        () => CustomButton(
                          color: secondaryColor,
                          onPressed: () {
                            if (priorityController.isPriorityEditing.value !=
                                true) {
                              priorityController.editPriority(
                                  priorityNameTextEditingControlelr2.text,
                                  sourceId);
                            }
                          },
                          text:
                              priorityController.isPriorityEditing.value == true
                                  ? Center(
                                      child: SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: CircularProgressIndicator(
                                          color: whiteColor,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      edit,
                                      style: TextStyle(color: whiteColor),
                                    ),
                          width: 100.w,
                          height: 45.h,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
