import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/model/attendence_user_details.dart';
import 'package:task_management/model/leave_list_model.dart';
import 'package:task_management/model/leave_type_model.dart';
import 'package:task_management/service/attendence/attendence_service.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class AttendenceController extends GetxController {
  var isPunchin = false.obs;
  var attendenceStatusList =
      ["Present", "Absent", "Half Day", "Leave", "Fine", "Overtime"].obs;
  var attendenceStatusValueList = ["14(+6)", "0", "0", "5", "0:00", "0:00"].obs;
  var isAttendencePunching = false.obs;
  Future<void> attendencePunching(
    File pickedFile,
    String address,
    String latitude1,
    String longitude1,
    String attendenceTime,
    String searchText,
    File imageValue,
  ) async {
    isAttendencePunching.value = true;
    final result = await AttendenceService().attendencePunching(
      imageValue,
      address,
      latitude.value,
      longitude.value,
      attendenceTime,
      searchText,
    );
    if (result != null) {
      isPunchin.value = true;
      isAttendencePunching.value = false;
      if (StorageHelper.getType() != 3) {
        await attendenceUserDetailsApi(StorageHelper.getId().toString());
        DateTime dateTime = DateTime.now();
        String formattedDate =
            "checkin ${DateFormat('yyyy-MM-dd').format(dateTime)}";
        StorageHelper.setIsPunchinDate(formattedDate);
        StorageHelper.setIsPunchin('punchin');
      } else {
        searchTextEditingController.clear();
        attendenceUserDetails.value = null;
      }
    } else {}
    isAttendencePunching.value = false;
  }

  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString? locationString = ''.obs;
  RxBool isCheckingLoading = false.obs;
  RxString attendenceTime = ''.obs;
  Future<void> getUserLocation(BuildContext context) async {
    isCheckingLoading.value = true;
    try {
      await LocationHandler.determinePosition(context);
      List<geocoding.Placemark> placeMarks = await geocoding
          .placemarkFromCoordinates(
            LocationHandler.position!.latitude,
            LocationHandler.position!.longitude,
          );
      var latLon =
          'Lat: ${LocationHandler.position?.latitude}, Lng: ${LocationHandler.position?.longitude}';
      latitude.value = "${LocationHandler.position?.latitude}";
      longitude.value = "${LocationHandler.position?.longitude}";
      locationString?.value =
          placeMarks.isNotEmpty
              ? [
                placeMarks.first.name,
                placeMarks.first.subThoroughfare,
                placeMarks.first.thoroughfare,
                placeMarks.first.street,
                placeMarks.first.subLocality,
                placeMarks.first.locality,
                placeMarks.first.subAdministrativeArea,
                placeMarks.first.administrativeArea,
                placeMarks.first.postalCode,
                placeMarks.first.country,
              ].where((e) => e != null && e.isNotEmpty).toSet().join(", ")
              : "";
      isCheckingLoading.value = false;
      print("User position: $placeMarks");
      print("User position: $latitude");
      print("User position: $longitude");
    } catch (e) {
      isCheckingLoading.value = false;
      print("Error getting location: $e");
      locationString?.value = "Failed to get location.";
    }
    isCheckingLoading.value = false;
  }

  var isAttendencePunchout = false.obs;
  Future<void> attendencePunchout(
    File pickedFile,
    String address,
    String latitude1,
    String longitude1,
    String attendenceTime,
    String searchText,
    File imageValue,
  ) async {
    isAttendencePunchout.value = true;
    final result = await AttendenceService().attendencePunchout(
      imageValue,
      locationString?.value ?? "",
      latitude.value,
      longitude.value,
      attendenceTime,
      searchText,
    );
    if (result != null) {
      isPunchin.value = false;
      isAttendencePunchout.value = false;
      if (StorageHelper.getType() != 3) {
        await attendenceUserDetailsApi(StorageHelper.getId().toString());
        DateTime dateTime = DateTime.now();
        String formattedDate =
            "checkout ${DateFormat('yyyy-MM-dd').format(dateTime)}";
        StorageHelper.setIsPunchinDate(formattedDate);
        StorageHelper.setIsPunchin('punchout');
      }
    } else {}
    isAttendencePunchout.value = false;
  }

  var attendenceListModel = Rxn<AttendenceListModel>();
  var isAttendenceListLoading = false.obs;
  Future<void> attendenceList({required int month, required int year}) async {
    isAttendenceListLoading.value = true;
    final result = await AttendenceService().attendenceList(month, year);
    if (result != null) {
      attendenceListModel.value = result;
      attendenceListModel.refresh();
      isAttendenceListLoading.value = false;
      print(
        'iuyiuyiuyuycf77g87t8y87 uf7f6d65juy7 ${attendenceListModel.value?.data?.year}',
      );
    } else {}
    isAttendenceListLoading.value = false;
  }

  final TextEditingController searchTextEditingController =
      TextEditingController();
  var attendenceUserDetails = Rxn<AttendenceUserDetails>();

  var isuserDetailsAttendenceListLoading = false.obs;
  Future<void> attendenceUserDetailsApi(String value) async {
    isuserDetailsAttendenceListLoading.value = true;
    final result = await AttendenceService().attendenceUserDetailsApi(value);
    if (result != null) {
      isuserDetailsAttendenceListLoading.value = false;
      attendenceUserDetails.value = result;
    } else {}
    isuserDetailsAttendenceListLoading.value = false;
  }

  var isLeaveTypeLoading = false.obs;
  RxList<LeaveTypeData> leaveTypeList = <LeaveTypeData>[].obs;
  var selectedLeaveType = Rxn<LeaveTypeData>();
  Future<void> leaveTypeLoading() async {
    isLeaveTypeLoading.value = true;
    final result = await AttendenceService().leaveTypeList();
    if (result != null) {
      leaveTypeList.assignAll(result.data!);
      isLeaveTypeLoading.value = false;
    } else {}
    isLeaveTypeLoading.value = false;
  }

  var isLeaveLoading = false.obs;
  RxList<LeaveListData> leaveListData = <LeaveListData>[].obs;
  
  Future<void> leaveLoading() async {
    try {
      isLeaveLoading.value = true;
      final result = await AttendenceService().leaveList();
      if (result != null && result.data != null) {
        leaveListData.assignAll(result.data!);
      } else {
        leaveListData.clear();  
      }
    } catch (e) {
      leaveListData.clear();  
    } finally {
      isLeaveLoading.value = false; 
    }
  }

  var isApplyingLeave = false.obs;
  Future<void> aplyingLeave(
    String startDate,
    String endDate,
    String duration,
    String leaveType,
    String description,
  ) async {
    isApplyingLeave.value = true;
    final result = await AttendenceService().applyingLeave(
      startDate,
      endDate,
      duration,
      leaveType,
      description,
    );
    isApplyingLeave.value = false;
    await leaveLoading();
    Get.back();
    isApplyingLeave.value = false;
  }

  var isLeaveEditing = false.obs;
  Future<void> leaveEditing(
    String startDate,
    String endDate,
    String duration,
    String leaveType,
    String description,
    String id,
  ) async {
    isLeaveEditing.value = true;
    final result = await AttendenceService().leaveEditing(
      startDate,
      endDate,
      duration,
      leaveType,
      description,
      id,
    );
    isLeaveEditing.value = false;
    await leaveLoading();
    Get.back();
    isLeaveEditing.value = false;
  }

  var isApplyingLeaveDeleting = false.obs;
  Future<void> leaveDeleting(int? id) async {
    isApplyingLeaveDeleting.value = true;
    final result = await AttendenceService().deleteLeave(id);
    isApplyingLeaveDeleting.value = false;
    await leaveLoading();
    isApplyingLeaveDeleting.value = false;
  }
  
  var isSallarySlipLoading = false.obs;
  Future<void> sallarySlipDownload(String text) async {
    try {
      isSallarySlipLoading.value = true;
      
      print('Starting salary slip download for: $text');
      final Uint8List? pdfData = await AttendenceService().sallarySlipDownload(text);
      
      if (pdfData != null && pdfData.isNotEmpty) {
        final now = DateTime.now();
        final formattedDate = '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.hour}${now.minute}${now.second}';
        final fileName = 'salary_slip_${formattedDate}.pdf';
        
        try {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            final downloadsPath = '${externalDir.path}/Downloads';
            final downloadsDir = Directory(downloadsPath);
            if (!await downloadsDir.exists()) {
              await downloadsDir.create(recursive: true);
            }
            final deviceFilePath = '$downloadsPath/$fileName';
            final deviceFile = File(deviceFilePath);
            await deviceFile.writeAsBytes(pdfData);
            print('File saved to device Downloads: $deviceFilePath');
          }
        } catch (e) {
          print('Error saving to device Downloads: $e');
        }
        
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final appFilePath = '${appDir.path}/$fileName';
          final appFile = File(appFilePath);
          await appFile.writeAsBytes(pdfData);
          print('File saved to app folder: $appFilePath');
        } catch (e) {
          print('Error saving to app folder: $e');
        }
        
        CustomToast().showCustomToast("Salary slip downloaded successfully to both Downloads and app folder.");
        Get.back();
      } else {
        print('No PDF data received or data is empty');
        CustomToast().showCustomToast("No salary slip data received from server.");
      }
    } catch (e) {
      print('Error in salary slip download: $e');
      CustomToast().showCustomToast("Error downloading salary slip: $e");
    } finally {
      isSallarySlipLoading.value = false;
    }
  }
 
}
