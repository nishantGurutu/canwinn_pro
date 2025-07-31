import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/model/expense_list_model.dart';
import 'package:task_management/model/expensetype_list_model.dart';
import 'package:task_management/service/expense_service.dart';

class ExpenseController extends GetxController {
  RxInt selectedIndex = (-1).obs;

  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  var isProfilePicUploading = false.obs;
  RxList<String> assignedUserId = <String>[].obs;
  RxList<String> reviewerUserId = <String>[].obs;
  Rx<File> pickedFile = File('').obs;

  var isExpenseAdding = false.obs;
  Future<void> addExpense(String expenseType, String billNumber, String amount,
      String description, String expensedate) async {
    isExpenseAdding.value = true;
    final result = await ExpenseService().addExpense(
        expenseType, billNumber, amount, description, pickedFile, expensedate);
    if (result) {
      Get.back();
      await expenseListApi(from: '', expenseIdType: '');
    } else {}
    isExpenseAdding.value = false;
  }

  var isExpenseUpdating = false.obs;
  Future<void> updatingExpense(
      String expenseType,
      String billNumber,
      String amount,
      String description,
      String expensedate,
      String expenseId) async {
    isExpenseUpdating.value = true;
    final result = await ExpenseService().updateExpense(expenseType, billNumber,
        amount, description, pickedFile, expensedate, expenseId);
    if (result) {
      Get.back();
      await expenseListApi(from: '', expenseIdType: '');
    } else {}
    isExpenseUpdating.value = false;
  }

  final Rx<TextEditingController> expenseTypeTextController =
      TextEditingController().obs;
  var isExpenseTypeListLoading = false.obs;
  RxList<ExpenseListData> expenseTypeListData = <ExpenseListData>[].obs;
  var selectedExpenseListData = ExpenseListData().obs;
  Future<void> expenseTypeListApi({
    required String from,
    String? expenseIdType,
  }) async {
    isExpenseTypeListLoading.value = true;
    final result = await ExpenseService().expenseTypeList();
    if (result != null) {
      expenseTypeListData.assignAll(result.data!);
      isExpenseTypeListLoading.value = false;
      if (from == 'update') {
        for (var expId in expenseTypeListData) {
          if (expId.id.toString() == expenseIdType.toString()) {
            selectedExpenseListData.value = expId;
            expenseTypeTextController.value.text = expId.name.toString();
          }
        }
      }
      print(
          'selected update expeudhy87ye8d ${expenseTypeTextController.value.text}');
    } else {}
    isExpenseTypeListLoading.value = false;
  }

  var isExpenseListLoading = false.obs;
  RxList<ExpenseData> expenseListData = <ExpenseData>[].obs;
  Future<void> expenseListApi(
      {required String from, String? expenseIdType}) async {
    isExpenseListLoading.value = true;
    final result = await ExpenseService().expenseList();
    if (result != null) {
      expenseListData.assignAll(result.data!);

      print('selected update expense value ${selectedExpenseListData.value}');
      isExpenseListLoading.value = false;
    } else {}
    isExpenseListLoading.value = false;
  }

  var isExpenseDeleting = false.obs;
  Future<void> expenseDelete(int id) async {
    isExpenseDeleting.value = true;
    final result = await ExpenseService().expenseDelete(id);
    await expenseListApi(from: '', expenseIdType: '');
    isExpenseDeleting.value = false;
    isExpenseDeleting.value = false;
  }
}
