import 'package:get/get.dart';
import 'package:task_management/model/call_reason_model.dart';
import 'package:task_management/service/call_reason_service.dart';

class CallReasonController extends GetxController {
  var isCallReasonLoading = false.obs;
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var callReasonModel = CallReasonModel().obs;
  RxList<CallReasonData> callReasonList = <CallReasonData>[].obs;
  Future<void> callReasonListApi() async {
    isCallReasonLoading.value = true;
    final result = await CallReasonService().callReasonServiceApi();
    if (result != null) {
      callReasonModel.value = result;
      callReasonList.clear();
      callReasonList.assignAll(callReasonModel.value.data!);
    } else {}
    isCallReasonLoading.value = false;
  }

  var isCallReasonAdding = false.obs;
  Future<void> addCallReason(String CallReasonName, String status) async {
    isCallReasonAdding.value = true;
    final result =
        await CallReasonService().addCallReasonApi(CallReasonName, status);
    if (result) {
      print('Source added successfully');
      await callReasonListApi();
    } else {
      print('Failed to add source');
    }
    isCallReasonAdding.value = false;
  }

  var isCallReasonEditing = false.obs;
  Future<void> editCallReason(String callReasonName, int? callReasonId) async {
    isCallReasonEditing.value = true;
    final result = await CallReasonService()
        .editCallReasonApi(callReasonName, callReasonId);
    if (result) {
      print('Source added successfully');
      await callReasonListApi();
    } else {
      print('Failed to add source');
    }
    isCallReasonEditing.value = false;
  }

  var isCallReasonDeleting = false.obs;
  Future<void> deleteCallReason(int? id) async {
    isCallReasonDeleting.value = true;
    final result = await CallReasonService().deleteCallReasonApi(id);
    if (result) {
      await callReasonListApi();
    } else {}
    isCallReasonDeleting.value = false;
  }
}
