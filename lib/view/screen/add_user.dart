import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController nameTextEditingControlelr =
      TextEditingController();
  final TextEditingController emailTextEditingControlelr =
      TextEditingController();
  final TextEditingController roleTextEditingControlelr =
      TextEditingController();
  final TextEditingController voterIdTextEditingControlelr =
      TextEditingController();
  final TextEditingController mobileTextEditingControlelr =
      TextEditingController();
  final TextEditingController mobile2TextEditingControlelr =
      TextEditingController();
  final TextEditingController passwordTextEditingControlelr =
      TextEditingController();
  final TextEditingController conPasswordTextEditingControlelr =
      TextEditingController();
  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  final ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    LocationHandler.determinePosition(context);
    profileController.departmentList(0);
    userPageControlelr.selectedRoleListData.value = null;
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      userPageControlelr.isProfilePicUploading.value = true;
      userPageControlelr.pickedFile.value = File(pickedImage.path);
      userPageControlelr.profilePicPath.value = pickedImage.path.toString();
      userPageControlelr.isProfilePicUploading.value = false;
    } catch (e) {
      userPageControlelr.isProfilePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      userPageControlelr.isProfilePicUploading.value = false;
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
          addUser,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => profileController.isdepartmentListLoading.value == true
            ? SizedBox(
                height: 700.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              )
            : Container(
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          InkWell(
                            onTap: () {
                              takePhoto(ImageSource.camera);
                            },
                            child: Stack(
                              children: [
                                Obx(
                                  () => userPageControlelr
                                              .profilePicPath.value ==
                                          ""
                                      ? Container(
                                          height: 90.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(45.r),
                                              ),
                                              border: Border.all(
                                                  color: borderColor)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(45.r)),
                                            child: Image.asset(
                                                'assets/images/png/profile-image-removebg-preview.png'),
                                          ),
                                        )
                                      : userPageControlelr
                                                      .profilePicPath.value ==
                                                  "" ||
                                              !userPageControlelr
                                                  .profilePicPath.value
                                                  .contains('.jpg')
                                          ? Container(
                                              height: 90.h,
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              45.r))),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(45.r)),
                                                // child: Image.network(
                                                //   widget.image.toString(),
                                                //   fit: BoxFit.cover,
                                                //   errorBuilder: (context, error,
                                                //       stackTrace) {
                                                //     return Container(
                                                //       decoration: BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius.all(
                                                //           Radius.circular(20.r),
                                                //         ),
                                                //       ),
                                                //       child: Image.asset(
                                                //           backgroundLogo),
                                                //     );
                                                //   },
                                                // ),
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(45.r)),
                                                child: Image.file(
                                                  File(
                                                    userPageControlelr
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
                          SizedBox(
                            height: 15.h,
                          ),
                          CustomTextField(
                            hintText: name,
                            keyboardType: TextInputType.emailAddress,
                            controller: nameTextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(height: 15.h),
                          CustomTextField(
                            hintText: email,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailTextEditingControlelr,
                            textCapitalization: TextCapitalization.none,
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            onTap: () {
                              addDepartmentWidget();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Add Department',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: blueColor),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r))),
                                  child: Icon(
                                    Icons.add,
                                    color: whiteColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomDropdown<DepartmentListData>(
                            items: profileController.departmentDataList,
                            itemLabel: (item) => item.name ?? '',
                            onChanged: (value) {
                              profileController
                                  .selectedDepartMentListData.value = value!;
                              userPageControlelr.roleListApi(
                                profileController
                                    .selectedDepartMentListData.value?.id,
                              );
                            },
                            hintText: selectDepartment,
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            onTap: () {
                              addRoleWidget();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Add Role',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: blueColor),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  height: 20.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r))),
                                  child: Icon(
                                    Icons.add,
                                    color: whiteColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton2<RoleListData>(
                                isExpanded: true,
                                hint: Text(
                                  "Select Role",
                                  style: changeTextColor(
                                      rubikRegular, darkGreyColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: userPageControlelr.roleList
                                    .map(
                                      (RoleListData item) =>
                                          DropdownMenuItem<RoleListData>(
                                        value: item,
                                        child: Text(
                                          item.name ?? '',
                                          style: changeTextColor(
                                              rubikRegular, Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: userPageControlelr
                                    .selectedRoleListData.value,
                                onChanged: (RoleListData? value) {
                                  userPageControlelr
                                      .selectedRoleListData.value = value;

                                  print(
                                      'user details name data ${userPageControlelr.selectedRoleListData.value?.id}');
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 45.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border:
                                        Border.all(color: lightSecondaryColor),
                                    color: lightSecondaryColor,
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: secondaryColor,
                                    height: 8.h,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: lightGreyColor,
                                  iconDisabledColor: lightGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200.h,
                                  width: 312.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: lightSecondaryColor,
                                      border: Border.all(
                                          color: lightSecondaryColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          CustomTextField(
                            hintText: phone,
                            keyboardType: TextInputType.number,
                            controller: mobileTextEditingControlelr,
                            textCapitalization: TextCapitalization.none,
                            maxLength: 10,
                          ),
                          SizedBox(height: 15.h),
                          CustomTextField(
                            hintText: phone2,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            controller: mobile2TextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(height: 15.h),
                          Obx(
                            () => CustomTextField(
                              controller: passwordTextEditingControlelr,
                              textCapitalization: TextCapitalization.sentences,
                              hintText: enterYourPassword,
                              data: password,
                              obscureText:
                                  userPageControlelr.isVisibility.value,
                              suffixIcon: InkWell(
                                onTap: () {
                                  userPageControlelr.isVisibility.value =
                                      !userPageControlelr.isVisibility.value;
                                },
                                child: Icon(
                                  userPageControlelr.isVisibility.value == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: iconColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Obx(
                            () => CustomTextField(
                              controller: conPasswordTextEditingControlelr,
                              textCapitalization: TextCapitalization.sentences,
                              hintText: enterConfirmPasswordText,
                              data: password,
                              obscureText:
                                  userPageControlelr.isVisibility2.value,
                              suffixIcon: InkWell(
                                onTap: () {
                                  userPageControlelr.isVisibility2.value =
                                      !userPageControlelr.isVisibility2.value;
                                },
                                child: Icon(
                                  userPageControlelr.isVisibility2.value == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: iconColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Obx(
                            () => CustomButton(
                              onPressed: () {
                                if (userPageControlelr.isuserAdding.value ==
                                    false) {
                                  if (_formKey.currentState!.validate()) {
                                    userPageControlelr.addUser(
                                      nameTextEditingControlelr.text,
                                      emailTextEditingControlelr.text,
                                      userPageControlelr
                                              .selectedRoleListData.value?.id ??
                                          0,
                                      mobileTextEditingControlelr.text,
                                      mobile2TextEditingControlelr.text,
                                      passwordTextEditingControlelr.text,
                                      conPasswordTextEditingControlelr.text,
                                      profileController
                                          .selectedDepartMentListData.value?.id,
                                      LocationHandler.place,
                                    );
                                  }
                                }
                              },
                              text:
                                  userPageControlelr.isuserAdding.value == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          add,
                                          style: changeTextColor(
                                              rubikBlack, whiteColor),
                                        ),
                              width: double.infinity,
                              color: primaryColor,
                              height: 45.h,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController departmentNameController =
      TextEditingController();
  Future<void> addDepartmentWidget() {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: whiteColor),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Department',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    TaskCustomTextField(
                      controller: departmentNameController,
                      focusedIndexNotifier: focusedIndexNotifier,
                      index: 0,
                      textCapitalization: TextCapitalization.sentences,
                      data: 'Department Name',
                      labelText: 'Enter Department Name',
                      hintText: 'Enter Department Name',
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 170.w,
                            height: 45.h,
                            child: CustomButton(
                              onPressed: () {
                                if (profileController
                                        .isDepartmentAdding.value ==
                                    false) {
                                  if (_formKey2.currentState!.validate()) {
                                    profileController.addDepartment(
                                        departmentNameController.text);
                                  }
                                }
                              },
                              text:
                                  userPageControlelr.isuserAdding.value == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          add,
                                          style: changeTextColor(
                                              rubikBlack, whiteColor),
                                        ),
                              width: double.infinity,
                              color: primaryColor,
                              height: 45.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final TextEditingController roleNameController = TextEditingController();
  Future<void> addRoleWidget() {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: whiteColor),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Form(
                key: _formKey3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Role',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    CustomDropdown<DepartmentListData>(
                      items: profileController.departmentDataList,
                      itemLabel: (item) => item.name ?? '',
                      onChanged: (value) {
                        profileController.selectedDepartMentListData.value =
                            value!;
                        print(
                            'selected department id value ${profileController.selectedDepartMentListData.value?.id}');
                      },
                      hintText: selectDepartment,
                    ),
                    SizedBox(height: 15.h),
                    TaskCustomTextField(
                      controller: roleNameController,
                      focusedIndexNotifier: focusedIndexNotifier,
                      index: 0,
                      textCapitalization: TextCapitalization.sentences,
                      data: 'Role Name',
                      labelText: 'Enter Role Name',
                      hintText: 'Enter Role Name',
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 170.w,
                            height: 45.h,
                            child: CustomButton(
                              onPressed: () {
                                if (profileController
                                        .selectedDepartMentListData.value !=
                                    null) {
                                  if (profileController
                                          .isDepartmentAdding.value ==
                                      false) {
                                    if (_formKey3.currentState!.validate()) {
                                      userPageControlelr.addRole(
                                          roleNameController.text,
                                          profileController
                                              .selectedDepartMentListData
                                              .value
                                              ?.id,
                                          profileController
                                              .userProfileModel.value);
                                    }
                                  }
                                } else {
                                  CustomToast().showCustomToast(
                                      'Please select department.');
                                }
                              },
                              text:
                                  userPageControlelr.isuserAdding.value == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          add,
                                          style: changeTextColor(
                                              rubikBlack, whiteColor),
                                        ),
                              width: double.infinity,
                              color: primaryColor,
                              height: 45.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
