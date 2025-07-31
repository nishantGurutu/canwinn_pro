import 'dart:io';
import 'package:get/get.dart';

class ChallanController extends GetxController {
  var isProfilePicUploading = false.obs;
  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  Rx<File> pickedFile = File('').obs;
}
