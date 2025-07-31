import 'package:get/get.dart';
import 'package:task_management/model/lost_reason_model.dart';
import 'package:task_management/service/lost_reason_service.dart';

class LostReasonController extends GetxController {
  var isLostReasonLoading = false.obs;
  var lostReasonModel = LostReasonModel().obs;

  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  RxList<LostReasonData> lostReasonList = <LostReasonData>[].obs;
  Future<void> lostReasonListApi() async {
    isLostReasonLoading.value = true;
    final result = await LostReasonService().lostReasonServiceApi();
    if (result != null) {
      lostReasonModel.value = result;
      lostReasonList.clear();
      lostReasonList.assignAll(lostReasonModel.value.data!);
    } else {}
    isLostReasonLoading.value = false;
  }

  var isLostReasonAdding = false.obs;
  Future<void> addLostReason(String LostReasonName, String status) async {
    isLostReasonAdding.value = true;
    final result =
        await LostReasonService().addLostReasonApi(LostReasonName, status);
    if (result) {
      await lostReasonListApi();
    } else {}
    isLostReasonAdding.value = false;
  }

  var isLostReasonEditing = false.obs;
  Future<void> editLostReason(String lostReasonName, int? lostReasonId) async {
    isLostReasonEditing.value = true;
    final result = await LostReasonService()
        .editLostReasonApi(lostReasonName, lostReasonId);
    if (result) {
      await lostReasonListApi();
    } else {}
    isLostReasonEditing.value = false;
  }

  var isLostReasonDeleting = false.obs;
  Future<void> deleteLostReason(int? id) async {
    isLostReasonDeleting.value = true;
    final result = await LostReasonService().deleteLostReasonApi(id);
    if (result) {
      await lostReasonListApi();
    } else {}
    isLostReasonDeleting.value = false;
  }
}
