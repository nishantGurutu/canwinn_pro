import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class InScreenForm extends StatefulWidget {
  const InScreenForm({super.key});

  @override
  State<InScreenForm> createState() => _InScreenFormState();
}

class _InScreenFormState extends State<InScreenForm> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final ProfileController profileController = Get.put(ProfileController());

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController departmentNameController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  @override
  void initState() {
    profileController.departmentList(0);
    super.initState();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      outScreenController.isChalanPicUploading.value = true;
      outScreenController.pickedFile.value = File(pickedImage.path);
      outScreenController.chalanPicPath.value = pickedImage.path.toString();
      outScreenController.isChalanPicUploading.value = false;
    } catch (e) {
      outScreenController.isChalanPicUploading.value = false;
    } finally {
      outScreenController.isChalanPicUploading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
          inScreen,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 15.h,
                children: [
                  InkWell(
                    onTap: () {
                      takePhoto(ImageSource.camera);
                    },
                    child: Obx(
                      () => outScreenController.chalanPicPath.value.isEmpty
                          ? Column(
                              children: [
                                Container(
                                  height: 92.h,
                                  width: 92.w,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border.all(color: lightBorderColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/image/svg/add_photo.svg',
                                      height: 59.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 90.h,
                              width: 90.w,
                              child: Image.file(
                                File(
                                  outScreenController.chalanPicPath.value,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                  TaskCustomTextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.sentences,
                    data: visitorName,
                    hintText: visitorName,
                    labelText: visitorName,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  TaskCustomTextField(
                    controller: contactController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    data: visitorContact,
                    hintText: visitorContact,
                    labelText: visitorContact,
                    index: 5,
                    maxLength: 10,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  TaskCustomTextField(
                    controller: dateController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    data: dateFormate,
                    hintText: dateFormate,
                    labelText: dateFormate,
                    index: 5,
                    maxLength: 10,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        dateController.text = formattedDate;
                      }
                    },
                    readOnly: true,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  CustomDropdown<DepartmentListData>(
                    items: profileController.departmentDataList,
                    itemLabel: (item) => item.name ?? '',
                    onChanged: (value) {
                      profileController.selectedDepartMentListData.value =
                          value!;
                    },
                    hintText: selectDepartment,
                  ),
                  TaskCustomTextField(
                    controller: purposeController,
                    textCapitalization: TextCapitalization.sentences,
                    data: purpose,
                    hintText: purpose,
                    labelText: purpose,
                    index: 4,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  TaskCustomTextField(
                    controller: addressController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    data: address,
                    hintText: address,
                    labelText: address,
                    index: 6,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  Obx(
                    () => CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (outScreenController
                                  .isOutScreenChalanAdding.value !=
                              true) {
                            outScreenController.addInScreenChalanApi(
                              nameController.text,
                              dateController.text,
                              profileController
                                  .selectedDepartMentListData.value?.id,
                              purposeController.text,
                              contactController.text,
                              addressController.text,
                            );
                          }
                        }
                      },
                      text: outScreenController.isOutScreenChalanAdding.value ==
                              true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  loading,
                                  style:
                                      changeTextColor(rubikBlack, whiteColor),
                                ),
                              ],
                            )
                          : Text(
                              save,
                              style: changeTextColor(rubikBlack, whiteColor),
                            ),
                      color: primaryColor,
                      height: 45.h,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  Widget addDataTableBottomSheet(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 410.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15.h,
              children: [
                SizedBox(height: 5.h),
                Text(
                  'Add Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TaskCustomTextField(
                  controller: outScreenController.itemController,
                  textCapitalization: TextCapitalization.none,
                  data: item,
                  hintText: item,
                  labelText: item,
                  index: 7,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                CustomDropdown<String>(
                  items: outScreenController.returnableValue,
                  itemLabel: (item) => item,
                  onChanged: (value) {
                    outScreenController.selectedReturnableValue.value = value!;
                  },
                  hintText: selectReturnable,
                ),
                TaskCustomTextField(
                  controller: outScreenController.quantityController,
                  textCapitalization: TextCapitalization.none,
                  data: qty,
                  hintText: qty,
                  labelText: qty,
                  keyboardType: TextInputType.number,
                  index: 9,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                TaskCustomTextField(
                  controller: outScreenController.remarkController,
                  textCapitalization: TextCapitalization.none,
                  data: remark,
                  hintText: remark,
                  labelText: remark,
                  index: 10,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      int returnType = 0;
                      if (outScreenController.selectedReturnableValue.value ==
                          'false') {
                        returnType = 1;
                      } else {
                        returnType = 0;
                      }
                      if (_formKey2.currentState!.validate()) {
                        outScreenController.tableDataAdding(
                          outScreenController.itemController.text,
                          returnType,
                          outScreenController.quantityController.text,
                          outScreenController.remarkController.text,
                        );
                      }
                    },
                    text: outScreenController.isDataAdding.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                loading,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              ),
                            ],
                          )
                        : Text(
                            add,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    width: double.infinity,
                    color: primaryColor,
                    height: 45.h,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
