import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/model/attendence_user_details.dart';
import 'package:task_management/model/leave_list_model.dart';
import 'package:task_management/model/leave_type_model.dart';
import 'package:task_management/service/attendence/attendence_service.dart';

class AttendenceController extends GetxController {
  var isPunchin = false.obs;
  var attendenceStatusList =
      ["Present", "Absent", "Half Day", "Leave", "Fine", "Overtime"].obs;
  var attendenceStatusValueList = ["14(+6)", "0", "0", "5", "0:00", "0:00"].obs;
  var isAttendencePunching = false.obs;
  Future<void> attendencePunching(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText,
      File imageValue) async {
    isAttendencePunching.value = true;
    final result = await AttendenceService().attendencePunching(
        imageValue, address, latitude, longitude, attendenceTime, searchText);
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

  var isAttendencePunchout = false.obs;
  Future<void> attendencePunchout(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText,
      File imageValue) async {
    isAttendencePunchout.value = true;
    final result = await AttendenceService().attendencePunchout(
        imageValue, address, latitude, longitude, attendenceTime, searchText);
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
          'iuyiuyiuyuycf77g87t8y87 uf7f6d65juy7 ${attendenceListModel.value?.data?.year}');
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
    isLeaveLoading.value = true;
    final result = await AttendenceService().leaveList();
    if (result != null) {
      leaveListData.assignAll(result.data!);
      isLeaveLoading.value = false;
    } else {}
    isLeaveLoading.value = false;
  }

  var isApplyingLeave = false.obs;
  Future<void> aplyingLeave(String startDate, String endDate, String duration,
      String leaveType, String description) async {
    isApplyingLeave.value = true;
    final result = await AttendenceService()
        .applyingLeave(startDate, endDate, duration, leaveType, description);
    isApplyingLeave.value = false;
    await leaveLoading();
    Get.back();
    isApplyingLeave.value = false;
  }

  var isLeaveEditing = false.obs;
  Future<void> leaveEditing(String startDate, String endDate, String duration,
      String leaveType, String description, String id) async {
    isLeaveEditing.value = true;
    final result = await AttendenceService()
        .leaveEditing(startDate, endDate, duration, leaveType, description, id);
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
}
