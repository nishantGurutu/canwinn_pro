import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/model/OutScreenChalanDetailsModel.dart';
import 'package:task_management/model/data_table_model.dart';
import 'package:task_management/model/in_screen_chalan_details.dart';
import 'package:task_management/model/outScreenChalanListModel.dart';
import 'package:task_management/service/out_screen_chalan_service.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class OutScreenController extends GetxController {
  RxBool isOutSelected = true.obs;
  RxBool isInSelected = false.obs;

  RxList<DataTableModel> tableData = <DataTableModel>[].obs;
  var isOutScreenChalanAdding = false.obs;
  var isChalanPicUploading = false.obs;
  var chalanPicPath = "".obs;
  var isPicUpdated = false.obs;
  Rx<File> pickedFile = File('').obs;
  Future<void> addOutScreenChalanApi(
    String date,
    int? deptValue,
    String dispatch,
    String contact,
    String preparedBy,
    RxList<DataTableModel> tableData,
    String receivedBy,
  ) async {
    isOutScreenChalanAdding.value = true;
    final result = await OutScreenChalanService().addOutScreenChalanApi(
      date,
      deptValue,
      dispatch,
      contact,
      preparedBy,
      pickedFile,
      tableData,
      receivedBy,
    );
    outScreenChalanApi();
    Get.back();
    isOutScreenChalanAdding.value = false;
  }

  Future<void> addInScreenChalanApi(String name, String date, int? deptId,
      String purpose, String contact, String addresstext) async {
    isOutScreenChalanAdding.value = true;
    final result = await OutScreenChalanService().addInScreenChalanApi(
        name, date, deptId, purpose, contact, pickedFile, addresstext);
    inScreenChalanApi();
    Get.back();
    isOutScreenChalanAdding.value = false;
  }

  var isDataAdding = false.obs;
  RxList<String> returnableValue = <String>["false", "true"].obs;
  // RxString? selectedReturnableValue;
  RxString selectedReturnableValue = "false".obs;
  final TextEditingController itemController = TextEditingController();
  final TextEditingController returnableController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  void tableDataAdding(
      String itemName, int returnType, String quantity, String remark) {
    isDataAdding.value = true;
    int parsedQuantity = int.tryParse(quantity) ?? 0;
    int newSrno = tableData.length + 1;
    DataTableModel newItem = DataTableModel(
      srno: newSrno,
      itemName: itemName,
      isReturnable: returnType,
      quantity: parsedQuantity,
      remarks: remark,
    );
    tableData.add(newItem);
    isDataAdding.value = false;
    itemController.clear();
    quantityController.clear();
    remarkController.clear();
    selectedReturnableValue.value = "false";
    Get.back();
  }

  var chalanList = [].obs;
  var isChalanLoading = false.obs;
  Future<void> outScreenChalanApi() async {
    isChalanLoading.value = true;
    final result = await OutScreenChalanService().outScreenChalanApi();
    if (result != null) {
      chalanList.assignAll(result['data']);
    } else {}
    isChalanLoading.value = false;
  }

  RxList<ChalanData> departmentChalanList = <ChalanData>[].obs;
  var isDepartmentChalanLoading = false.obs;
  Future<void> outDepartmentScreenChalanApi() async {
    isDepartmentChalanLoading.value = true;
    final result =
        await OutScreenChalanService().outDepartmentScreenChalanApi();
    if (result != null) {
      isDepartmentChalanLoading.value = false;
      departmentChalanList.clear();
      departmentChalanList.assignAll(result.data!);
    } else {}
    isDepartmentChalanLoading.value = false;
  }

  var inScreenChalanList = [].obs;
  var isInChalanLoading = false.obs;
  Future<void> inScreenChalanApi() async {
    isInChalanLoading.value = true;
    final result = await OutScreenChalanService().inScreenChalanApi();
    if (result != null) {
      inScreenChalanList.assignAll(result['data']);
      isInChalanLoading.value = false;
    }
    isInChalanLoading.value = false;
  }

  int chalanId = 0;
  var isStatusUpdating = false.obs;
  Future<void> updateStatus(int? id, int status, String remark) async {
    isStatusUpdating.value = true;
    final result = await OutScreenChalanService()
        .updateStatus(id, status, remark, pickedFile);
    if (result) {
      await outChalanDetails();
      await outDepartmentScreenChalanApi();
      await outScreenChalanApi();
    } else {}
    isStatusUpdating.value = false;
  }

  Future<void> inupdateStatus(int? id, int status, String remark) async {
    isStatusUpdating.value = true;
    final result = await OutScreenChalanService()
        .inUpdateStatus(id, status, remark, pickedFile);
    if (result) {
      await inScreenChalanApi();
      await inChalanDetails();
    } else {}
    isStatusUpdating.value = false;
  }

  final rejectRemarkTextEditingController = TextEditingController().obs;
  Rx<OutScreenChalanDetailsModel?> outScreenChalanDetailsModel =
      Rx<OutScreenChalanDetailsModel?>(null);
  var isChalanDetailsUpdating = false.obs;
  Future<void> outChalanDetails() async {
    isChalanDetailsUpdating.value = true;
    final result = await OutScreenChalanService().outChalanDetails(chalanId);
    if (result != null) {
      outScreenChalanDetailsModel.value = result;
      rejectRemarkTextEditingController.value.text =
          outScreenChalanDetailsModel.value?.data?.remarks ?? '';
    } else {}
    isChalanDetailsUpdating.value = false;
  }

  Rx<InScreenChalanDetailsModel?> inScreenChalanDetailsModel =
      Rx<InScreenChalanDetailsModel?>(null);
  var isInChalanDetails = false.obs;
  Future<void> inChalanDetails() async {
    isInChalanDetails.value = true;
    final result = await OutScreenChalanService().inChalanDetails(chalanId);
    if (result != null) {
      inScreenChalanDetailsModel.value = result;
      isInChalanDetails.value = false;
    } else {}
    isInChalanDetails.value = false;
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Unsupported file type.')),
      // );
    }
  }
}
