import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/meeting_attendence_model.dart';
import 'package:task_management/model/meeting_list_model.dart';
import 'package:task_management/model/meeting_token_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class MeetingService {
  final Dio _dio = Dio();
  Future<bool> addMeeting(
      int? deptId,
      List<ResponsiblePersonData> userIds,
      String meetingTitle,
      String meetingVinue,
      String meetingLink,
      String meetingDate,
      String meetingTime,
      String meetingEndTime,
      String reminder) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      String ids = userIds
          .map((e) => e.id.toString())
          .toList()
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '');
      print('selected user ids in meeting $ids');
      print('selected user ids in meeting 2 $reminder');
      print('selected user ids in meeting 3 $userIds');

      final Map<String, dynamic> formDataMap = {
        'title': meetingTitle,
        'venue': meetingVinue,
        'meeting_date': meetingDate,
        'meeting_time': meetingTime,
        'url': meetingLink,
        'dept_id': deptId.toString(),
        "meeting_end_time": meetingEndTime,
        'reminder': reminder,
      };

      if (userIds.isNotEmpty) {
        formDataMap['user_ids'] = ids;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_meeting,
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

  Future<MeetingListModel?> meetingList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_meetings,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MeetingListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> attendMeeting(int? meetingId, int status) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'meeting_id': meetingId,
        // 'status': status,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.attend_meeting,
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

  Future<MeetingTokenModel?> meetingToken() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.get_token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MeetingTokenModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> meetingMom(int? meetingId, String? description) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'meeting_id': meetingId,
        'description': description,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.meeting_mom,
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

  Future<MeetingAttendeesModel?> meetingAttendence(meetingId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'meeting_id': meetingId,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.get_meeting_attendees,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MeetingAttendeesModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponsiblePersonListModel?> responsiblePersonListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.responsiblePersonList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponsiblePersonListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }
}
