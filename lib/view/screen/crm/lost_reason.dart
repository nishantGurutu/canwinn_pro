import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lost_reason_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/lost_reason_model.dart';

class LostReason extends StatefulWidget {
  const LostReason({super.key});

  @override
  State<LostReason> createState() => _LostReasonState();
}

class _LostReasonState extends State<LostReason> {
  final LostReasonController lostReasonController =
      Get.put(LostReasonController());
  @override
  void initState() {
    lostReasonController.lostReasonListApi();
    super.initState();
  }

  final TextEditingController lostReasonTextEditingControlelr =
      TextEditingController();
  final TextEditingController lostReasonTextEditingControlelr2 =
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
          lostReason,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => lostReasonController.isLostReasonLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : lostReasonController.lostReasonList.isEmpty
                ? Center(
                    child: Text(
                      noLostReasonData,
                      style: rubikBold,
                    ),
                  )
                : Column(
                    children: [
                      lostReasonList(lostReasonController.lostReasonList),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addlostReasonWidget();
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
  Widget lostReasonList(List<LostReasonData> lostReasonDataList) {
    return Expanded(
      child: ListView.separated(
        itemCount: lostReasonDataList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          DateTime? dt =
              DateTime.parse(lostReasonDataList[index].createdAt.toString());
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
                        Text('${lostReasonDataList[index].name}',
                            style: changeTextColor(rubikBold, darkGreyColor)),
                        PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                editLostReasonWidget(
                                    lostReasonDataList[index].name,
                                    lostReasonDataList[index].status,
                                    lostReasonDataList[index].id);

                                break;
                              case 'delete':
                                lostReasonController.deleteLostReason(
                                    lostReasonDataList[index].id);
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
                                lostReasonDataList[index].status.toString() ==
                                        "1"
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

  Future<void> addlostReasonWidget() {
    lostReasonController.selectedStatus.value = '';
    lostReasonTextEditingControlelr.clear();
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
                        addLostReason,
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
                        lostReason,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: lostReason,
                        keyboardType: TextInputType.emailAddress,
                        controller: lostReasonTextEditingControlelr,
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
                                    groupValue: lostReasonController
                                        .selectedStatus.value,
                                    onChanged: (value) {
                                      lostReasonController
                                          .selectedStatus.value = value!;
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
                                    groupValue: lostReasonController
                                        .selectedStatus.value,
                                    onChanged: (value) {
                                      lostReasonController
                                          .selectedStatus.value = value!;
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
                            if (lostReasonController.isLostReasonAdding.value !=
                                true) {
                              lostReasonController.addLostReason(
                                  lostReasonTextEditingControlelr.text,
                                  lostReasonController.selectedStatus.value);
                            }
                          },
                          text: lostReasonController.isLostReasonAdding.value ==
                                  true
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

  Future<void> editLostReasonWidget(
      String? sourceName2, int? statusVal, int? sourceId) {
    lostReasonController.selectedStatus.value = '';
    lostReasonTextEditingControlelr2.text = sourceName2.toString();
    lostReasonController.selectedStatus2.value =
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
                        editLostReason,
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
                        lostReason,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: lostReason,
                        keyboardType: TextInputType.emailAddress,
                        controller: lostReasonTextEditingControlelr2,
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
                                    groupValue: lostReasonController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      lostReasonController
                                          .selectedStatus2.value = value!;
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
                                    groupValue: lostReasonController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      lostReasonController
                                          .selectedStatus2.value = value!;
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
                            if (lostReasonController
                                    .isLostReasonEditing.value !=
                                true) {
                              lostReasonController.editLostReason(
                                  lostReasonTextEditingControlelr2.text,
                                  sourceId);
                            }
                          },
                          text:
                              lostReasonController.isLostReasonEditing.value ==
                                      true
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
