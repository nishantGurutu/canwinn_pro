import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/lost_reason_model.dart';

class LostReasonService {
  final Dio _dio = Dio();
  Future<LostReasonModel?> lostReasonServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.lostReasonList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LostReasonModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addLostReasonApi(String lostReasonName, String status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'name': lostReasonName,
        'status': status == "active" ? 1 : 0,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addLostReason,
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

  Future<bool> editLostReasonApi(String lostName, int? lostId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'name': lostName,
        'id': lostId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editLostReason,
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

  Future<bool> deleteLostReasonApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteLostReason}/$id",
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
