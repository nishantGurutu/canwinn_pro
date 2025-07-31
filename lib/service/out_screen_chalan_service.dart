import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/OutScreenChalanDetailsModel.dart';
import 'package:task_management/model/data_table_model.dart';
import 'package:task_management/model/in_screen_chalan_details.dart';
import 'package:task_management/model/outScreenChalanListModel.dart';

class OutScreenChalanService {
  final Dio _dio = Dio();
  Future<bool> addOutScreenChalanApi(
    String date,
    int? deptValue,
    String dispatch,
    String contact,
    String preparedBy,
    Rx<File> pickedFile,
    RxList<DataTableModel> tableData,
    String receivedBy,
  ) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final List<Map<String, dynamic>> items =
          tableData.map((data) => data.toJson()).toList();

      final Map<String, dynamic> formDataMap = {
        'date': date,
        'department_name': deptValue,
        'dispatch_to': dispatch,
        'contact': contact,
        'prepared_by': preparedBy,
        'items': items,
        'received_by': receivedBy,
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['upload_image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.create_outscreen_chalan,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add challan');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addInScreenChalanApi(
      String name,
      String date,
      int? deptId,
      String purpose,
      String contact,
      Rx<File> pickedFile,
      String addresstext) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('in chalan form ${name}');
      print('in chalan form 2 ${date}');
      print('in chalan form 3 ${deptId}');
      print('in chalan form 4 ${purpose}');
      print('in chalan form 5 ${contact}');
      print('in chalan form 6 ${pickedFile}');
      print('in chalan form 6 ${addresstext}');

      final Map<String, dynamic> formDataMap = {
        'date': date,
        'name': name,
        'address': addresstext,
        'entry_to_department': deptId,
        'purpose': purpose,
        'contact': contact,
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.create_inscreen_challan,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await inScreenChalanApi();
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add challan');
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> outScreenChalanApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_outscreen_chalan,
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

  Future<OutScreenChalanListModel?> outDepartmentScreenChalanApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.department_outscreen_challan,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OutScreenChalanListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> inScreenChalanApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_inscreen_chalan,
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

  Future<bool> updateStatus(
    int? id,
    int status,
    String remark,
    Rx<File> pickedFile,
  ) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('chalan details status update $id');
      print('chalan details status update 2 $status');
      print('chalan details status update 3 $remark');
      final Map<String, dynamic> formDataMap = {
        'id': id,
        'status': status,
      };

      if (remark.isNotEmpty) {
        formDataMap['remark'] = remark;
      }

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['security_upload_image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.outscreen_challan_update_status,
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

  Future<bool> inUpdateStatus(
    int? id,
    int status,
    String remark,
    Rx<File> pickedFile,
  ) async {
    try {
      print('jshdj sjhdjkhkd kshjdjbc $id');
      print('jshdj sjhdjkhkd kshjdjbc 2 $status');
      print('jshdj sjhdjkhkd kshjdjbc 3 $remark');
      print('jshdj sjhdjkhkd kshjdjbc 4 $pickedFile');
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'id': id,
        'status': status,
        'remark': remark,
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['security_upload_image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.inscreen_challan_update_status,
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

  Future<OutScreenChalanDetailsModel?> outChalanDetails(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'id': id,
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.outscreen_challan_by_id,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OutScreenChalanDetailsModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<InScreenChalanDetailsModel?> inChalanDetails(int? id) async {
    try {
      var token = StorageHelper.getToken();
      print('details id 34r34f3 : $id');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'id': id,
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.inscreen_challan_by_id,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return InScreenChalanDetailsModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }
}
