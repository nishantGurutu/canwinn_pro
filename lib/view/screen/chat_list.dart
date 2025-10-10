import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:task_management/view/screen/select_contact.dart';
import 'package:task_management/view/widgets/discussion_list.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {
  final ChatController chatController = Get.find();
  final ProfileController profileController = Get.find();
  final HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatController.selectedChatId.clear();
    chatController.chatListApi("");
    SosPusherConfigOnline().initPusher(
      _onPusherEvent,
      channelName: "online-users",
      context: context,
    ); 
    Future.delayed(const Duration(seconds: 2), () {
      homeController.userActiveStatusApi(status: "online");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    print('App lifecycle state changed to: $state');
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App is minimized or killed - set user as offline
        print('Setting user as offline due to app pause/detach');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
      case AppLifecycleState.resumed:
        // App is resumed - set user as online
        print('Setting user as online due to app resume');
        homeController.userActiveStatusApi(status: "online");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "online"});
        break;
      case AppLifecycleState.inactive:
        // App is inactive - set user as offline
        print('Setting user as offline due to app inactive');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
      case AppLifecycleState.hidden:
        // App is hidden - set user as offline
        print('Setting user as offline due to app hidden');
        homeController.userActiveStatusApi(status: "offline");
        // Also update online status in chat controller
        chatController.updateOnlineStatus({"user_id": profileController.userProfileModel.value?.data?.id, "is_online": "offline"});
        break;
    }
  }

  Future<void> _onPusherEvent(PusherEvent event) async {
    log("Pusher event received: ${event.eventName} - ${event.data}");
    
    try {
      if (event.eventName == "UserOnlineStatusChanged") {
        final eventData = jsonDecode(event.data ?? '{}');
        log("Online status event data: $eventData");
        
        // Update online status in chat controller
        chatController.updateOnlineStatus(eventData);
        
        // Force UI refresh
        chatController.onlineUserIds.refresh();
      }
    } catch (e) {
      log("Error handling pusher event: $e");
    }
  }
   
  Future onRefresher() async {
    await chatController.chatListApi("refresh");
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkImageScreen(file: file)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () =>
            chatController.isChatLoading.value
                ? Center(
                  child: CircularProgressIndicator(color: primaryButtonColor),
                )
                : RefreshIndicator(
                  onRefresh: onRefresher,
                  child: Column(
                    children: [
                      SizedBox(height: 5.h),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child:
                              chatController.chatList.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          noDiscussionDataIcon,
                                          height: 160.h,
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          'No Discussion found !',
                                          style: heading6,
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          'Click Below to Add',
                                          style: heading7,
                                        ),
                                      ],
                                    ),
                                  )
                                  : DiscussionList(chatController.chatList),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        child: Icon(Icons.add, color: whiteColor, size: 30.h),
        onPressed: () {
          Get.to(() => SelectContact());
        },
      ),
    );
  }

  Widget floatingActionButton() {
    return InkWell(
      onTap: () {
        Get.to(() => SelectContact());
      },
      child: Container(
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(27.r)),
          boxShadow: [
            BoxShadow(
              color: lightGreyColor.withOpacity(0.2),
              blurRadius: 13.0,
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: Icon(Icons.add, color: whiteColor, size: 25.sp)),
      ),
    );
  }
}
