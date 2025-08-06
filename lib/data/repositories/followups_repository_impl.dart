import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/data/network/base_api_services.dart';
import 'package:task_management/data/network/network_api_services.dart';
import 'package:task_management/domain/repositories/followups_repository.dart';
import 'package:dio/dio.dart';

class FollowupsRepositoryImpl implements FollowupsRepository {
  final BaseApiServices _apiService = NetworkApiServices();

  @override
  Future<bool> addFollowUp({
    required String followupsType,
    required String followupsDate,
    required String followupsTime,
    required String note,
    int? status,
    int? leadId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'lead_id': leadId.toString(),
        'follow_up_type': followupsType,
        'follow_up_date': followupsDate,
        'follow_up_time': followupsTime,
        'note': note,
        'status': status.toString(),
      });

      final response = await _apiService.getMultipartPostApiResponse(
        "${ApiConstant.baseUrl}${ApiConstant.store_follow_ups}",
        formData,
      );

      CustomToast().showCustomToast(response['message'] ?? 'Success');
      return true;
    } catch (e) {
      CustomToast().showCustomToast("Follow-up failed: $e");
      return false;
    }
  }

  @override
  Future<bool> changeFollowupStatus({
    required int id,
    required int status,
    required String remarks,
  }) async {
    try {
      final formData = FormData.fromMap({
        'id': id.toString(),
        'status': status.toString(),
        'remarks': remarks,
      });

      final response = await _apiService.getMultipartPostApiResponse(
        ApiConstant.baseUrl + ApiConstant.change_lead_followup_status,
        formData,
      );

      CustomToast().showCustomToast(response['message'] ?? 'Status updated');
      return true;
    } catch (e) {
      CustomToast().showCustomToast("Status update failed: $e");
      return false;
    }
  }
}
