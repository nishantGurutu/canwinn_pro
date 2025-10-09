import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class HomeService {
  final Dio _dio = Dio();
  Future<HomeScreenHomeScreenDataModel?> homeDataApi(id) async {
    try {
      var token = StorageHelper.getToken();

      var url = "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id";
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeScreenHomeScreenDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<HomeScreenHomeScreenDataModel?> userhomeDataApi(id) async {
    try {
      var token = StorageHelper.getToken();

      var url = "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id";
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeScreenHomeScreenDataModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<dynamic> onetimeMsglist() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.onetime_msglist,
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

  Future<dynamic> anniversarylist() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.get_anniversary_list,
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

  Future<ResponsiblePersonListModel?> responsiblePersonListApi(
    dynamic id,
  ) async {
    try {
      var token = StorageHelper.getToken();
      var url = "${ApiConstant.baseUrl + ApiConstant.responsiblePersonList}";
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponsiblePersonListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch responsible person list');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponsiblePersonListModel?> responsiblePersonListApi2(
    RxList<DepartmentListData> selectedDepartMentListData2,
  ) async {
    try {
      var token = StorageHelper.getToken();
      var url = "${ApiConstant.baseUrl}${ApiConstant.responsiblePersonList}";
      print('trf36e e36fe673 e763t87 ${selectedDepartMentListData2.length}');
      if (selectedDepartMentListData2.isNotEmpty) {
        final departmentIds = selectedDepartMentListData2
            .map((dept) => dept.id.toString())
            .where((id) => id.isNotEmpty)
            .join(',');
        url += "?department_id=$departmentIds";
      }
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponsiblePersonListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch responsible person list');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  Future<bool> userActiveStatusApi(String status
  ) async {
    try {
      var token = StorageHelper.getToken();
      var url = "${ApiConstant.baseUrl}${ApiConstant.user_online_status}";
      
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        "status": status,
      };
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to fetch responsible person list');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
