import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/constant/color_constant.dart';

class CustomToast {
  void showCustomToast(String message) {
    Fluttertoast.showToast(
      backgroundColor: primaryColor,
      msg: message.replaceAll('  ', '  '),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      textColor: whiteColor,
      fontSize: 16.0,
    );
  }
}
