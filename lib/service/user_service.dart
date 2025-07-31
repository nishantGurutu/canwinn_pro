import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/role_list_model.dart';
import '../constant/custom_toast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class UserClassService {
  final Dio _dio = Dio();
  Future<dynamic> userRoleListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.userList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<RoleListModel?> roleListApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('dept in ro id $id');
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.roleList}?department_id=$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RoleListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addUserApi(
    String name,
    String email,
    int role,
    String mobile,
    String mobile2,
    String password,
    String conPassword,
    Rx<File> pickedFile,
    int? deptId,
    geocoding.Placemark? place,
  ) async {
    try {
      var token = StorageHelper.getToken();
      print('user location val $place');
      print('user location val 2 $deptId');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'name': name,
        'email': email,
        'role': role,
        'phone1': mobile,
        'phone2': mobile2,
        'password': password,
        'location': place?.name.toString(),
        'department_id': deptId,
        'password_confirmation': conPassword,
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['profile_picture'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addUser,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "Welcome to the team! The group is growing - Let's achieve our goals together!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addRole(String roleName, int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('rolde add api value $roleName');
      print('rolde add api value 2 ${id}');
      final Map<String, dynamic> formDataMap = {
        'name': roleName,
        "department_id": id,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addRole,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editUserApi(
      String name,
      String email,
      int role,
      String mobile,
      String mobile2,
      String password,
      String conPassword,
      Rx<File>? pickedFile,
      int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'name': name,
        'email': email,
        'role': role,
        'phone1': mobile,
        'phone2': mobile2,
        'password': password,
        'location': '123.99',
        'password_confirmation': conPassword,
        'id': id,
      };

      if (pickedFile != null && pickedFile.value.path.isNotEmpty) {
        formDataMap['profile_picture'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editUser,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to edit user');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUserApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('delete user id $id');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.deleteUser}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to edit user');
      }
    } catch (e) {
      return false;
    }
  }
}
