import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/task_message_history_model.dart';

import '../model/task_discussion_model.dart';

class DiscussionService {
  final Dio _dio = Dio();
  Future<bool> addDiscussion(
      String comment, int? taskId, File pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('recorded audio file path task is ${pickedFile.path}');
      final Map<String, dynamic> formDataMap = {};

      if (comment.isNotEmpty) {
        formDataMap['message'] = comment;
      }

      if (taskId != null && taskId > 0) {
        formDataMap['task_id'] = taskId;
      }

      if (pickedFile.path.isNotEmpty) {
        final filePath = pickedFile.path;
        final fileName = filePath.split('/').last;

        final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

        formDataMap['attachment'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
      }

      // if (pickedFile.path.isNotEmpty) {
      //   formDataMap['attachment'] = await MultipartFile.fromFile(
      //     pickedFile.path,
      //     filename: pickedFile.path.split('/').last,
      //   );
      // }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.send_task_message,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<bool> likeUnlike(commentId, int i) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'comment_id': commentId.toString(),
        'comment_type': i.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      print("Sending data: $formDataMap");

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.like_unlike_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<bool> addDislike(commentId, int i) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'comment_id': commentId.toString(),
        'comment_type': i.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      print("Sending data: $formDataMap");

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.dislike_undislike_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<TaskDiscussionModel?> discussionList(int? taskId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'task_id': taskId,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.list_task_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskDiscussionModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return null;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return null;
    }
  }

  Future<TaskMessageHistoryModel?> taskMessageList(taskId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'task_id': taskId,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.task_message_history,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskMessageHistoryModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return null;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return null;
    }
  }
}
