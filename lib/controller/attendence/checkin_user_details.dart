import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/component/location_service.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/helper/storage_helper.dart';

class CheckinUserDetails extends StatefulWidget {
  const CheckinUserDetails({super.key});

  @override
  State<CheckinUserDetails> createState() => _CheckinUserDetailsState();
}

class _CheckinUserDetailsState extends State<CheckinUserDetails> {
  final AttendenceController attendenceController =
      Get.put(AttendenceController());
  final TextEditingController addressTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // void fetchAddress() async {
  //   String? address = await LocationService.getCurrentAddress();
  //   addressTextEditingController.text = address ?? "Could not fetch address";
  // }

  final RegisterController registerController = Get.put(RegisterController());

  Future<void> logoutApp() async {
    registerController.userLogout();
  }

  String latitude = '';
  String longitude = '';
  String address = '';
  String attendenceTime = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          checkin,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (StorageHelper.getType() == 3)
            InkWell(
              onTap: () {
                logoutApp();
              },
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(Icons.logout),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: whiteColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: attendenceController.searchTextEditingController,
                decoration: InputDecoration(
                  hintText: searchUser,
                  counterText: "",
                  fillColor: lightSecondaryColor,
                  filled: true,
                  hintStyle: changeTextColor(rubikRegular, darkGreyColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: lightSecondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightSecondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightSecondaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      attendenceController.attendenceUserDetailsApi(
                          attendenceController
                              .searchTextEditingController.text);
                    },
                    child: Container(
                      height: 40.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: buttonRedColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Check User',
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                if (attendenceController
                    .isuserDetailsAttendenceListLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (attendenceController
                        .attendenceUserDetails.value?.data?.id !=
                    null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: attendenceController.attendenceUserDetails
                                          .value?.data?.image !=
                                      null &&
                                  attendenceController.attendenceUserDetails
                                      .value!.data!.image!.isNotEmpty
                              ? Image.network(
                                  attendenceController.attendenceUserDetails
                                      .value!.data!.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.r),
                                        ),
                                      ),
                                      child: Image.asset(backgroundLogo),
                                    );
                                  },
                                )
                              : Icon(Icons.person,
                                  size: 50, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Name :- ${attendenceController.attendenceUserDetails.value?.data?.name}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Email :- ${attendenceController.attendenceUserDetails.value?.data?.email}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Gender :- ${attendenceController.attendenceUserDetails.value?.data?.gender}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Dob :- ${attendenceController.attendenceUserDetails.value?.data?.dob}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "No User Found!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  );
                }
              }),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    topLeft: Radius.circular(20.r),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: Obx(
                    () {
                      return InkWell(
                        onTap: () {
                          if (attendenceController
                                  .attendenceUserDetails.value?.data?.punchin
                                  .toString() ==
                              "1") {
                            if (attendenceController
                                    .attendenceUserDetails.value?.data?.id !=
                                null) {
                              latitude =
                                  (LocationService.locationData.latitude ?? 0.0)
                                      .toString();
                              longitude =
                                  (LocationService.locationData.longitude ??
                                          0.0)
                                      .toString();
                              attendenceTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now());
                              takePhoto(
                                  ImageSource.camera,
                                  attendenceController.attendenceUserDetails
                                      .value?.data?.punchin,
                                  attendenceController
                                      .searchTextEditingController.text);
                            } else {
                              CustomToast()
                                  .showCustomToast("Please check user");
                            }
                          } else {
                            CustomToast().showCustomToast(
                                "You have already punched out.");
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: attendenceController.attendenceUserDetails
                                        .value?.data?.punchin
                                        .toString() ==
                                    "1"
                                ? Color(0xFFFFCDD2)
                                : Color.fromARGB(255, 244, 54, 54),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                          ),
                          child: Center(
                            child: (attendenceController
                                        .isAttendencePunching.value ||
                                    attendenceController
                                        .isAttendencePunchout.value)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                          color: whiteColor),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "${attendenceController.attendenceUserDetails.value?.data?.punchin.toString() == "0" || attendenceController.attendenceUserDetails.value?.data?.punchin == null ? "Punch In" : "Punch Out"}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final ImagePicker imagePicker = ImagePicker();
  final TaskController taskController = Get.find();
  Future<void> takePhoto(
      ImageSource source, int? type, String searchText) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);

      if (pickedImage == null) return;

      taskController.isProfilePicUploading.value = true;
      taskController.pickedFile.value = File(pickedImage.path);
      taskController.profilePicPath.value = pickedImage.path.toString();

      addressTextEditingController.text = address ?? "Could not fetch address";
      if (type.toString() == "0" || type.toString() == "null") {
        await attendenceController.attendencePunching(
            taskController.pickedFile.value,
            addressTextEditingController.text,
            latitude,
            longitude,
            attendenceTime,
            searchText,
            File(''));
      } else {
        await attendenceController.attendencePunchout(
            taskController.pickedFile.value,
            addressTextEditingController.text,
            latitude,
            longitude,
            attendenceTime,
            searchText,
            File(''));
      }
    } catch (e) {
      print("Error capturing image: $e");
    } finally {
      taskController.isProfilePicUploading.value = false;
    }
  }
}
