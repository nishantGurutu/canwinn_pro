import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/model/user_model.dart';
import 'package:task_management/model/user_profile_model.dart';
import 'package:task_management/service/user_service.dart';

class UserPageControlelr extends GetxController {
  var isUserRoleLoading = false.obs;
  var userListModel = UserListModel().obs;
  var isVisibility = true.obs;
  var isVisibility2 = true.obs;
  var userList = [].obs;
  Future<void> userListApi() async {
    isUserRoleLoading.value = true;
    final result = await UserClassService().userRoleListApi();
    if (result != null) {
      userList.clear();
      userList.assignAll(result['data']);
      userList.refresh();
    } else {}
    isUserRoleLoading.value = false;
  }

  var roleTextDateController = TextEditingController().obs;
  var roleListModel = RoleListModel().obs;
  Rx<RoleListData?> selectedRoleListData = Rx<RoleListData?>(null);
  RxList<RoleListData> roleList = <RoleListData>[].obs;
  var isRoleLoading = false.obs;
  Future<void> roleListApi(int? id) async {
    isRoleLoading.value = true;
    final result = await UserClassService().roleListApi(id);
    if (result != null) {
      selectedRoleListData.value = null;
      roleListModel.value = result;
      roleList.clear();
      roleList.assignAll(roleListModel.value.data!);
      isRoleLoading.value = false;
      isRoleLoading.refresh();
      roleList.refresh();
      for (var role in roleList) {
        if (StorageHelper.getRole().toString() == role.id.toString()) {
          selectedRoleListData.value = role;
          roleTextDateController.value.text = role.name ?? '';

          return;
        }
      }
    } else {}
    isRoleLoading.value = false;
  }

  var isProfilePicUploading = false.obs;

  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  Rx<File> pickedFile = File('').obs;

  var isuserAdding = false.obs;
  Future<void> addUser(
      String name,
      String email,
      int role,
      String mobile,
      String mobile2,
      String password,
      String conPassword,
      int? deptId,
      Placemark? place) async {
    isuserAdding.value = true;
    final result = await UserClassService().addUserApi(name, email, role,
        mobile, mobile2, password, conPassword, pickedFile, deptId, place);
    if (result) {
      Get.back();
      await userListApi();
    } else {}
    isuserAdding.value = false;
  }

  var isRoleAdding = false.obs;
  Future<void> addRole(
    String roleName,
    int? id,
    UserProfileModel? value,
  ) async {
    isRoleAdding.value = true;
    final result = await UserClassService().addRole(roleName, id);
    if (result) {
      Get.back();
      await roleListApi(
        id,
      );
    } else {}
    isRoleAdding.value = false;
  }

  var isUserEditing = false.obs;
  Future<void> editUser(String name, String email, int role, String mobile,
      String mobile2, String password, String conPassword, int? id) async {
    isUserEditing.value = true;
    final result = await UserClassService().editUserApi(
      name,
      email,
      role,
      mobile,
      mobile2,
      password,
      conPassword,
      pickedFile,
      id,
    );
    if (result) {
      Get.back();
      userListApi();
    } else {}
    isUserEditing.value = false;
  }

  var isUserDeleting = false.obs;
  Future<void> deleteUser(int? id) async {
    isUserDeleting.value = true;
    final result = await UserClassService().deleteUserApi(
      id,
    );
    if (result) {
      userListApi();
    } else {}
    isUserDeleting.value = false;
  }
}
