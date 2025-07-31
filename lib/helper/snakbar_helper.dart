import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';

class SnackbarHelper {
  static void showSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: primaryColor,
      colorText: whiteColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
