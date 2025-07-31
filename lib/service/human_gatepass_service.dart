import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';

class HumanGatepassService {
  final Dio _dio = Dio();
  Future<bool> createHumanGatePass(
      {required Rx<File> pickedFile,
      required String empName,
      required String empId,
      required String contact,
      required String purposeOfVisiting,
      required String description,
      required String destination,
      required String returnTime,
      required String outTime,
      required int deptId,
      required String transportMode}) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('human Gate pass data 87y8e $empName');
      print('human Gate pass data 87y8e 2 $empId');
      print('human Gate pass data 87y8e 3 $contact');
      print('human Gate pass data 87y8e 4 $purposeOfVisiting');
      print('human Gate pass data 87y8e 5 $description');
      print('human Gate pass data 87y8e 6 $pickedFile');
      print('human Gate pass data 87y8e 7 $token');
      print('human Gate pass data 87y8e 8 $destination');
      print('human Gate pass data 87y8e 9 $returnTime');
      print('human Gate pass data 87y8e 10 $outTime');
      print('human Gate pass data 87y8e 11 $deptId');
      print('human Gate pass data 87y8e 12 $transportMode');

      final Map<String, dynamic> formDataMap = {
        "name": empName,
        "employee_id": empId,
        "mobile": contact,
        "department_id": deptId,
        "purpose_of_visit": purposeOfVisiting,
        "description": description,
        "destination": destination,
        "out_time": outTime,
        "return_time": returnTime,
        "mode_of_transport": transportMode,
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['proof_image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_human_gate_pass,
        data: formData,
        options: Options(
          validateStatus: (status) => true,
        ),
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

  Future<bool> updateHumanGatePassStatus(
      {required id, required String remark, required int status}) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print("status value $id");
      print("status value 2 $remark");
      print("status value 3 $status");
      final Map<String, dynamic> formDataMap = {
        "id": id,
        "status": status,
        "remarks": remark,
      };
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.update_human_gate_pass_status,
        data: formData,
        options: Options(
          validateStatus: (status) => true,
        ),
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

  Future<dynamic> humanGatePassList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.list_human_gate_pass,
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> humanGatePassdetails({required String id}) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
      };

      final Map<String, dynamic> formDataMap = {
        "id": id,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.show_human_gate_pass_detail,
        data: formData,
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }
}
