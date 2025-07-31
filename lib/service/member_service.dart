import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/member_list_model.dart';

class MemberClassService {
  final Dio _dio = Dio();
  Future<MemberListModel?> memberListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.memberList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MemberListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }
}
