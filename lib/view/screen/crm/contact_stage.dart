import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/contact_stage_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/contact_stage_Model.dart';

class ContactStagePage extends StatefulWidget {
  const ContactStagePage({super.key});

  @override
  State<ContactStagePage> createState() => _ContactStagePageState();
}

class _ContactStagePageState extends State<ContactStagePage> {
  final ContactStageController contactStageController =
      Get.put(ContactStageController());
  @override
  void initState() {
    contactStageController.contactStatusApi();
    super.initState();
  }

  final TextEditingController contactStagTextEditingControlelr =
      TextEditingController();
  final TextEditingController contactStagTextEditingControlelr2 =
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
          contactStage,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => contactStageController.isContactStatusLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : contactStageController.contactStageList.isEmpty
                ? Center(
                    child: Text(
                      noPriority,
                      style: rubikBold,
                    ),
                  )
                : Column(
                    children: [
                      contactStageList(contactStageController.contactStageList),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addContactStageWidget();
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
  Widget contactStageList(List<ContactStageData> contactStageDataList) {
    return Expanded(
      child: ListView.separated(
        itemCount: contactStageDataList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          DateTime? dt =
              DateTime.parse(contactStageDataList[index].createdAt.toString());
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
                        Text('${contactStageDataList[index].contactStageName}',
                            style: changeTextColor(rubikBold, darkGreyColor)),
                        PopupMenuButton<String>(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) {
                            switch (result) {
                              case 'edit':
                                editContactStageWidget(
                                    contactStageDataList[index]
                                        .contactStageName,
                                    contactStageDataList[index].status,
                                    contactStageDataList[index].id);

                                break;
                              case 'delete':
                                contactStageController.deleteContactStage(
                                    contactStageDataList[index].id);
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
                                '${contactStageDataList[index].status.toString() == "1" ? "Active" : ""}',
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

  Future<void> addContactStageWidget() {
    contactStageController.selectedStatus.value = '';
    contactStagTextEditingControlelr.clear();
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
                        addContactStage,
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
                        contactStage,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: contactStage,
                        keyboardType: TextInputType.emailAddress,
                        controller: contactStagTextEditingControlelr,
                        textCapitalization: TextCapitalization.sentences,
                        data: sourceName,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        contactStage,
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
                                    groupValue: contactStageController
                                        .selectedStatus.value,
                                    onChanged: (value) {
                                      contactStageController
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
                                    groupValue: contactStageController
                                        .selectedStatus.value,
                                    onChanged: (value) {
                                      contactStageController
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
                            if (contactStageController
                                    .isContactStageAdding.value !=
                                true) {
                              contactStageController.addContactStage(
                                  contactStagTextEditingControlelr.text,
                                  contactStageController.selectedStatus.value);
                            }
                          },
                          text: contactStageController
                                      .isContactStageAdding.value ==
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

  Future<void> editContactStageWidget(
      String? sourceName2, int? statusVal, int? sourceId) {
    contactStageController.selectedStatus.value = '';
    contactStagTextEditingControlelr2.text = sourceName2.toString();
    contactStageController.selectedStatus2.value =
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
                        editContactStage,
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
                        contactStage,
                        style: rubikRegular,
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        hintText: contactStage,
                        keyboardType: TextInputType.emailAddress,
                        controller: contactStagTextEditingControlelr2,
                        textCapitalization: TextCapitalization.sentences,
                        data: sourceName,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        contactStage,
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
                                    groupValue: contactStageController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      contactStageController
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
                                    groupValue: contactStageController
                                        .selectedStatus2.value,
                                    onChanged: (value) {
                                      contactStageController
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
                            if (contactStageController
                                    .isContactStageEditing.value !=
                                true) {
                              contactStageController.editContactStage(
                                  contactStagTextEditingControlelr2.text,
                                  sourceId);
                            }
                          },
                          text: contactStageController
                                      .isContactStageEditing.value ==
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
