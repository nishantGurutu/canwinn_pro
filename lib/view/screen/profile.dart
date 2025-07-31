import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/user_assets_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.find();
  final UserPageControlelr userPageControlelr = Get.find();
  final TextEditingController anniversaryDateController =
      TextEditingController();
  @override
  void initState() {
    apiCall();
    super.initState();
  }

  Future<void> apiCall() async {
    await profileController.userDetails();
    await profileController.departmentList(0);
    // await profileController.dailyTaskList(context, '', '');
    await profileController.assignAssetsList();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      profileController.isProfilePicUploading.value = true;
      profileController.dataFromImagePicker.value = true;
      profileController.pickedFile.value = File(pickedImage.path);
      profileController.profilePicPath.value = pickedImage.path.toString();
      profileController.isProfilePicUploading.value = false;
      Get.back();
    } catch (e) {
      profileController.isProfilePicUploading.value = false;
    } finally {
      profileController.isProfilePicUploading.value = false;
    }
  }

  @override
  void dispose() {
    profileController.dataFromImagePicker.value = false;
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: File(file)),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.gallery);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/gallery-icon-removebg-preview.png',
                                height: 20.h,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.camera);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController qtytextEditingControlelr =
      TextEditingController();
  final TextEditingController srNoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Obx(
          () => profileController.isUserDetailsLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: SvgPicture.asset(
                                    'assets/images/svg/back_arrow.svg'),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: Stack(
                                    children: [
                                      Obx(
                                        () => profileController
                                                .profilePicPath.value.isEmpty
                                            ? Container(
                                                height: 90.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(45.r),
                                                    ),
                                                    border: Border.all(
                                                        color: borderColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              45.r)),
                                                  child: Image.asset(
                                                      'assets/images/png/profile-image-removebg-preview.png'),
                                                ),
                                              )
                                            : profileController
                                                            .dataFromImagePicker
                                                            .value ==
                                                        false &&
                                                    profileController
                                                        .profilePicPath
                                                        .value
                                                        .isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      openFile(
                                                        profileController
                                                                .profilePicPath
                                                                .value ??
                                                            '',
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 90.h,
                                                      width: 90.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      45.r))),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    45.r)),
                                                        child: Image.network(
                                                          "${profileController.profilePicPath.value}",
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20.r),
                                                                ),
                                                              ),
                                                              child: Image.asset(
                                                                  backgroundLogo),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 90.h,
                                                    width: 90.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    45.r))),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45.r)),
                                                      child: Image.file(
                                                        File(
                                                          profileController
                                                              .profilePicPath
                                                              .value,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                      Positioned(
                                        bottom: 5.h,
                                        right: 1.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: textColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: whiteColor,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  completeYourProfile,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => UserAssetsList(
                                        profileController.allocatedAssetsList,
                                        profileController));
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: primaryButtonColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Your Assets',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .nameTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  data: name,
                                  hintText: name,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .emailTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.emailAddress,
                                  data: email,
                                  hintText: email,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .mobileTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  data: mobileNumber,
                                  hintText: mobileNumber,
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomTextField(
                                    controller: profileController
                                        .departmentTextEditingController.value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    enable: false,
                                    data: departmentName,
                                    hintText: departmentName,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomTextField(
                                    controller: userPageControlelr
                                        .roleTextDateController.value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    enable: false,
                                    data: role,
                                    hintText: role,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomTextField(
                                    controller: profileController
                                        .genderDateController.value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    enable: true,
                                    data: gender,
                                    hintText: gender,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomTextField(
                                    controller: profileController
                                        .dobTextEditingController.value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    readonly: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Image.asset(
                                        'assets/images/png/callender.png',
                                        color: secondaryColor,
                                        height: 10.h,
                                      ),
                                    ),
                                    data: dob,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        profileController
                                            .dobTextEditingController
                                            .value
                                            .text = formattedDate;
                                      }
                                    },
                                    hintText: dateFormate,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Anniversary Date',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Obx(
                                  () => CustomTextField(
                                    controller: profileController
                                        .anniversaryDateController.value,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    readonly: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Image.asset(
                                        'assets/images/png/anniversary_logo.png',
                                        height: 10.h,
                                      ),
                                    ),
                                    data: "aniversary",
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        profileController
                                            .anniversaryDateController
                                            .value
                                            .text = formattedDate;
                                      }
                                    },
                                    hintText: dateFormate,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomButton(
                                    onPressed: () {
                                      profileController.selectedGender?.value =
                                          profileController
                                              .genderDateController.value.text
                                              .toString();
                                      // if (_formKey.currentState!.validate()) {
                                      if (profileController
                                              .isProfileUpdating.value !=
                                          true) {
                                        profileController.updateProfile(
                                            profileController
                                                .nameTextEditingController
                                                .value
                                                .value
                                                .text,
                                            profileController
                                                .emailTextEditingController
                                                .value
                                                .text,
                                            profileController
                                                .mobileTextEditingController
                                                .value
                                                .text,
                                            profileController
                                                .selectedDepartMentListData
                                                .value
                                                ?.id,
                                            userPageControlelr
                                                .selectedRoleListData.value?.id,
                                            profileController
                                                .selectedGender?.value,
                                            profileController
                                                .dobTextEditingController
                                                .value
                                                .text,
                                            profileController
                                                    .selectedAnniversary
                                                    ?.value ??
                                                "",
                                            profileController
                                                .anniversaryDateController
                                                .value
                                                .text,
                                            context);
                                      }
                                      // }
                                    },
                                    text: profileController
                                                .isProfileUpdating.value ==
                                            true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 30.h,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: whiteColor,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                loading,
                                                style: changeTextColor(
                                                    rubikBlack, whiteColor),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            updateProfile,
                                            style: changeTextColor(
                                                rubikBlack, whiteColor),
                                          ),
                                    color: primaryColor,
                                    height: 45.h,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
}
