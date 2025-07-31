import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/service/bottom_bar_service.dart';
import 'package:task_management/view/screen/unauthorised/login.dart';

class BottomBarController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxBool isLogout = false.obs;
  RxBool isUpdating = false.obs;
  RxInt selectedTabIndex = 0.obs;

  Future<void> logout() async {
    isLogout.value = true;
    final result = await BottomBarService().logout();
    if (result) {
      StorageHelper.clear();
      Get.offAll(const LoginScreen());
    } else {}
    isLogout.value = false;
  }
}
