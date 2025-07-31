import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/call_reason_model.dart';

class CallReasonService {
  final Dio _dio = Dio();
  Future<CallReasonModel?> callReasonServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('token data value in industry service $token');
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.callReasonList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CallReasonModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addCallReasonApi(String sourceName, String status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('call reason name val $sourceName');
      print('call reason name val 2 $status');
      print('call reason name val 3 $token');
      final formData = FormData.fromMap({
        'name': sourceName,
        // 'status': status == "active" ? 1 : 0,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addCallReason,
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

  Future<bool> editCallReasonApi(String sourceName, int? industryId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'name': sourceName,
        'id': industryId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editCallReason,
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

  Future<bool> deleteCallReasonApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteCallReason}/$id",
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
