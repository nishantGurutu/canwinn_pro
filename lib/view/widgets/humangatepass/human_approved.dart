import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/component/location_service.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/attendence/widget/camera_view.dart';
import 'package:task_management/view/widgets/humangatepass/human_gatepass_details.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class HumanApproved extends StatefulWidget {
  const HumanApproved({super.key});

  @override
  State<HumanApproved> createState() => _HumanApprovedState();
}

class _HumanApprovedState extends State<HumanApproved> {
  @override
  initState() {
    super.initState();
    locationName();
  }

  RxBool isAddressLoading = false.obs;
  RxString locaitonAddress = ''.obs;
  RxString lName = "".obs;
  RxString lName2 = "".obs;
  var isLocationLoading = false.obs;
  Future<void> locationName() async {
    isLocationLoading.value = true;
    try {
      latitude = (LocationService.locationData.latitude ?? 0.0).toString();
      longitude = (LocationService.locationData.longitude ?? 0.0).toString();
      attendenceTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      geocoding.Placemark? place =
          await LocationHandler.getPositionOfUser(Get.context!);
      lName2.value =
          "${place?.name} ${place?.subLocality}, ${place?.street}, ${place?.locality}";
      locaitonAddress.value = lName2.value;
      await StorageHelper.setUserLocationName(locaitonAddress.value);
      debugPrint('locatiuon data in human attendance ${locaitonAddress.value}');
      isLocationLoading.value = false;
    } catch (e) {
      isLocationLoading.value = false;
      lName.value = "Location not available";
    }
    isLocationLoading.value = false;
  }

  String latitude = '';
  String longitude = '';
  String address = '';
  String attendenceTime = '';

  final AttendenceController attendenceController = Get.find();
  final EmployeeFormController employeeFormController = Get.find();

