import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class FeedService {
  final Dio _dio = Dio();
  Future<dynamic> feedListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.listFeeds,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<dynamic> addEvent(
      String title,
      String description,
      String dueDate,
      String dueTime,
      int guest,
      String reminder,
      String event,
      String? timeType,
      String venueType,
      String urlText,
      RxList<ResponsiblePersonData> selectedGuest) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      String reminderValue = "$reminder $timeType";
      int eventTypeId = venueType.toLowerCase() == "global" ? 1 : 0;

      String selectedGuestId = '';
      for (int i = 0; i < selectedGuest.length; i++) {
        if (selectedGuestId.isEmpty) {
          selectedGuestId = selectedGuest[i].id.toString();
        } else {
          selectedGuestId += ",${selectedGuest[i].id.toString()}";
        }
      }
      print('add event data value $title');
      print('add event data value 2 $dueDate');
      print('add event data value 3 $dueTime');
      print('add event data value 4 $event');
      print('add event data value 5 $eventTypeId');
      print('add event data value 6 $description');
      print('add event data value 7 $selectedGuestId');
      print('add event data value 8 $reminderValue');
      final formData = FormData.fromMap({
        "title": title,
        "event_date": dueDate,
        "event_time": dueTime,
        "event_venue": event,
        "event_type": eventTypeId,
        "description": description,
        "attend_users": selectedGuestId,
        "reminder": '1 minute',
        'link': urlText,
      });
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addEvent,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> editEvent(
      String title,
      String description,
      String dueDate,
      String dueTime,
      int guest,
      String reminder,
      String event,
      String? timeType,
      String venueType) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      String reminderValue = "$reminder $timeType";

      final formData = FormData.fromMap({
        "title": title,
        "event_date": dueDate,
        "event_time": dueTime,
        "event_venue": event,
        "event_type": venueType,
        "description": description,
        "attend_users": guest,
        "reminder": reminderValue,
        "id": '',
      });
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.edit_event,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> eventList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.eventList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<dynamic> deleteEventList(int id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('feed event list id $id');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.delete_event_list}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }
}
