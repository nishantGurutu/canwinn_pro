import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/helper/sos_pusher.dart';

class GlobalPusherService extends GetxService {
  static GlobalPusherService get to => Get.find();
  
  // Pusher instance
  SosPusherConfigOnline? pusherInstance;
  RxBool isPusherConnected = false.obs;
  RxBool isPusherInitialized = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('=== GLOBAL PUSHER SERVICE INIT ===');
    print('GlobalPusherService initialized');
    print('==================================');
    
    // Initialize pusher when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeGlobalPusher();
    });
  }
  
  // Initialize global pusher for online status
  Future<void> initializeGlobalPusher() async {
    try {
      print('=== INITIALIZING GLOBAL PUSHER ===');
      print('Initializing global pusher for online status...');
      
      // Wait a bit for context to be available
      await Future.delayed(const Duration(seconds: 1));
      
      if (Get.context != null) {
        print('Context available, initializing pusher...');
        pusherInstance = SosPusherConfigOnline();
        await pusherInstance!.initPusher(
          _onGlobalPusherEvent,
          channelName: "online-users",
          context: Get.context!,
        );
        
        isPusherConnected.value = true;
        isPusherInitialized.value = true;
        print('✅ Global pusher initialized successfully');
        print('Pusher connected: ${isPusherConnected.value}');
        print('Initialized: ${isPusherInitialized.value}');
      } else {
        print('❌ Context not available, retrying in 2 seconds...');
        Future.delayed(const Duration(seconds: 2), () {
          initializeGlobalPusher();
        });
      }
    } catch (e) {
      print('❌ Error initializing global pusher: $e');
      isPusherConnected.value = false;
      // Retry after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        initializeGlobalPusher();
      });
    }
  }
  
  // Handle global pusher events
  Future<void> _onGlobalPusherEvent(PusherEvent event) async {
    print("=== GLOBAL PUSHER EVENT ===");
    print("Event: ${event.eventName} - Data: ${event.data}");
    print("Time: ${DateTime.now()}");
    print("=========================");
    
    try {
      final eventData = jsonDecode(event.data ?? '{}');
      
      // Handle all possible event names for online/offline status
      final eventName = event.eventName.toLowerCase();
      
      if (eventName.contains('online') || 
          eventName.contains('offline') || 
          eventName.contains('status') ||
          eventName.contains('user')) {
        
        print("🔍 Processing online/offline event: ${event.eventName}");
        print("   Event data: $eventData");
        print("   User ID: ${eventData['user_id'] ?? eventData['userId'] ?? eventData['id']}");
        print("   Status: ${eventData['is_online'] ?? eventData['status'] ?? eventData['online']}");
        
        // Get ChatController and update online status
        try {
          final chatController = Get.find<ChatController>();
          print("📱 Before update - Online users: ${chatController.onlineUserIds.toList()}");
          chatController.updateOnlineStatus(eventData);
          print("📱 After update - Online users: ${chatController.onlineUserIds.toList()}");
          print("✅ Updated ChatController with online/offline status");
        } catch (e) {
          print("❌ Error getting ChatController: $e");
        }
      } else {
        print("🔍 Processing other event: ${event.eventName}");
        print("   Event data: $eventData");
        
        // Check if this event contains online status information
        if (eventData.containsKey("online_users") || 
            eventData.containsKey("user_id") || 
            eventData.containsKey("userId") ||
            eventData.containsKey("id") ||
            eventData.containsKey("is_online") ||
            eventData.containsKey("status") ||
            eventData.containsKey("online")) {
          print("🔍 Event contains online status information");
          
          try {
            final chatController = Get.find<ChatController>();
            print("📱 Before other update - Online users: ${chatController.onlineUserIds.toList()}");
            chatController.updateOnlineStatus(eventData);
            print("📱 After other update - Online users: ${chatController.onlineUserIds.toList()}");
            print("✅ Updated ChatController with other event");
          } catch (e) {
            print("❌ Error getting ChatController for other event: $e");
          }
        } else {
          print("⚠️ Event data doesn't contain online status fields");
          print("   Available keys: ${eventData.keys.toList()}");
        }
      }
    } catch (e) {
      print("❌ Error handling global pusher event: $e");
      print("   Event name: ${event.eventName}");
      print("   Event data: ${event.data}");
    }
  }
  
  // Disconnect pusher
  void disconnectPusher() {
    pusherInstance?.disconnect();
    isPusherConnected.value = false;
    print('Global: Pusher disconnected');
  }
  
  @override
  void onClose() {
    disconnectPusher();
    super.onClose();
  }
}
