import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/chat_history_model.dart';

class PusherConfig {
  PusherChannelsFlutter? pusher;
  final ChatController chatController = Get.put(ChatController());
  String APP_ID = "1899372";
  String API_KEY = "39e47d55853774809727";
  String SECRET = "28aaf7e01c80c948d803";
  String API_CLUSTER = "ap2";

  String getDisplayDate(DateTime inputDateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final inputDate = DateTime(
      inputDateTime.year,
      inputDateTime.month,
      inputDateTime.day,
    );

    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(inputDateTime);
    }
  }

  Future<void> initPusher(
    Function(PusherEvent) onMessageReceived, {
    String? channelName,
    required String roomId,
  }) async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher?.init(
        apiKey: API_KEY,
        cluster: API_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: (channelName, data) {
        },
        onEvent: (event) async {
          chatController.seenMessageIds.clear();
          try {
            final eventData = jsonDecode(event.data);
            if (event.eventName == "message") {
              if (eventData.containsKey("message")) {
                if (StorageHelper.getId() != eventData["senderId"]) {
                  DateTime inputDateTime = DateTime.now();
                  String dt = DateFormat.Hm().format(DateTime.now());
                  String displayDate = getDisplayDate(inputDateTime);

                  final newMessage = ChatHistoryData(
                    id: eventData["msgid"],
                    message: eventData["message"],
                    senderId: eventData["senderId"],
                    senderName: eventData["userName"],
                    senderEmail: "",
                    attachment: eventData["imageforevent"],
                    createdDate: displayDate,
                    createdAt: dt,
                    readAt: '',
                  );

                  chatController.chatHistoryList.add(newMessage);
                  chatController.chatHistoryList.refresh();
                }
                chatController.seenMessageIds.add(eventData["msgid"]);
                await chatController.markSeen(
                  chatController.chatIdvalue.value,
                  chatController.seenMessageIds,
                );
              }
            } else if (event.eventName == "message_seen") {
              final messageId = eventData["messageId"];

              int index = chatController.chatHistoryList.indexWhere(
                (msg) => msg.id == messageId,
              );

              if (index != -1) {
                chatController.chatHistoryList[index].readAt = "";
                chatController.chatHistoryList.refresh();
              }
            }
          } catch (e) {
          }
        },
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );

      await pusher?.subscribe(channelName: "chat.$roomId");
      await pusher?.connect();
    } catch (e) {
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


class PusherConfig2 {
  PusherChannelsFlutter? pusher;
  final ChatController chatController = Get.put(ChatController());
  String APP_ID = "1899372";
  String API_KEY = "39e47d55853774809727";
  String SECRET = "28aaf7e01c80c948d803";
  String API_CLUSTER = "ap2";

  String getDisplayDate(DateTime inputDateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final inputDate = DateTime(
      inputDateTime.year,
      inputDateTime.month,
      inputDateTime.day,
    );

    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(inputDateTime);
    }
  }

  Future<void> initPusher(
    Function(PusherEvent) onMessageReceived, {
    String? channelName,
    required String roomId,
  }) async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher?.init(
        apiKey: API_KEY,
        cluster: API_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: (channelName, data) {
        },
        onEvent: (event) async {
          chatController.seenMessageIds.clear();
          try {
            final eventData = jsonDecode(event.data);
              if (eventData.containsKey("message")) {
                  DateTime inputDateTime = DateTime.now();
                  String dt = DateFormat.Hm().format(DateTime.now());
                  String displayDate = getDisplayDate(inputDateTime);
                  final newMessage = ChatHistoryData(
                    id: eventData["msgid"],
                    message: eventData["message"],
                    senderId: eventData["senderId"],
                    senderName: eventData["userName"],
                    senderEmail: "",
                    attachment: eventData["imageforevent"],
                    createdDate: displayDate,
                    createdAt: dt,
                    readAt: '',
                  );
                  if(chatController.chatHistoryList.last.message.toString().toLowerCase() == newMessage.message.toString().toLowerCase()){
                      chatController.chatHistoryList.last.id = newMessage.id;
                      chatController.chatHistoryList.last.readAt = 'null';
                  }
                    if (StorageHelper.getId() != eventData["senderId"]) {
                      chatController.chatHistoryList.add(newMessage);
                    }
                  chatController.chatHistoryList.refresh();
                if (StorageHelper.getId() != eventData["senderId"]) {
                  chatController.seenMessageIds.add(eventData["msgid"]);
                  await chatController.markSeen(
                    chatController.chatIdvalue.value,
                    chatController.seenMessageIds,
                  );
                }
              }else if (eventData.containsKey("messageIds")) {
                List<dynamic> messageIds = eventData["messageIds"];
                List<dynamic> readAtList = eventData["readAtList"];
                for (int i = 0; i < messageIds.length && i < readAtList.length; i++) {
                  int messageId = messageIds[i];
                  String readAt = readAtList[i].toString();
                  for (var message in chatController.chatHistoryList) {
                    if (message.id == messageId) {
                      message.readAt = readAt;
                      break;
                    }
                  }
                }
                chatController.chatHistoryList.refresh();
              }
          } catch (e) {
          }
        },
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      ); 
      await pusher?.subscribe(channelName: "chatseen.$roomId");
      await pusher?.connect();
    } catch (e) {
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
