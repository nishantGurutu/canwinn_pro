import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/challan_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class EntryPassScreen extends StatefulWidget {
  const EntryPassScreen({super.key});

  @override
  State<EntryPassScreen> createState() => _EntryPassScreenState();
}

class _EntryPassScreenState extends State<EntryPassScreen> {
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController contactTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController entryTextEditingController =
      TextEditingController();
  final TextEditingController purposeTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ChallanController challanController = Get.put(ChallanController());
  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      challanController.isProfilePicUploading.value = true;
      challanController.pickedFile.value = File(pickedImage.path);
      challanController.profilePicPath.value = pickedImage.path.toString();
      challanController.isProfilePicUploading.value = false;
    } catch (e) {
      challanController.isProfilePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      challanController.isProfilePicUploading.value = false;
    }
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
          entryPass,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        takePhoto(ImageSource.camera);
                      },
                      child: Stack(
                        children: [
                          Obx(
                            () => challanController.profilePicPath.value == ""
                                ? Container(
                                    height: 90.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(45.r),
                                        ),
                                        border: Border.all(color: borderColor)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(45.r)),
                                      child: Image.asset(
                                          'assets/images/png/profile-image-removebg-preview.png'),
                                    ),
                                  )
                                : challanController.profilePicPath.value ==
                                            "" ||
                                        !challanController.profilePicPath.value
                                            .contains('.jpg')
                                    ? Container(
                                        height: 90.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(45.r))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(45.r)),
                                          // child: Image.network(
                                          //   widget.image.toString(),
                                          //   fit: BoxFit.cover,
                                          //   errorBuilder:
                                          //       (context, error, stackTrace) {
                                          //     return Container(
                                          //       decoration: BoxDecoration(
                                          //         borderRadius:
                                          //             BorderRadius.all(
                                          //           Radius.circular(20.r),
                                          //         ),
                                          //       ),
                                          //       child:
                                          //           Image.asset(backgroundLogo),
                                          //     );
                                          //   },
                                          // ),
                                        ),
                                      )
                                    : Container(
                                        height: 90.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(45.r))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(45.r)),
                                          child: Image.file(
                                            File(
                                              challanController
                                                  .profilePicPath.value,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            left: 103.w,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Icon(
                                Icons.camera_alt,
                                color: subTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: nameTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: name,
                  data: name,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: contactTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: contact,
                  data: contact,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: addressTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: address,
                  data: address,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: entryTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: entryRemark,
                  data: entryPass,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: purposeTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  hintText: purpose,
                  data: purpose,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                // Obx(
                //   () =>
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // if (notesController.isNotesEditing.value == false) {
                      // notesController.editNote(
                      //   editTitleTextEditingControlelr.text,
                      //   editDescTextEditingControlelr.text,
                      //   todoController.selectedTagData?.id ?? 0,
                      //   priorityController.selectedPriorityData?.id,
                      //   id,
                      // );
                    }
                    // }
                  },
                  text:
                      // notesController.isNotesEditing.value == true
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           SizedBox(
                      //             height: 30.h,
                      //             child: CircularProgressIndicator(
                      //               color: whiteColor,
                      //             ),
                      //           ),
                      //           SizedBox(width: 10.w),
                      //           Text(
                      //             loading,
                      //             style: changeTextColor(rubikBlack, whiteColor),
                      //           ),
                      //         ],
                      //       )
                      //     :
                      Text(
                    submit,
                    style: TextStyle(color: whiteColor),
                  ),
                  width: double.infinity,
                  color: primaryColor,
                  height: 45.h,
                ),
                // ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
