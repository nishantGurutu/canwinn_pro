import 'package:get/get.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/service/notification_service.dart';

class NotificationController extends GetxController {
  var isUnreadSelected = true.obs;
  var isReadSelected = false.obs;
  var isNotificationLoading = false.obs;
  var isAllSelect = false.obs;
  var isCheckBoxSelect = false.obs;
  var isScrolling = false.obs;
  var notificationList = [].obs;
  var readNotificationList = [].obs;
  RxList<bool> notificationSelectList = <bool>[].obs;
  RxList<bool> readNotificationSelectList = <bool>[].obs;
  RxList<String> notificationSelectidList = <String>[].obs;
  RxList<String> readNotificationSelectidList = <String>[].obs;
  RxList<String> notificationSelectTypeList = <String>[].obs;
  RxList<String> readNotificationSelectTypeList = <String>[].obs;
  RxInt pageValue = 1.obs;
  RxInt prePageCount = 1.obs;
  RxInt unreadNotificationCount = 0.obs;
  Future<void> notificationListApi(String type) async {
    if (type.toString() != 'scrolling') {
      isNotificationLoading.value = true;
    } else {
      isScrolling.value = true;
    }

    final result =
        await NotificationService().notificationListApi(pageValue.value);

    if (result != null) {
      print("notification kj98u99n ${result['totalnotification']}");
      unreadNotificationCount.value = 0;
      unreadNotificationCount.value = result['unreadcount'] ?? 0;

      if (type.toString() == '') {
        isAllSelect.value = false;
        notificationList.clear();
        notificationSelectList.clear();
      }
      if (result['unreadfeeds'].length > 0) {
        notificationList.addAll(result['unreadfeeds']);
      }
      if (pageValue.value == 1) {
        readNotificationList.addAll(result['readfeeds']);
      } else if (pageValue.value > 1 && result['readfeeds'].length > 0) {
        readNotificationList.addAll(result['readfeeds']);
      }
      readNotificationSelectList.assignAll(
        List<bool>.filled(readNotificationList.length, isAllSelect.value),
      );

      while (notificationSelectList.length < notificationList.length) {
        notificationSelectList.add(isAllSelect.value);
      }

      isNotificationLoading.value = false;
      isScrolling.value = false;

      refresh();
    } else {
      if (type.toString() != 'scrolling') {
        isNotificationLoading.value = false;
      } else {
        isScrolling.value = false;
      }
    }

    if (type.toString() != 'scrolling') {
      isNotificationLoading.value = false;
    } else {
      isScrolling.value = false;
    }
  }

  var isNotificationDeleting = false.obs;
  Future<void> deleteNotificationListApi(List<String> notificationSelectidList,
      List<String> notificationSelectTypeList) async {
    isNotificationDeleting.value = true;
    final result = await NotificationService().deleteNotificationListApi(
        notificationSelectidList, notificationSelectTypeList);
    if (result != null) {
      CustomToast().showCustomToast(result['message']);
      pageValue.value = 1;
      await notificationListApi('');

      isNotificationDeleting.value = false;
    } else {
      isNotificationDeleting.value = false;
    }
    isNotificationDeleting.value = false;
  }

  var isNotificationReading = false.obs;
  Future<void> readNotification(notificationId) async {
    isNotificationReading.value = true;
    final result = await NotificationService().readNotification(notificationId);
    if (result != null) {
      isNotificationReading.value = false;
      await notificationListApi('');
    } else {}
    isNotificationReading.value = false;
  }
}
