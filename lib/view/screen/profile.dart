import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
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

  final Color whiteColor = Colors.white;
  final Color darkGreyColor = Colors.grey.shade800;
  final Color lightGreyColor = Colors.grey.shade400;
  final Color borderColor = Colors.grey.shade300;
  final Color lightBorderColor = Colors.grey.shade300;
  final Color textColor = Colors.grey.shade600;

  @override
  void initState() {
    apiCall();
    profileController.selectedGender?.value = "";
    super.initState();
  }

  Future<void> apiCall() async {
    await profileController.userDetails();
    await profileController.departmentList(0);
    await profileController.assignAssetsList();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: source,
        imageQuality: 30,
      );
      if (pickedImage == null) return;

      profileController.isProfilePicUploading.value = true;
      profileController.dataFromImagePicker.value = true;
      profileController.pickedFile.value = File(pickedImage.path);
      profileController.profilePicPath.value = pickedImage.path.toString();
    } catch (e) {
      // Handle error if any
    } finally {
      profileController.isProfilePicUploading.value = false;
      Get.back();
    }
  }

  @override
  void dispose() {
    profileController.selectedGender?.value = '';
    profileController.dataFromImagePicker.value = false;
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkImageScreen(file: file)),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFScreen(file: File(file))),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unsupported file type.')));
    }
  }

  Future<void> showAlertDialog(BuildContext context) async {
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.gallery);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/gallery-icon-removebg-preview.png',
                                height: 20.h,
                                color: whiteColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ),
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
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera, color: whiteColor),
                              SizedBox(width: 8.w),
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ),
                            ],
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
          () =>
              profileController.isUserDetailsLoading.value
                  ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                  : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () => Get.back(),
                                  icon: SvgPicture.asset(
                                    'assets/images/svg/back_arrow.svg',
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            InkWell(
                              onTap: () {
                                showAlertDialog(context);
                              },
                              child: Stack(
                                children: [
                                  Obx(
                                    () =>
                                        profileController
                                                .profilePicPath
                                                .value
                                                .isEmpty
                                            ? Container(
                                              height: 90.h,
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(45.r),
                                                border: Border.all(
                                                  color: borderColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(45.r),
                                                child: Image.asset(
                                                  'assets/images/png/profile-image-removebg-preview.png',
                                                  fit: BoxFit.cover,
                                                ),
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
                                                      .value,
                                                );
                                              },
                                              child: Container(
                                                height: 90.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        45.r,
                                                      ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        45.r,
                                                      ),
                                                  child: Image.network(
                                                    profileController
                                                        .profilePicPath
                                                        .value,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20.r,
                                                              ),
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/png/profile-image-removebg-preview.png',
                                                        ),
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
                                                    BorderRadius.circular(45.r),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(45.r),
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
                                    right: 5.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: whiteColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => UserAssetsList(
                                    profileController.allocatedAssetsList,
                                    profileController,
                                  ),
                                );
                              },
                              child: Container(
                                width: 120.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Text(
                                    'Your Assets',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                            _buildLabelAndField(
                              'Name',
                              profileController.nameTextEditingController.value,
                              'name',
                            ),
                            SizedBox(height: 15.h),
                            _buildLabelAndField(
                              'Email',
                              profileController
                                  .emailTextEditingController
                                  .value,
                              'email',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 15.h),
                            _buildLabelAndField(
                              'Mobile',
                              profileController
                                  .mobileTextEditingController
                                  .value,
                              'Phone',
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 15.h),
                            _buildLabelAndField(
                              'Department',
                              profileController
                                  .departmentTextEditingController
                                  .value,
                              'Department',
                              enable: false,
                            ),
                            SizedBox(height: 15.h),
                            _buildLabelAndField(
                              'Role',
                              userPageControlelr.roleTextDateController.value,
                              'Role',
                              enable: false,
                            ),
                            SizedBox(height: 15.h),
                            _buildGenderDropdown(),
                            SizedBox(height: 15.h),
                            _buildDatePickerField(
                              'DOB',
                              profileController.dobTextEditingController.value,
                              'dd-MM-yyyy',
                              prefixIconPath: 'assets/images/png/callender.png',
                            ),
                            SizedBox(height: 15.h),
                            _buildDatePickerField(
                              'Anniversary Date',
                              profileController.anniversaryDateController.value,
                              'dd-MM-yyyy',
                              prefixIconPath:
                                  'assets/images/png/anniversary_logo.png',
                            ),
                            SizedBox(height: 25.h),
                            Obx(
                              () => CustomButton(
                                onPressed: () {
                                  if (profileController.isProfileUpdating.value)
                                    return;
                                  profileController.updateProfile(
                                    profileController
                                        .nameTextEditingController
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
                                        .departmentIdTextEditingController
                                        .value
                                        .text,
                                    userPageControlelr
                                        .selectedRoleListData
                                        .value
                                        ?.id,
                                    profileController.selectedGender?.value,
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
                                    context,
                                  );
                                },
                                text:
                                    profileController.isProfileUpdating.value
                                        ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 24.h,
                                              width: 24.h,
                                              child: CircularProgressIndicator(
                                                color: whiteColor,
                                                strokeWidth: 2.5,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'Loading...',
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        )
                                        : Text(
                                          'Update Profile',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                color: primaryColor,
                                height: 48.h,
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildLabelAndField(
    String label,
    TextEditingController controller,
    String hint, {
    bool enable = true,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade400),
            color: enable ? Colors.white : Colors.grey.shade200,
          ),
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            maxLength: maxLength,
            keyboardType: keyboardType,
            enabled: enable,
            style: TextStyle(color: Colors.black87, fontSize: 15.sp),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: 12.w,
              ),
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 6.h),
        Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              items:
                  profileController.genderList.map((String? item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              value:
                  profileController.selectedGender!.value.isEmpty
                      ? null
                      : profileController.selectedGender?.value,
              onChanged: (String? value) {
                profileController.selectedGender?.value = value ?? '';
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
              ),
              hint: Text(
                'Select Gender',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
              ),
              iconStyleData: IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Icon(Icons.keyboard_arrow_down, color: secondaryColor),
                ),
                iconSize: 24,
                iconEnabledColor: secondaryColor,
                iconDisabledColor: Colors.grey.shade400,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200.h,
                width: 330.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: whiteColor,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(20),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
    String label,
    TextEditingController controller,
    String hintText, {
    String? prefixIconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: Colors.black87, fontSize: 15.sp),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 12.w,
            ),
            prefixIcon:
                prefixIconPath != null
                    ? Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        prefixIconPath,
                        height: 18.h,
                        color: secondaryColor, // primaryColor
                      ),
                    )
                    : null,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: secondaryColor, width: 2),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat(
                'dd-MM-yyyy',
              ).format(pickedDate);
              controller.text = formattedDate;
            }
          },
        ),
      ],
    );
  }
}