  String formatOutTime(String inputDateTime) {
    try {
      final DateTime parsedDate =
          DateFormat("yyyy-MM-dd HH:mm").parse(inputDateTime);
      return DateFormat("yyyy-MM-dd hh:mm a").format(parsedDate);
    } catch (e) {
      return inputDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => employeeFormController.humanGatePassListApprovedData.isEmpty
          ? Center(
              child: Text(
                "No pending data",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount:
                  employeeFormController.humanGatePassListApprovedData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => HumanGatepassDetails(
                          employeeFormController
                              .humanGatePassListApprovedData[index]['id']
                              .toString(),
                          from: "approve",
                        ));
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      '${employeeFormController.humanGatePassListApprovedData[index]['gatepass_id'] ?? ''}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${employeeFormController.humanGatePassListApprovedData[index]['name'] ?? ''}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${employeeFormController.humanGatePassListApprovedData[index]['creator_department_name'] ?? ""}',
                                      style: TextStyle(
                                          color: textColor, fontSize: 12.sp),
                                    ),
                                    SizedBox(height: 4.h),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Purpose of visit : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${employeeFormController.humanGatePassListApprovedData[index]['purpose_of_visit'] ?? ""}',
                                            style: TextStyle(
                                                color: Color(0xff676767),
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Expected Out Time : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${formatOutTime(employeeFormController.humanGatePassListApprovedData[index]['out_time'] ?? '')}',
                                            style: TextStyle(
                                                color: Color(0xff676767),
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Expected Return Time : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                '${formatOutTime(employeeFormController.humanGatePassListApprovedData[index]['return_time'] ?? "")}',
                                            style: TextStyle(
                                                color: Color(0xff676767),
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffE3FFE4),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.r),
                                    bottomRight: Radius.circular(12.r),
                                  ),
                                ),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            'Approved By : ',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Human Resource Manager ',
                                                style: TextStyle(
                                                    color: Color(0xff1B2A64),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Team Leader',
                                                style: TextStyle(
                                                    color: Color(0xff1B2A64),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${employeeFormController.humanGatePassListApprovedData[index]['hr_head_name'] ?? ''}',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '${employeeFormController.humanGatePassListApprovedData[index]['dept_head_name'] ?? ''}',
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Color(0xffFFC3C3),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Punch Out Time : ',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 12.sp),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${formatOutTime(employeeFormController.humanGatePassListApprovedData[index]['actual_out_time'] ?? '')}',
                                                  style: TextStyle(
                                                      color: Color(0xff676767),
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Punch In Time : ',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 12.sp),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${formatOutTime(employeeFormController.humanGatePassListApprovedData[index]['actual_in_time'] ?? '')}',
                                                  style: TextStyle(
                                                      color: Color(0xff676767),
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (StorageHelper.getDepartmentId() == 12 &&
                                        employeeFormController
                                                .humanGatePassListApprovedData[
                                                    index]['actual_out_time']
                                                .toString() ==
                                            "null" &&
                                        employeeFormController
                                                .humanGatePassListApprovedData[
                                                    index]['actual_in_time']
                                                .toString() ==
                                            "null")
                                      InkWell(
                                        onTap: () async {
                                          if (employeeFormController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            await employeeFormController
                                                .updateHumanGatePassStatus(
                                              id: employeeFormController
                                                      .humanGatePassListApprovedData[
                                                  index]['id'],
                                              remark: remarkControlelr.text,
                                              status: 3,
                                              from: " ",
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFF0005),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.r),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Center(
                                              child: Text(
                                                'Out By Security',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (StorageHelper.getDepartmentId() == 12 &&
                                        employeeFormController
                                                .humanGatePassListApprovedData[
                                                    index]['actual_out_time']
                                                .toString() !=
                                            "null" &&
                                        employeeFormController
                                                .humanGatePassListApprovedData[
                                                    index]['actual_in_time']
                                                .toString() ==
                                            "null")
                                      InkWell(
                                        onTap: () async {
                                          if (employeeFormController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            await employeeFormController
                                                .updateHumanGatePassStatus(
                                              id: employeeFormController
                                                      .humanGatePassListApprovedData[
                                                  index]['id'],
                                              remark: remarkControlelr.text,
                                              status: 4,
                                              from: "",
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Color(0xff00AD03),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.r),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Center(
                                              child: Text(
                                                'In By Security',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // if (employeeFormController
                      //             .humanGatePassListApprovedData[index]
                      //                 ['actual_out_time']
                      //             .toString() !=
                      //         "null" &&
                      //     employeeFormController
                      //             .humanGatePassListApprovedData[index]
                      //                 ['actual_in_time']
                      //             .toString() ==
                      //         "null")
                      //   if (employeeFormController
                      //           .humanGatePassListApprovedData[index]['user_id']
                      //           .toString() ==
                      //       StorageHelper.getId().toString())

                      if ((employeeFormController
                                      .humanGatePassListApprovedData[index]
                                          ['actual_out_time']
                                      .toString() !=
                                  "null" &&
                              employeeFormController
                                      .humanGatePassListApprovedData[index]
                                          ['actual_in_time']
                                      .toString() ==
                                  "null") ||
                          (employeeFormController
                                      .humanGatePassListApprovedData[index]
                                          ['actual_out_time']
                                      .toString() !=
                                  "null" &&
                              employeeFormController
                                      .humanGatePassListApprovedData[index]
                                          ['actual_in_time']
                                      .toString() !=
                                  "null"))
                        if (employeeFormController
                                .humanGatePassListApprovedData[index]['user_id']
                                .toString() ==
                            StorageHelper.getId().toString())
                          Positioned(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.h, right: 8.w),
                                child: Container(
                                  width: 30.w,
                                  child: Center(
                                    child: PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            onTap: () async {
                                              if (!attendenceController
                                                  .isAttendencePunching.value) {
                                                await availableCameras().then(
                                                  (value) => Get.to(
                                                    () => CameraView(
                                                      cameras: value,
                                                      type: "checkin",
                                                      latitude: latitude,
                                                      longitude: longitude,
                                                      attendenceTime:
                                                          attendenceTime,
                                                      address:
                                                          locaitonAddress.value,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/image/svg/frame_person.svg',
                                                  height: 20.h,
                                                ),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Center(
                                                  child:
                                                      (attendenceController
                                                                  .isAttendencePunching
                                                                  .value ||
                                                              attendenceController
                                                                  .isAttendencePunchout
                                                                  .value ||
                                                              attendenceController
                                                                      .isuserDetailsAttendenceListLoading
                                                                      .value ==
                                                                  true)
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircularProgressIndicator(
                                                                    color:
                                                                        whiteColor),
                                                                SizedBox(
                                                                    width: 8.w),
                                                                Text(
                                                                  'Loading...',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              attendenceController
                                                                          .attendenceUserDetails
                                                                          .value
                                                                          ?.data
                                                                          ?.punchin ==
                                                                      1
                                                                  ? "Punch Out"
                                                                  : "Punch In",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController remarkControlelr = TextEditingController();
  Future<void> showAlertDialog(BuildContext context,
      {required id, required int status}) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 230.h,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskCustomTextField(
                          controller: remarkControlelr,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'remark',
                          hintText: 'Enter Remark',
                          labelText: 'Enter Remark',
                          maxLine: 5,
                          index: 1,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (employeeFormController
                                        .isStatusUpdating.value ==
                                    false) {
                                  employeeFormController
                                      .updateHumanGatePassStatus(
                                    id: id,
                                    remark: remarkControlelr.text,
                                    status: status,
                                    from: "",
                                  );
                                }
                              },
                              child: Container(
                                height: 35.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff1E94FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    submit,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 35.h,
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF0004),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    cancel,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 2.w,
                child: SizedBox(
                  height: 20.h,
                  width: 35.w,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
