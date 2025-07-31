import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/helper/storage_helper.dart';

class SosPusherConfig {
  PusherChannelsFlutter? pusher;
  String APP_ID = "1899372";
  String API_KEY = "39e47d55853774809727";
  String SECRET = "28aaf7e01c80c948d803";
  String API_CLUSTER = "ap2";

  Future<void> initPusher(
    Function(PusherEvent) onMessageReceived, {
    String? channelName,
    required BuildContext context,
  }) async {
    pusher = await PusherChannelsFlutter.getInstance();
    try {
      await pusher?.init(
        apiKey: API_KEY,
        cluster: API_CLUSTER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: (channelName, data) {
          print("sos onSubscriptionSucceeded: $channelName data: $data");
        },
        onEvent: (event) async {
          try {
            print("event Data value in pusher: $event");
            DateTime dt = DateTime.now();

            final eventData = jsonDecode(event.data ?? '{}');

            if (eventData["action"] == "dailymsg") {
              await StorageHelper.setDailyMessage(true);
              await ShowDialogFunction().dailyMessage(
                context,
                eventData["message"],
                dt,
                eventData["title"],
              );
            } else {
              await StorageHelper.setSosMessage(true);
              await ShowDialogFunction()
                  .sosMsg(context, eventData["message"], dt);
            }
          } catch (e) {
            print("Error parsing Pusher event: $e");
          }
        },
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );

      await pusher?.subscribe(channelName: "$channelName");

      print("Subscribed to: $channelName");
      await pusher?.connect();
    } catch (e) {
      print("Error in initialization: $e");
    }
  }

  void disconnect() {
    pusher?.disconnect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName user: $member");
  }
}
