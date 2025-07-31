import 'package:get/get.dart';
import 'package:task_management/model/status_model.dart';
import 'package:task_management/service/status_service.dart';

class StatusController extends GetxController {
  var isStatusLoading = false.obs;
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var makeSelectedStatusValue = "".obs;
  var fromPage = "".obs;
  var statusModel = StatusModel().obs;
  StatusData? selectedStatusData;
  RxList<StatusData> statusList = <StatusData>[].obs;
  Future<void> statusApi() async {
    isStatusLoading.value = true;
    final result = await StatusService().statusServiceApi();
    if (result != null) {
      statusModel.value = result;
      statusList.clear();
      statusList.assignAll(statusModel.value.data!);
    } else {}
    isStatusLoading.value = false;
  }

  Future<void> updateAssignPriorityValue(RxList<StatusData> statusList) async {
    if (fromPage.value == "edit") {
      for (int i = 0; i < statusList.length; i++) {
        if (statusList[i].id.toString() == makeSelectedStatusValue.value) {
          selectedStatusData = statusList[i];
          update();
        }
      }
    }
  }

  var isStatusAdding = false.obs;
  Future<void> addStatus(String LostReasonName, String status) async {
    isStatusAdding.value = true;
    final result = await StatusService().addStatusApi(LostReasonName, status);
    if (result) {
      await statusApi();
    } else {}
    isStatusAdding.value = false;
  }

  var isStatusEditing = false.obs;
  Future<void> editStatus(String lostReasonName, int? lostReasonId) async {
    isStatusEditing.value = true;
    final result =
        await StatusService().editStatusApi(lostReasonName, lostReasonId);
    if (result) {
      await statusApi();
    } else {}
    isStatusEditing.value = false;
  }

  var isStatusDeleting = false.obs;
  Future<void> deleteStatus(int? id) async {
    isStatusDeleting.value = true;
    final result = await StatusService().deleteStatusApi(id);
    if (result) {
      await statusApi();
    } else {}
    isStatusDeleting.value = false;
  }
}
