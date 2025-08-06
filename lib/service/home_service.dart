import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class HomeService {
  final Dio _dio = Dio();
  Future<HomeScreenHomeScreenDataModel?> homeDataApi(id) async {
    try {
      var token = StorageHelper.getToken();

      var url = "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id";
      print('user id in home $id');
      print('user id in home 2 $url');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        url,
      );

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
  // Future<dynamic> homeDataApi(id) async {
  //   try {
  //     var token = StorageHelper.getToken();

  //     var url = "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id";
  //     print('user id in home $id');
  //     print('user id in home 2 $url');
  //     _dio.options.headers["Authorization"] = "Bearer $token";
  //     final response = await _dio.get(
  //       url,
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return response.data;
  //     } else {
  //       throw Exception('Failed notes list');
  //     }
  //   } catch (e) {
  //     print('Error in NotesService: $e');
  //     return null;
  //   }
  // }

  Future<HomeScreenHomeScreenDataModel?> userhomeDataApi(id) async {
    try {
      var token = StorageHelper.getToken();

      var url = "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id";
      print('user id in home $id');
      print('user id in home 2 $url');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        url,
      );

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
      dynamic id) async {
    try {
      var token = StorageHelper.getToken();
      print('Responsible person API URL: 873ye8738 $id');
      var url =
          "${ApiConstant.baseUrl + ApiConstant.responsiblePersonList}?dept_id=$id";

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
}
