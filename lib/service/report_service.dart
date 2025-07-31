import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/report_model.dart';

class ReportService {
  final Dio _dio = Dio();
  Future<ReportModel?> reportApi(String fromDate, String toDate) async {
    try {
      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.report}?user_id=$userId&datefrom=$fromDate&dateto=$toDate",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReportModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }
}
