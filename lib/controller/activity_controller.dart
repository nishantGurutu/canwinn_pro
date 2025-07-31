import 'package:get/get.dart';
import 'package:task_management/model/activity_list_model.dart';
import 'package:task_management/model/activity_type_list_model.dart';
import 'package:task_management/service/activity_service.dart';

class ActivityController extends GetxController {
  RxBool isMarkDone = false.obs;
  RxString isActivity = ''.obs;

  final RxList<String> beforeDue = ["Minutes", "Hours"].obs;
  RxString? selectedBeforeDue;
  final RxList<String> owner = ["Hendry", "Bradtke", "Sally"].obs;
  RxString? selectedOwner;
  var isActivityTypeLoading = false.obs;
  var isActivityListLoading = false.obs;
  RxList<ActivityTypeData> activityTypeList = <ActivityTypeData>[].obs;
  RxList<ActivityData> activityList = <ActivityData>[].obs;
  Future<void> activityListApi() async {
    isActivityListLoading.value = true;
    final result = await ActivityService().ActivityListApi();
    if (result != null) {
      activityList.clear();
      activityList.assignAll(result.data!);
    } else {}
    isActivityListLoading.value = false;
  }

  Future<void> activityTypeListApi() async {
    isActivityTypeLoading.value = true;
    final result = await ActivityService().ActivityTypeListApi();
    if (result != null) {
      activityTypeList.clear();
      activityTypeList.assignAll(result.data!);
    } else {}
    isActivityTypeLoading.value = false;
  }

  var isActivityTypeAdding = false.obs;
  Future<void> addActivityTypeApi(String text) async {
    isActivityTypeAdding.value = true;
    final result = await ActivityService().addActivityTypeApi(text);
    if (result != null) {
      Get.back();
      activityTypeListApi();
    } else {}
    isActivityTypeAdding.value = false;
  }

  RxString selectedActivity = ''.obs;
  var isActivityAdding = false.obs;
  Future<void> addActivityApi(
      String titleText,
      String dueDateText,
      String timeText,
      String reminderText,
      String descriptionText,
      String? ownerValue,
      int? guestValue) async {
    isActivityAdding.value = true;
    final result = await ActivityService().addActivityApi(
        titleText,
        dueDateText,
        timeText,
        reminderText,
        descriptionText,
        ownerValue,
        guestValue,
        selectedActivity.value);
    if (result != null) {
      Get.back();
      activityListApi();
    } else {}
    isActivityAdding.value = false;
  }

  var isActivityDeleting = false.obs;
  Future<void> deleteActivityApi(int? id) async {
    isActivityDeleting.value = true;
    final result = await ActivityService().deleteActivityApi(id);
    if (result != null) {
      activityListApi();
    } else {}
    isActivityDeleting.value = false;
  }
}
