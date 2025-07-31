import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/priority_model.dart';

class PriorityService {
  final Dio _dio = Dio();
  Future<PriorityModel?> priorityServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('token data value in industry service $token');
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.priorityList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PriorityModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addPriorityApi(String priorityName, String status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'priority_name': priorityName,
        'status': status == "active" ? 1 : 0,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addPriority,
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

  Future<bool> editPriorityApi(String priorityName, int? lostId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'priority_name': priorityName,
        'id': lostId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editPriority,
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

  Future<bool> deletePriorityApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deletePriority}/$id",
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
