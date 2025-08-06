import 'package:get/get.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import '../../helper/storage_helper.dart';
import '../lead_controller.dart';
import 'package:dio/dio.dart' as dio;

class LeadMeetingController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  LeadController leadController = Get.find();
  final LeadController leadMeetingListController = Get.find();
  var isAdding = false.obs;

  Future<bool> createLeadMeeting({
    required String leadId,
    required String meetingTitle,
    required String meetingDate,
    required String meetingTime,
    required String meetingVenue,
    required String visitType,
    required List<String> attendPersons,
    required String meetingLink,
    required String reminder,
  }) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';
      print('sju93n e93ue983uej j93u9 $leadId');
      print('sju93n e93ue983uej j93u9 $meetingTitle');
      print('sju93n e93ue983uej j93u9 $meetingDate');
      print('sju93n e93ue983uej j93u9 $meetingTime');
      print('sju93n e93ue983uej j93u9 $meetingVenue');
      print('sju93n e93ue983uej j93u9 $visitType');
      print('sju93n e93ue983uej j93u9 $attendPersons');
      print('sju93n e93ue983uej j93u9 $reminder');
      final Map<String, dynamic> formDataMap = {
        'meeting_title': meetingTitle,
        'meeting_date': meetingDate,
        'meeting_time': meetingTime,
        'meeting_venue': meetingVenue,
        'attend_person': attendPersons.join(','),
        'visit_type': visitType,
        'reminder': reminder,
      };
      if (meetingLink.isNotEmpty) {
        formDataMap['meeting_link'] = meetingLink;
      }
      if (leadId.isNotEmpty) {
        formDataMap['lead_id'] = leadId;
      }
      final formData = dio.FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_lead_meetings,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        CustomToast().showCustomToast(response.data['message']);
        await leadMeetingListController.fetchLeadMeetings(
            leadId: int.parse(leadId));

        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } catch (e) {
      print("Add lead error: $e");
      return false;
    }
  }
}
