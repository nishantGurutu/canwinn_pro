import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/activity_list_model.dart';
import 'package:task_management/model/activity_type_list_model.dart';

class ActivityService {
  final Dio _dio = Dio();
  Future<bool?> addActivityTypeApi(String text) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('activity type text $text');
      final formData = FormData.fromMap({
        'name': text,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addActivitytype,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<ActivityListModel?> ActivityListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.activityList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActivityListModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<ActivityTypeListModel?> ActivityTypeListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.activitytypeList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActivityTypeListModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> addActivityApi(
      String titleText,
      String dueDateText,
      String timeText,
      String reminderText,
      String descriptionText,
      String? ownerValue,
      int? guestValue,
      String activityType) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'title': titleText,
        'activity_type': activityType,
        'due_date': dueDateText,
        'time': timeText,
        'guest': guestValue,
        'description': descriptionText,
        'company': '1',
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addActivities,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> deleteActivityApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.deleteActivities}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }
}
