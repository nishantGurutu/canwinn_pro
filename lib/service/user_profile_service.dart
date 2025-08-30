import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/daily_task_list_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/get_submit_daily_task_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/user_profile_model.dart';
import '../model/assetsTypeListmode.dart';
import '../model/assets_list_model.dart';

class ProfileService {
  final Dio _dio = Dio();
  Future<bool> updateProfile(
    String name,
    String email,
    String mobile,
    String? departmentId,
    int? id,
    String? value,
    Rx<File> pickedFile,
    String dob,
    String anniversaryType,
    String annivresaryDate,
  ) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print("male in profile data ${value}");

      final Map<String, dynamic> formDataMap = {
        'name': name,
        'email': email,
        'position': id,
        'mobile': mobile,
        'dob': dob,
        "anniversary_type":
            annivresaryDate.isNotEmpty ? 'Marriage Anniversary' : "",
        "anniversary_date": annivresaryDate,
      };

      if (departmentId != 0 && departmentId != null) {
        formDataMap['department_id'] = departmentId;
      }
      if (value!.isNotEmpty) {
        formDataMap['gender'] = value;
      }

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['profile_picture'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.updateProfile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusMessage =="Profile updated successfully!") {
        CustomToast().showCustomToast(
            "Your profie has been updated successfully! Time to shine and show the world your true self!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<UserProfileModel?> userDetails() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.getProfile,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfileModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<DepartMentListModel?> departmentList(dynamic selectedProjectId) async {
    try {
      print("department dtat $selectedProjectId");
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.departmentList}?project_id=${selectedProjectId == '' ? "" : selectedProjectId}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DepartMentListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addDepartment(String deptName) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'name': deptName,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addDepartment,
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

  Future<DailyTaskListModel?> dailyTaskList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_daily_task,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyTaskListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to load daity task list');
      }
    } catch (e) {
      print('daily task list error $e');
      return null;
    }
  }

  Future<AssetsTypeListModel?> assetsTypeList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_assets_type,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssetsTypeListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to load daity task list');
      }
    } catch (e) {
      print('daily task list error $e');
      return null;
    }
  }

  Future<AssetsListModel?> assetsList(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final Map<String, dynamic> formDataMap = {
        'type_id': id,
      };
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.list_assets,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssetsListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to load daity task list');
      }
    } catch (e) {
      print('daily task list error $e');
      return null;
    }
  }

  Future<bool> addDailyTask(String taskName, String taskTime) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'task_name': taskName,
        "task_time": taskTime,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_daily_task,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "New task on your list! Let's tackle it together!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDailyTask(int id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'task_id': id,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.delete_daily_task,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "Task deleted! Out with the old, in with the new!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editDailyTask(String? taskId, String title, String time) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('amssniod ednoe oie78e liu9 $taskId');
      print('amssniod ednoe oie78e liu9 2 $title');
      print('amssniod ednoe oie78e liu9 3 $time');
      final Map<String, dynamic> formDataMap = {
        'task_id': taskId,
        'task_name': title,
        'task_time': time,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.edit_daily_task,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "Task modified! You're making progress - keep it up!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitDailyTask(
      RxList<DailyTaskSubmitModel> dailyTaskSubmitList) async {
    try {
      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();
      print("872d88ndnnd dni329d89n ${dailyTaskSubmitList.length}");
      if (token == null || userId == null) {
        CustomToast()
            .showCustomToast("Authentication error. Please log in again.");
        return false;
      }
      // for (int i = 0; i < dailyTaskSubmitList.length; i++) {}
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final data = jsonEncode({
        "tasks": dailyTaskSubmitList.map((task) => task.toMap()).toList(),
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.submit_daily_task,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      }
    } catch (e) {
      if (e is DioException) {
      } else {}
      return false;
    }
  }

  Future<GetSubmitdailytaskModel?> previousSubmittedTask(
      String dateText) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.get_submitted_daily_task_list,
        data: {
          "start_date": dateText,
          "end_date": dateText,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GetSubmitdailytaskModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> assignAssets(
      AssetsTypeData assetTypeId,
      AssetsListData assetId,
      ResponsiblePersonData selectedPerson,
      String allocateddate,
      String releaseDate) async {
    try {
      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();

      if (token == null || userId == null) {
        CustomToast()
            .showCustomToast("Authentication error. Please log in again.");
        return false;
      }

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.headers["Content-Type"] = "application/json";

      final Map<String, dynamic> data = {
        "asset_id": assetId.id.toString(),
        "assigned_to": selectedPerson.id.toString(),
        'allocation_date': allocateddate,
        'release_date': releaseDate
      };

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.assign_assets}",
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      }
    } catch (e) {
      CustomToast()
          .showCustomToast("Failed to assign assets. Please try again.");
      return false;
    }
  }

  Future<bool> editAssignAssets() async {
    try {
      var token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.headers["Content-Type"] = "application/json";
      _dio.options.headers["Accept"] = "application/json";

      final Map<String, dynamic> data = {
        "asset_id": '',
        "assigned_to": '',
        'allocation_date': '',
        'release_date': '',
        'id': ''
      };

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.edit_assigned_assets}",
        data: data,
      );
      print('🚀 Final API Request Body: ${data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("⚠️ Error: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return false;
      }
    } catch (e) {
      print("edit assets exception $e");
      CustomToast()
          .showCustomToast("Failed to assign assets. Please try again.");
      return false;
    }
  }

  Future<dynamic> assignAssetsList() async {
    try {
      var token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl}${ApiConstant.list_allocated_assets}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } catch (e) {
      CustomToast()
          .showCustomToast("Failed to assign assets. Please try again.");
      return null;
    }
  }

  Future<bool> deleteAssignAssets(int? id) async {
    try {
      if (id == null) {
        CustomToast().showCustomToast("Invalid asset ID.");
        return false;
      }

      var token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.headers["Content-Type"] = "application/json";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));
      final Map<String, dynamic> data = {
        "asset_ids": [id],
      };

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.assets_delete}",
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> deleteAllocatedAssignAssets(
      int? id, allocationDate, releasedDate) async {
    try {
      var token = StorageHelper.getToken();
      print('jsji swkjsoiw $id');
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.delete_allocated_assets}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      }
    } catch (e) {
      CustomToast()
          .showCustomToast("Failed to delete asset. Please try again.");
      return false;
    }
  }

  Future<Uint8List?> downloadReportApi(String date) async {
    try {
      final userId = StorageHelper.getId();
      final token = StorageHelper.getToken();
      print("Token used uyt87 : $userId");
      print("Token used uyt87 2: $date");

      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl}${ApiConstant.download_employee_report}/$userId?date=$date",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Uint8List.fromList(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }
}
