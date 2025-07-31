import 'package:get/get.dart';
import 'package:task_management/model/contact_stage_Model.dart';
import 'package:task_management/service/contact_status_service.dart';

class ContactStageController extends GetxController {
  var isContactStatusLoading = false.obs;
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var contactStatusModel = ContactStageModel().obs;
  RxList<ContactStageData> contactStageList = <ContactStageData>[].obs;
  Future<void> contactStatusApi() async {
    isContactStatusLoading.value = true;
    final result = await ContactStatusService().contactStageServiceApi();
    if (result != null) {
      contactStatusModel.value = result;
      contactStageList.assignAll(contactStatusModel.value.data!);
    } else {}
    isContactStatusLoading.value = false;
  }

  var isContactStageAdding = false.obs;
  Future<void> addContactStage(String contactStageName, String status) async {
    isContactStageAdding.value = true;
    final result = await ContactStatusService()
        .addContactStageApi(contactStageName, status);
    if (result) {
      await contactStatusApi();
    } else {}
    isContactStageAdding.value = false;
  }

  var isContactStageEditing = false.obs;
  Future<void> editContactStage(
      String contactStageName, int? contactStageId) async {
    isContactStageEditing.value = true;
    final result = await ContactStatusService()
        .editContactStageApi(contactStageName, contactStageId);
    if (result) {
      await contactStatusApi();
    } else {}
    isContactStageEditing.value = false;
  }

  var isPriorityDeleting = false.obs;
  Future<void> deleteContactStage(int? id) async {
    isPriorityDeleting.value = true;
    final result = await ContactStatusService().deleteContactStageApi(id);
    if (result) {
      await contactStatusApi();
    } else {}
    isPriorityDeleting.value = false;
  }
}
