import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/status_model.dart';

class StatusService {
  final Dio _dio = Dio();
  Future<StatusModel?> statusServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('token data value in industry service $token');
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.statusList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addStatusApi(String statusName, String status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'status_name': statusName,
        'status': status == "active" ? 1 : 0,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addStatus,
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

  Future<bool> editStatusApi(String statusName, int? lostId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'status_name': statusName,
        'id': lostId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editStatus,
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

  Future<bool> deleteStatusApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteStatus}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to delete source');
      }
    } catch (e) {
      return false;
    }
  }
}
