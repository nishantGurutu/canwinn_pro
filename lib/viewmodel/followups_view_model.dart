import 'package:get/get.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/data/repositories/followups_repository_impl.dart';
import 'package:task_management/domain/repositories/followups_repository.dart';
import 'package:task_management/model/follow_ups_list_model.dart';
import 'package:task_management/view/screen/meeting/update_followup.dart';

class FollowupsViewModel extends GetxController {
  final LeadController leadController = Get.put(LeadController());
  final FollowupsRepository _repository = FollowupsRepositoryImpl();
  var isAddingFollowups = false.obs;
  Future<void> addFollowup({
    required String followupsType,
    required String followupsDate,
    required String followupsTime,
    required String note,
    int? status,
    int? leadId,
  }) async {
    try {
      isAddingFollowups.value = true;
      final result = await _repository.addFollowUp(
        followupsType: followupsType,
        followupsDate: followupsDate,
        followupsTime: followupsTime,
        note: note,
        status: status,
        leadId: leadId,
      );

      if (result != null) {
        Get.back();
      }
    } catch (e) {
      CustomToast().showCustomToast("Unexpected error: $e");
    } finally {
      isAddingFollowups.value = false;
    }
  }

  var followupStatusList = ["Done", "Not Done", "Reshedule"].obs;
  RxString selectedStatusType = "".obs;

  RxList<String> selectedStatusTypeList = <String>[].obs;

  var isChangingStatus = false.obs;
  Future<void> changeFollowupStatus({
    required int id,
    required int status,
    required String remarks,
    required leadId,
    required FollowUpsListData followUpsListData,
  }) async {
    try {
      isChangingStatus.value = true;

      final result = await _repository.changeFollowupStatus(
        id: id,
        status: status,
        remarks: remarks,
      );

      if (result != null) {
        Get.back();
        await leadController.followUpsListApi(leadId: null);
        if (status.toString() == "3") {
          Get.to(() => UpdateFollowUpsScreen(leadId: leadId));
          return;
        }
      }
    } catch (e) {
      CustomToast().showCustomToast("Unexpected error: $e");
    } finally {
      isChangingStatus.value = false;
    }
  }
}
