import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/user_file_count_model.dart';

class DocumentService {
  final Dio _dio = Dio();
  Future<bool> addFolderApi(String folderName) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'folder_name': folderName,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.createFolder,
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

  Future<bool> uploadFileApi(File? pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          pickedFile!.path,
          filename: pickedFile.path.split('/').last,
        ),
        'folder_id': '1',
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.uploadFile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      CustomToast().showCustomToast('Error: $e');
      return false;
    }
  }

  Future<bool> uploadFolderApi(String folderName) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'folder ': folderName,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.uploadFolder,
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

  Future<bool> userfileCountsApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.userfileCounts,
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

  Future<bool> deleteFolder(id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.deleteFolder}/$id",
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

  Future<bool> deleteFile(id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.deleteFile}/$id",
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

  Future<bool> renameFolder(id, String text) async {
    try {
      var token = StorageHelper.getToken();
      print(
          'rename folder id 2 ${ApiConstant.baseUrl + ApiConstant.renameFolder}');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'folder_id': id.toString(),
        'new_name': text.toString(),
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.renameFolder,
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

  Future<bool> renameFile(id, String text) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'file_id': id.toString(),
        'new_name': text.toString(),
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.renameFile,
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

  List<int> listId = <int>[];
  Future<bool> shareFolder(
      int? fileId, RxList<int> selectedResponsiblePersonId) async {
    listId.clear();
    for (var i in selectedResponsiblePersonId) {
      if (i > 0) {
        listId.add(i);
      }
    }
    try {
      print('selected id ${listId.length}');
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.shareFolder,
        data: {
          'folder_id': fileId.toString(),
          'shared_with_user_id': listId,
        },
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

  Future<UserFileCountModel?> userFileCount() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.userfileCounts,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserFileCountModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }
}
