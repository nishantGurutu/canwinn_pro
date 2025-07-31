import 'dart:io';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:dio/dio.dart';
import '../api/api_constant.dart';
import '../constant/custom_toast.dart';

class NotesService {
  final Dio _dio = Dio();
  Future<dynamic> notesListApi(int folderId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.notesList}?folder_id=$folderId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool> addNotesApi(String title, String description, String colorValue,
      Rx<File> pickedFile, int folderId) async {
    String colorWithoutHash = colorValue.replaceAll('#', '');
    print('jashdiueh83id9i3 IU89 $title');
    print('jashdiueh83id9i3 IU89 2 $description');
    print('jashdiueh83id9i3 IU89 3 $colorWithoutHash');
    print('jashdiueh83id9i3 IU89 4 ${pickedFile.value.path}');
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'title': title,
        'description': description,
        'color': colorWithoutHash,
        'folder_id': folderId,
      };

      if (pickedFile.value.path.isNotEmpty) {
        var fileUrl = pickedFile.value.path.split('/').last;
        print('file url iuy384 $fileUrl');
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: fileUrl,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addNotes,
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

  Future<bool> pinNotesApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final formData = FormData.fromMap(
        {
          'notes_id': id,
        },
      );

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.notes_important,
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

  Future<bool> editNotesApi(String title, String description, int tag,
      int? priorityId, int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'tags': tag,
        'priority': priorityId,
        'id': id,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editNotes,
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

  Future<bool> deleteNotes(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('task delete response is $id');
      print('task delete response is $token');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteNotes}/$id",
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

  Future<dynamic> listFolderApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.listFolder}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }
}
