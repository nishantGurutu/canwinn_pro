import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/expense_list_model.dart';
import 'package:task_management/model/expensetype_list_model.dart';

class ExpenseService {
  final Dio _dio = Dio();
  Future<bool> addExpense(String expenseType, String billNumber, String amount,
      String description, Rx<File> pickedFile, String expensedate) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('expense data 87y8e $expenseType');
      print('expense data 87y8e 2 $billNumber');
      print('expense data 87y8e 3 $amount');
      print('expense data 87y8e 4 $description');
      print('expense data 87y8e 5 $pickedFile');
      print('expense data 87y8e 6 $expensedate');
      print('expense data 87y8e 7 $token');

      final Map<String, dynamic> formDataMap = {
        "expense_type": expenseType == "Travel Expense" ? 1 : 2,
        "expense_date": expensedate,
        "bill_number": billNumber,
        "amount": amount,
        "description": description,
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['proof'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.add_expense,
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

  Future<bool> updateExpense(
      String expenseType,
      String billNumber,
      String amount,
      String description,
      Rx<File> pickedFile,
      String expensedate,
      expenseId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('expense update data 87y8e $expenseType');
      print('expense update data 87y8e 2 $billNumber');
      print('expense update data 87y8e 3 $amount');
      print('expense update data 87y8e 4 $description');
      print('expense update data 87y8e 5 $pickedFile');
      print('expense update data 87y8e 6 $expensedate');
      print('expense update data 87y8e 7 $token');
      print('expense update data 87y8e 8 $expenseId');

      final Map<String, dynamic> formDataMap = {
        "expense_type": expenseType == "Travel Expense" ? 1 : 2,
        "expense_date": expensedate,
        "bill_number": billNumber,
        "amount": amount,
        "description": description,
        "id": expenseId,
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['proof'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.updateExpense,
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

  Future<ExpenseTypeListModel?> expenseTypeList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.expense_type_list,
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseTypeListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ExpenseListModel?> expenseList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.expense_list,
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> expenseDelete(int id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };

      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.delete_expense}/$id",
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
}
