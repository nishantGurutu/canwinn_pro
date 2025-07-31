import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/status_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/status_model.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final StatusController statusController = Get.put(StatusController());
  @override
  void initState() {
    statusController.statusApi();
    super.initState();
  }

  final TextEditingController statusTextEditingControlelr =
      TextEditingController();
  final TextEditingController statusTextEditingControlelr2 =
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
          status,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => statusController.isStatusLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : statusController.statusList.isEmpty
                ? Center(
                    child: Text(
                      noPriority,
                      style: rubikBold,
                    ),
                  )
                : Column(
                    children: [
                      statusList(statusController.statusList),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStatusWidget();
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
  Widget statusList(List<StatusData> statusDataList) {
    return Expanded(
      child: ListView.separated(
        itemCount: statusDataList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          DateTime? dt =
              DateTime.parse(statusDataList[index].createdAt.toString());
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
                        Text('${statusDataList[index].statusName}',
                            style: changeTextColor(rubikBold, darkGreyColor)),
                        PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                editStatusWidget(
                                    statusDataList[index].statusName,
                                    statusDataList[index].status,
                                    statusDataList[index].id);

                                break;
                              case 'delete':
                                statusController
                                    .deleteStatus(statusDataList[index].id);
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
                                statusDataList[index].status.toString() == "1"
                                    ? "Active"
                                    : "",
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

  Future<void> addStatusWidget() {
    statusController.selectedStatus.value = '';
    statusTextEditingControlelr.clear();
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
                        addStatus,
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
                        status,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: status,
                        keyboardType: TextInputType.emailAddress,
                        controller: statusTextEditingControlelr,
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
                                        statusController.selectedStatus.value,
                                    onChanged: (value) {
                                      statusController.selectedStatus.value =
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
                                        statusController.selectedStatus.value,
                                    onChanged: (value) {
                                      statusController.selectedStatus.value =
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
                            if (statusController.isStatusAdding.value != true) {
                              statusController.addStatus(
                                  statusTextEditingControlelr.text,
                                  statusController.selectedStatus.value);
                            }
                          },
                          text: statusController.isStatusAdding.value == true
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

  Future<void> editStatusWidget(
      String? sourceName2, int? statusVal, int? sourceId) {
    statusController.selectedStatus.value = '';
    statusTextEditingControlelr2.text = sourceName2.toString();
    statusController.selectedStatus2.value =
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
                        editStatus,
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
                        status,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: status,
                        keyboardType: TextInputType.emailAddress,
                        controller: statusTextEditingControlelr2,
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
                                        statusController.selectedStatus2.value,
                                    onChanged: (value) {
                                      statusController.selectedStatus2.value =
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
                                        statusController.selectedStatus2.value,
                                    onChanged: (value) {
                                      statusController.selectedStatus2.value =
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
                            if (statusController.isStatusEditing.value !=
                                true) {
                              statusController.editStatus(
                                  statusTextEditingControlelr2.text, sourceId);
                            }
                          },
                          text: statusController.isStatusEditing.value == true
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
