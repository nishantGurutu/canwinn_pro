import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/callender_eventList_model.dart';

class CalenderService {
  final Dio _dio = Dio();
  Future<EventCallenderListModel?> eventList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_calendar_events,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventCallenderListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool> addEventApi(String text, String date, String time,
      String reminder, String? reminderType) async {
    String reminderValue = "$reminder $reminderType";
    print('remindertpye value $text');
    print('remindertpye value 2 $date');
    print('remindertpye value 3 $time');
    print('remindertpye value 4 $reminderValue');
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'event_name': text,
        'event_date': date,
        'event_time': time,
        'reminder': reminderValue,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_calendar_events,
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

  Future<bool> deleteEvent(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.delete_calendar_events}/$id",
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
