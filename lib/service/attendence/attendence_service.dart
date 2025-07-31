import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/model/attendence_user_details.dart';
import 'package:task_management/model/leave_list_model.dart';
import 'package:task_management/model/leave_type_model.dart';

class AttendenceService {
  final Dio _dio = Dio();
  Future<bool?> attendencePunching(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    try {
      var token = StorageHelper.getToken();
      var addressData = StorageHelper.getUserLocationName();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('attendence data 1 $pickedFile');
      print('attendence data 2 $addressData');
      print('attendence data 3 $latitude');
      print('attendence data 4 $longitude');
      print('attendence data 5 $attendenceTime');
      final Map<String, dynamic> formDataMap = {
        'check_in': attendenceTime.toString(),
        'check_in_latitude': latitude.toString(),
        'check_in_longitude': longitude.toString(),
        'check_in_address': addressData.toString(),
      };
      if (pickedFile.path.isNotEmpty) {
        formDataMap['check_in_image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.path.split('/').last,
        );
      }
      if (StorageHelper.getType() == 3) {
        formDataMap['user_id'] = searchText.toString();
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_user_checkin,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<bool?> attendencePunchout(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    try {
      var token = StorageHelper.getToken();
      var addressData = StorageHelper.getUserLocationName();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      print('attendence data 1 $pickedFile');
      print('attendence data 2 $addressData');
      print('attendence data 3 $latitude');
      print('attendence data 4 $longitude');
      print('attendence data 5 $attendenceTime');
      final Map<String, dynamic> formDataMap = {
        'check_out': attendenceTime.toString(),
        'check_out_latitude': latitude.toString(),
        'check_out_longitude': longitude.toString(),
        'check_out_address': addressData.toString(),
      };
      if (pickedFile.path.isNotEmpty) {
        formDataMap['check_out_image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.path.split('/').last,
        );
      }
      if (StorageHelper.getType() == 3) {
        formDataMap['user_id'] = searchText.toString();
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_user_checkout,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<AttendenceListModel?> attendenceList(int month, int year) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        'month': month.toString(),
        'year': year.toString(),
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.monthly_attendance_summary,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendenceListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<LeaveListModel?> leaveList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.leave_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<LeaveTypeModel?> leaveTypeList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.leavetype_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveTypeModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<AttendenceUserDetails?> attendenceUserDetailsApi(String value) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        'user_id': value.toString(),
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.get_user_details,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendenceUserDetails.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<bool> applyingLeave(String startDate, String endDate, String duration,
      String leaveType, String description) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        'start_date': startDate.toString(),
        'end_date': endDate.toString(),
        'reason': description.toString(),
        'leave_type': leaveType.toString(),
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.apply_leave,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return false;
    }
  }

  Future<bool> leaveEditing(String startDate, String endDate, String duration,
      String leaveType, String description, String id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('edit data value $startDate');
      print('edit data value 2 $endDate');
      print('edit data value 3 $duration');
      print('edit data value 4 $leaveType');
      print('edit data value 5 $description');
      print('edit data value 6 $id');
      final Map<String, dynamic> formDataMap = {
        'start_date': startDate.toString(),
        'end_date': endDate.toString(),
        'reason': description.toString(),
        'leave_type': leaveType.toString(),
        'id': id,
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.edit_leave,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else if (response.statusCode == 403 || response.statusCode == 404) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return false;
    }
  }

  Future<bool> deleteLeave(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.delete_leave}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return false;
    }
  }
}
