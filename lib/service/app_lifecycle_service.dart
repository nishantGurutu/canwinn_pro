import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/profile_controller.dart';

class AppLifecycleService extends GetxService with WidgetsBindingObserver {
  static AppLifecycleService get to => Get.find();
  
  final HomeController homeController = Get.find();
  final ChatController chatController = Get.find();
  final ProfileController profileController = Get.find();
  
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    print('=== GLOBAL APP LIFECYCLE SERVICE INIT ===');
    print('AppLifecycleService initialized - monitoring app lifecycle globally');
    print('==========================================');
  }
  
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    print('=== GLOBAL APP LIFECYCLE STATE CHANGE ===');
    print('App lifecycle state changed to: $state');
    print('=========================================');
    
    switch (state) {
      case AppLifecycleState.paused:
        // App is minimized - set user as offline
        print('GLOBAL: Setting user as offline due to app pause (minimized)');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
      case AppLifecycleState.detached:
        // App is killed - set user as offline
        print('GLOBAL: Setting user as offline due to app detached (killed)');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
      case AppLifecycleState.resumed:
        // App is resumed from background - set user as online
        print('GLOBAL: Setting user as online due to app resume');
        homeController.userActiveStatusApi(status: "online");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "online"});
        break;
      case AppLifecycleState.inactive:
        // App is inactive (temporary) - set user as offline
        print('GLOBAL: Setting user as offline due to app inactive');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
      case AppLifecycleState.hidden:
        // App is hidden - set user as offline
        print('GLOBAL: Setting user as offline due to app hidden');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
    }
  }
  
  // Manual method to set user online (can be called from anywhere)
  void setUserOnline() {
    print('GLOBAL: Manually setting user as online');
    homeController.userActiveStatusApi(status: "online");
    // Also update online status in chat controller
    chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "online"});
  }
  
  // Manual method to set user offline (can be called from anywhere)
  void setUserOffline() {
    print('GLOBAL: Manually setting user as offline');
    homeController.userActiveStatusApi(status: "offline");
    // Also update online status in chat controller
    chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
  }
}