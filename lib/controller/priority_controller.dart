import 'package:get/get.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/service/priority_service.dart';

class PriorityController extends GetxController {
  var isPriorityLoading = false.obs;
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var fromPage = "".obs;
  var priorityModel = PriorityModel().obs;
  Rx<PriorityData?> selectedPriorityData = Rx<PriorityData?>(null);
  var makeSelectedPriorityValue = ''.obs;
  RxList<PriorityData> priorityList = <PriorityData>[].obs;
  Future<void> priorityApi({required String from}) async {
    isPriorityLoading.value = true;
    final result = await PriorityService().priorityServiceApi();
    if (result != null) {
      priorityModel.value = result;

      priorityList.assignAll(priorityModel.value.data!);
      updateAssignPriorityValue(priorityList);
    } else {}
    isPriorityLoading.value = false;
  }

  Future<void> updateAssignPriorityValue(
    RxList<PriorityData> priorityList,
  ) async {
    if (fromPage.value == "edit") {
      for (int i = 0; i < priorityList.length; i++) {
        if (priorityList[i].id.toString() == makeSelectedPriorityValue.value) {
          selectedPriorityData.value = priorityList[i];
          update();
        }
      }
    }
  }

  var isPriorityAdding = false.obs;
  Future<void> addPriority(String LostReasonName, String status) async {
    isPriorityAdding.value = true;
    final result = await PriorityService().addPriorityApi(
      LostReasonName,
      status,
    );
    if (result) {
      await priorityApi(from: '');
    } else {}
    isPriorityAdding.value = false;
  }

  var isPriorityEditing = false.obs;
  Future<void> editPriority(String lostReasonName, int? lostReasonId) async {
    isPriorityEditing.value = true;
    final result = await PriorityService().editPriorityApi(
      lostReasonName,
      lostReasonId,
    );
    if (result) {
      await priorityApi(from: '');
    } else {}
    isPriorityEditing.value = false;
  }

  var isPriorityDeleting = false.obs;
  Future<void> deletePriority(int? id) async {
    isPriorityDeleting.value = true;
    final result = await PriorityService().deletePriorityApi(id);
    if (result) {
      await priorityApi(from: '');
    } else {}
    isPriorityDeleting.value = false;
  }
}
