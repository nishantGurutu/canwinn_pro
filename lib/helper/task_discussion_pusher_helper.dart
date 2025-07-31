import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/model/chat_history_model.dart';

class TaskDiscussionPusherConfig {
  PusherChannelsFlutter? pusher;
  final ChatController chatController = Get.put(ChatController());
  String APP_ID = "1899372";
  String API_KEY = "39e47d55853774809727";
  String SECRET = "28aaf7e01c80c948d803";
  String API_CLUSTER = "ap2";

  Future<void> initPusher(Function(PusherEvent) onMessageReceived,
      {String? channelName, required String roomId}) async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher?.init(
        apiKey: API_KEY,
        cluster: API_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: (channelName, data) {
          log("onSubscriptionSucceeded: $channelName data: $data");
        },
        onEvent: (event) {
          log("Received event: ${event.eventName} - ${event.data}");

          if (event.eventName == "message") {
            try {
              final eventData = jsonDecode(event.data);
              log("event Data value in pusher: $eventData");
              if (eventData != null && eventData.containsKey("message")) {
                final newMessage = ChatHistoryData(
                  message: eventData["message"],
                  senderId: eventData["senderId"],
                  senderName: eventData["userName"],
                  senderEmail: "",
                  attachment: eventData["imageforevent"],
                  createdAt: DateFormat.Hm().format(DateTime.now()),
                );

                chatController.chatHistoryList.add(newMessage);
                chatController.chatHistoryList.refresh();

                log("New message added: ${chatController.chatHistoryList.last}");
              } else {
                log("Invalid event data structure: ${event.data}");
              }
            } catch (e) {
              log("Error parsing Pusher event: $e");
            }
          }
        },
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );

      await pusher?.subscribe(channelName: "$channelName.$roomId");

      log("Subscribed to: $channelName.$roomId");
      await pusher?.connect();
    } catch (e) {
      log("Error in initialization: $e");
    }
  }

  void disconnect() {
    pusher?.disconnect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }
}
