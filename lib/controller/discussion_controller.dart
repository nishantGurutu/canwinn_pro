import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/task_message_history_model.dart';
import 'package:task_management/service/discussion_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../model/task_discussion_model.dart';

class DiscussionController extends GetxController {
  RxList<bool> isReplyOpen = <bool>[].obs;
  RxList<bool> isReplyOpen2 = <bool>[].obs;
  var profilePicPath = "".obs;

  var profilePicPath2 = "".obs;
  var isFileUpdated = false.obs;
  var isFilePicUploading = false.obs;
  Rx<File> pickedFile2 = File('').obs;
  var isPicUpdated = false.obs;
  var isProfilePicUploading = false.obs;

  RxList<bool> isReplyView = <bool>[].obs;
  var isDiscussionAdding = false.obs;
  Future<void> addDiscussion(
      String comment, int? taskId, File attachment) async {
    isDiscussionAdding.value = true;
    final result =
        await DiscussionService().addDiscussion(comment, taskId, attachment);
    pickedFile.value = File('');
    isDiscussionAdding.value = false;
  }

  var isLikeDislikeAdding = false.obs;
  Future<void> addLikeDislike(commentId, int i, int? taskId) async {
    isLikeDislikeAdding.value = true;
    final result = await DiscussionService().likeUnlike(commentId, i);
    await discussionList(taskId);
    isLikeDislikeAdding.value = false;
  }

  var isDislikeAdding = false.obs;
  Future<void> addDislike(commentId, int i, int? taskId) async {
    isDislikeAdding.value = true;
    final result = await DiscussionService().addDislike(commentId, i);
    await discussionList(taskId);
    isDislikeAdding.value = false;
  }

  Future<void> onPusherEvent(PusherEvent event) async {
    final eventData = jsonDecode(event.data);
    final newMessage = await TaskDiscussionModel.fromJson(eventData);
    discussionListData.add(newMessage.data as TaskDiscussionData);
    refresh();
  }

  var chatIdvalue = ''.obs;
  var messagePicPath = "".obs;
  var isMessagePicUploading = false.obs;
  Rx<File> pickedFile = File('').obs;
  var isDiscussionListLoading = false.obs;
  RxList<TaskDiscussionData> discussionListData = <TaskDiscussionData>[].obs;
  RxList<List<bool>> subCommentsList = [
    [false]
  ].obs;
  Future<void> discussionList(int? taskId) async {
    Future.microtask(() {
      isDiscussionListLoading.value = true;
    });
    final result = await DiscussionService().discussionList(taskId);
    if (result != null) {
      discussionListData.clear();
      isReplyOpen.clear();
      discussionListData.assignAll(result.data!);

      isReplyView.addAll(List<bool>.filled(discussionListData.length, false));

      for (int i = 0; i < discussionListData.length; i++) {
        subCommentsList
            .add(List.filled(discussionListData[i].subComments!.length, false));
      }
      isReplyOpen.addAll(List<bool>.filled(discussionListData.length, false));
    } else {
      isDiscussionListLoading.value = false;
    }
    isDiscussionListLoading.value = false;
  }

  Future<void> updateuidata(
      {required String messagetext,
      required File attachment,
      int? taskId}) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));

    String createdDateStr;
    if (now.isAfter(today) && now.isBefore(tomorrow)) {
      createdDateStr = "Today";
    } else if (now.isAfter(tomorrow) &&
        now.isBefore(tomorrow.add(Duration(days: 1)))) {
      createdDateStr = "Tomorrow";
    } else {
      createdDateStr = DateFormat("dd MMM yyyy").format(now);
    }

    final newMessage = TaskMessageData(
      senderId: StorageHelper.getId(),
      senderName: StorageHelper.getName(),
      attachment: attachment.path,
      createdAt: DateFormat.Hm().format(DateTime.now()),
      createdDate: createdDateStr,
      message: messagetext,
    );

    taskMessageList.add(newMessage);
    refresh();
    await addDiscussion(messagetext, taskId, attachment);
  }

  RxList<TaskMessageData> taskMessageList = <TaskMessageData>[].obs;
  var isTaskMessageListLoading = false.obs;
  Future<void> taskMessageListApi(int? taskId) async {
    isTaskMessageListLoading.value = true;
    final result = await DiscussionService().taskMessageList(taskId);
    taskMessageList.assignAll((result?.data ?? []).reversed.toList());
    isTaskMessageListLoading.value = false;
  }
}
