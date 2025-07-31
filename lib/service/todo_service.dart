import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/tag_list_model.dart';
import 'package:task_management/model/todo_list_model.dart';

class TodoService {
  final Dio _dio = Dio();
  Future<ToDoModel?> todoListApi(String? value) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print(
          "jhsjhhdjkhjk kjhjkhghg ${ApiConstant.baseUrl + ApiConstant.todoList}?order=${value == "Inbox" ? "all" : value == "Done" ? "is_complete" : value == "Important" ? "is_important" : value == "Trash" ? "is_deleted" : value == "Recently Added" ? "new" : value == "Ascending" ? "asc" : "desc"}");
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.todoList}?order=${value == "Inbox" ? "all" : value == "Done" ? "is_complete" : value == "Important" ? "is_important" : value == "Trash" ? "is_deleted" : value == "Recently Added" ? "new" : value == "Ascending" ? "asc" : "desc"}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ToDoModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<TagListModel?> tagListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.tagList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TagListModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> addTodoApi(
      String title,
      int? tag,
      int? priorityId,
      String description,
      String dueTime,
      String dueDate,
      String reminderTime,
      String selectedReminderTime,
      Rx<File> pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      String reminderData = "${reminderTime} + $selectedReminderTime";
      print('add reminder reminderData $reminderData');
      final Map<String, dynamic> formDataMap = {
        'title': title,
        'description': description,
        'tags': tag,
        'priority': priorityId,
        'reminder': reminderData,
        'alert_date': dueDate,
        'alert_time': dueTime,
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addTodo,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast()
            .showCustomToast("To-do added! Ready to make some progress!");
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> editTodoApi(
      String titleText,
      int? tagId,
      int? priorityId,
      String descText,
      int? id,
      String date,
      String time,
      Rx<File> pickedFile,
      String reminderText,
      String? reminderValue) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      String reminderVal = "$reminderText + $reminderValue";
      final Map<String, dynamic> formDataMap = {
        'id': id.toString(),
        'title': titleText.toString(),
        'description': descText.toString(),
        'tags': tagId.toString(),
        'priority': priorityId.toString(),
        'alert_date': date.toString(),
        'reminder': reminderVal,
        'alert_time': time.toString(),
      };

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editTodo,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> deleteTodoApi(int? id) async {
    print('delete todo api $id');
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('todo list api delete data $id');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteTodo}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool?> completeTodoApi(
      RxList<int> completedTodoCheckList, int i) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      String ids = completedTodoCheckList.where((id) => id > 0).join(',');
      print('check ids value $ids');
      if (ids.isEmpty) {
        return null;
      }
      final formData = FormData.fromMap({
        'ids': ids,
        'status': i,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.todoComplete,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }
}
