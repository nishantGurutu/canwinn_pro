import 'dart:io';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class CallHelper {
  Future<void> callWhatsApp({String? mobileNo}) async {
    String? mobileContact =
        mobileNo!.contains('+91') ? mobileNo : "+91$mobileNo";
    var androidUrl = "whatsapp://send?phone=$mobileContact";
    var iosUrl = "https://wa.me/$mobileContact";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  Future<void> callPhone({String? mobileNo}) async {
    Uri phoneno = Uri.parse('tel:${mobileNo}');
    if (await launchUrl(phoneno)) {
    } else {
      print('Not working');
    }
  }
}
