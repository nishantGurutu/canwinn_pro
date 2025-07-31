import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/client_model.dart';
import 'package:task_management/model/project_category_model.dart';
import 'package:task_management/model/project_details_model.dart';
import 'package:task_management/model/project_timing_model.dart';
import 'package:task_management/model/team_leader_model.dart';

import '../model/project_list_model.dart';
import '../model/responsible_person_list_model.dart';

class ProjectService {
  final Dio _dio = Dio();
  Future<ProjectListModel?> projectListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.projectList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProjectListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ProjectDetailsModel?> projectDetailsApi(int id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.projectDetails}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProjectDetailsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ProjectCategoryListModel?> projectCategoryListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.projectCategoryList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProjectCategoryListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<AllProjectListModel?> allProjectListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.allProjectList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AllProjectListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<ClientModel?> clientListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.clientList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClientModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<ProjectTimingModel?> projecttimingListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.projecttimingList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProjectTimingModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<TeamLeaderModel?> teamLeaderListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.teamLeaderList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TeamLeaderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  String idList = '';

  Future<bool> addProjectApi(
    String projectName,
    int? projectType,
    int? client,
    int? category,
    int? projectTiming,
    String price,
    String amount,
    String total,
    int? selectPerson,
    int? selectedLeader,
    String startDate,
    String dueDate,
    int? selectedPriority,
    int? selectedStatus,
    String description,
    RxList<String> departmentId,
    String dueTime,
  ) async {
    idList = '';

    for (var dept in departmentId) {
      if (dept.isNotEmpty) {
        if (idList.isEmpty) {
          idList = dept;
        } else {
          idList = idList + ', ' + dept;
        }
      }
    }
    print("idList value project $projectName");
    print("idList value project 2 $projectType");
    print("idList value project 9 $selectPerson");
    print("idList value project 10 $selectedLeader");
    print("idList value project 11 $startDate");
    print("idList value project 12 $dueDate");
    print("idList value project 13 $selectedPriority");
    print("idList value project 14 $selectedStatus");
    print("idList value project 15 $description");
    print("idList value project 16 $idList");
    print("idList value project 17 $dueTime");
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'name': projectName,
        'project_id': projectType,
        'type': projectType,
        'responsible_person': selectPerson,
        'team_leader': selectedLeader,
        'start_date': startDate,
        'due_date': dueDate,
        'priority': selectedPriority,
        'status': selectedStatus,
        'description': description,
        'department_id': idList,
        'due_time': dueTime,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addProject,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "New project created! Let's get started on this journey!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editProjectApi(
      String projectName,
      int? projectType,
      int? client,
      int? category,
      int? projectTiming,
      String price,
      String amount,
      String total,
      int? selectPerson,
      int? selectedLeader,
      String startDate,
      String dueDate,
      int? selectedPriority,
      int? selectedStatus,
      String description) async {
    try {
      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'id': userId.toString(),
        'name': projectName.toString(),
        'project_id': projectType.toString(),
        'type': projectType.toString(),
        'client': client.toString(),
        'category': category.toString(),
        'project_timing': projectTiming.toString(),
        'price': price.toString(),
        'amount': amount.toString(),
        'total': total.toString(),
        'responsible_person': selectPerson.toString(),
        'team_leader': selectedLeader.toString(),
        'start_date': startDate.toString(),
        'due_date': dueDate.toString(),
        'priority': selectedPriority.toString(),
        'status': selectedStatus.toString(),
        'description': description.toString(),
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editProject,
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

  Future<bool> deleteProject(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteProject}/$id",
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

  Future<ResponsiblePersonListModel?> responsiblePersonListApi(
      dynamic id) async {
    try {
      var token = StorageHelper.getToken();
      var assignedDept = StorageHelper.getAssignedDept();
      var url =
          "${ApiConstant.baseUrl + ApiConstant.responsiblePersonList}?dept_id=$id";

      print('Responsible  project person API URL: $url');

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
