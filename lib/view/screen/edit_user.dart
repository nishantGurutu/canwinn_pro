import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/model/user_model.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';

class EditUser extends StatefulWidget {
  final UserListData userList;
  const EditUser(this.userList, {super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
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
    profileController.departmentList(0);
    nameTextEditingControlelr.text = widget.userList.name ?? '';
    emailTextEditingControlelr.text = widget.userList.email ?? '';
    roleTextEditingControlelr.text = "${widget.userList.role}";
    mobileTextEditingControlelr.text = widget.userList.phone ?? '';
    mobile2TextEditingControlelr.text = widget.userList.phone2 ?? '';
    passwordTextEditingControlelr.text = widget.userList.recoveryPassword ?? '';
    conPasswordTextEditingControlelr.text =
        widget.userList.recoveryPassword ?? '';
    print('profile image kjdfhkjh ${widget.userList.image}');
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
          editUser,
          style: changeTextColor(robotoBlack, whiteColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => profileController.isdepartmentListLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                                () => userPageControlelr.profilePicPath.value ==
                                        ""
                                    ? Container(
                                        height: 90.h,
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(45.r),
                                            ),
                                            border:
                                                Border.all(color: borderColor)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(45.r)),
                                          child: Image.asset(
                                              'assets/images/png/profile-image-removebg-preview.png'),
                                        ),
                                      )
                                    : userPageControlelr.profilePicPath.value ==
                                                "" &&
                                            !widget.userList.image
                                                .toString()
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
                                              child: Image.network(
                                                "${widget.userList.image}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.r),
                                                      ),
                                                    ),
                                                    child: Image.asset(
                                                        backgroundLogo),
                                                  );
                                                },
                                              ),
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
                          height: 10.h,
                        ),
                        CustomTextField(
                          hintText: name,
                          keyboardType: TextInputType.emailAddress,
                          controller: nameTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hintText: email,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        DepartmentList(),
                        SizedBox(height: 10.h),
                        CustomDropdown<RoleListData>(
                          items: userPageControlelr.roleList,
                          itemLabel: (item) => item.name ?? '',
                          onChanged: (value) {
                            userPageControlelr.selectedRoleListData.value =
                                value;
                          },
                          hintText: selectRole,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hintText: phone,
                          keyboardType: TextInputType.number,
                          controller: mobileTextEditingControlelr,
                          textCapitalization: TextCapitalization.none,
                          maxLength: 10,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hintText: phone2,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: mobile2TextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Obx(
                          () => CustomTextField(
                            controller: passwordTextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                            hintText: enterYourPassword,
                            data: password,
                            obscureText: userPageControlelr.isVisibility.value,
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
                        SizedBox(height: 10.h),
                        Obx(
                          () => CustomTextField(
                            controller: conPasswordTextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                            hintText: enterConfirmPasswordText,
                            data: password,
                            obscureText: userPageControlelr.isVisibility2.value,
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
                              if (userPageControlelr.isUserEditing.value ==
                                  false) {
                                if (_formKey.currentState!.validate()) {
                                  userPageControlelr.editUser(
                                    nameTextEditingControlelr.text,
                                    emailTextEditingControlelr.text,
                                    userPageControlelr
                                            .selectedRoleListData.value?.id ??
                                        0,
                                    mobileTextEditingControlelr.text,
                                    mobile2TextEditingControlelr.text,
                                    passwordTextEditingControlelr.text,
                                    conPasswordTextEditingControlelr.text,
                                    widget.userList.id,
                                  );
                                }
                              }
                            },
                            text: userPageControlelr.isUserEditing.value == true
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
                                        style: changeTextColor(
                                            rubikBlack, whiteColor),
                                      ),
                                    ],
                                  )
                                : Text(
                                    edit,
                                    style:
                                        changeTextColor(rubikBlack, whiteColor),
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
    );
  }
}
