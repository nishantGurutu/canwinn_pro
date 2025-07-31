import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/source_model.dart';

class SourceService {
  final Dio _dio = Dio();
  Future<SourceModel?> sourceServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('token data value in source service $token');
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.sourceList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SourceModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addSourceApi(String sourceName, String status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'source_name': sourceName,
        'status': status == "active" ? 1 : 0,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addSource,
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
      print('Error in addSourceApi: $e');
      return false;
    }
  }

  Future<bool> editSourceApi(String sourceName, int? sourceId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'source_name': sourceName,
        'id': sourceId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editSource,
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
      print('Error in addSourceApi: $e');
      return false;
    }
  }

  Future<bool> deleteSourceApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteSource}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to delete source');
      }
    } catch (e) {
      print('Error in deleteSourceApi: $e');
      return false;
    }
  }
}
