import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/component/location_service.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/attendence/checkin_user_details.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/firebase_messaging/notification_firebase.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RegisterController registerController = Get.put(RegisterController());
  String _androidVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    functionCalling();
  }

  void functionCalling() async {
    await _getAndroidVersion();
    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (value) => isUserLogin(),
    );
  }

  Future<void> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _androidVersion =
            'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      });
    } else {
      setState(() {
        _androidVersion = 'Not running on Android';
      });
    }
  }

  Future<void> isUserLogin() async {
    await firebaseNotification(context);
    int? userId = StorageHelper.getId();

    if (userId != null) {
      if (StorageHelper.getType() == 3) {
        Get.offAll(() => const CheckinUserDetails());
      } else {
        Get.offAll(() => const BottomNavigationBarExample(
              from: '',
              payloadData: {},
            ));
      }
    } else {
      Get.offAll(() => const WelcomeScreen());
    }
    await LocationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                splashLogo,
                height: 120.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
