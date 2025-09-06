import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/chat_history_model.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/send_message_model.dart';
import 'package:task_management/service/chat_service.dart';

class ChatController extends GetxController {
  var chatModel = ChatListModel().obs;
  var isChatLoading = false.obs;
  var isChatOptionOpenAppbar = false.obs;

  RxMap<String, dynamic> replyMessage = <String, dynamic>{}.obs;
  RxBool isReplying = false.obs;

  var messagePicPath = "".obs;
  var groupmessagePicPath = "".obs;
  var isPicUpdated = false.obs;
  var isMessagePicUploading = false.obs;
  Rx<File> pickedFile = File('').obs;
  Rx<File> grouppickedFile = File('').obs;

  RxList<bool> isLongPressed = <bool>[].obs;
  StreamController<ChatHistoryModel> streamController = StreamController();
  RxInt totalUnsenMessage = 0.obs;
  RxList<ChatListData> chatList = <ChatListData>[].obs;

  Future<void> chatListApi(String s) async {
    if (s != "refresh") {
      isChatLoading.value = true;
    }
    final result = await ChatService().chatServiceApi();
    if (result != null) {
      isChatLoading.value = false;
      chatModel.value = result;

      isLongPressed.clear();
      totalUnsenMessage.value = 0;
      chatList.assignAll(chatModel.value.data!);
      chatList.refresh();
      isChatLoading.refresh();
      isLongPressed.addAll(List<bool>.filled(chatList.length, false));
      isChatLoading.value = false;
      isChatLoading.refresh();
      for (var chat in chatList) {
        totalUnsenMessage.value += chat.unseenMessages!;
      }
    } else {}
    isChatLoading.value = false;
  }

  Future<void> updateGroupIconApi(String? chatId) async {
    isChatLoading.value = true;
    final result = await ChatService().updateGroupIconApi(
      chatId,
      grouppickedFile,
    );
    if (result != null) {
      await chatListApi('');
    } else {}
    isChatLoading.value = false;
  }

  RxList<int> selectedChatId = <int>[].obs;
  Future<dynamic> deleteChat() async {
    isChatHistoryLoading.value = true;
    final result = await ChatService().deleteChat(selectedChatId);
    if (result != null) {
      selectedChatId.clear();
      await chatListApi('');
      return result;
    } else {
      isChatHistoryLoading.value = false;
    }
  }

  RxString chatIdvalue = ''.obs;
  var sendMessageModel = SendMessageModel().obs;
  var isMessageSending = false.obs;

  void onPusherEvent(PusherEvent event) {
    final eventData = jsonDecode(event.data);
    final newMessage = ChatHistoryModel.fromJson(eventData);
    chatHistoryList.add(newMessage.data as ChatHistoryData);
    chatHistoryList.refresh();
  }

  var isChatHistoryLoading = false.obs;
  var chatHistoryModel = ChatHistoryModel().obs;
  RxList<ChatHistoryData> chatHistoryList = <ChatHistoryData>[].obs;

  RxBool hasMoreMessages = true.obs;
  RxInt pageCountValue = 1.obs;
  RxInt prePageCount = 1.obs;
  Future<void> chatHistoryListApi(
    String? chatId,
    int pageCount,
    String fromRoute,
  ) async {
    if (fromRoute == 'initstate') {
      isChatHistoryLoading.value = true;
    }

    final result = await ChatService().chatHistoryServiceApi(chatId, pageCount);

    if (result != null && result.data!.isNotEmpty) {
      List<ChatHistoryData> newMessages = result.data!.reversed.toList();

      if (fromRoute == 'initstate') {
        chatHistoryList.assignAll(newMessages);
      } else {
        chatHistoryList.insertAll(0, newMessages);
      }
      chatHistoryList.refresh();
      hasMoreMessages.refresh();
      isChatHistoryLoading.refresh();
      hasMoreMessages.value = result.data!.length >= 20;
      prePageCount.value = pageCount;
    } else {
      hasMoreMessages.value = false;
    }

    if (fromRoute == 'initstate') {
      isChatHistoryLoading.value = false;
    }
  }

  Future<void> sendMessageApi(
    String? userId,
    String text,
    String? chatId,
    String? fromPage,
    File attachment, {
    required String messageId,
  }) async {
    isMessageSending.value = true;
    final result = await ChatService().sendMessageApi(
      userId,
      text,
      chatId,
      fromPage,
      attachment,
      messageId,
    );
    if (result != null) {
      pickedFile.value = File('');
    } else {
      isMessageSending.value = false;
    }
    isMessageSending.value = false;
  }

  var selectedMessage = "".obs;
  Rx<File> selectedFile = File('').obs;
  var selectedMessageId = "".obs;
  var selectedParentMessageSender = "".obs;
  Future<void> updateMessageData({
    required String message,
    required File attachment,
    String? name,
    required String userId,
    required String chatId,
    String? fromPage,
    required String messageId,
    required String parrent_message_sender_name,
    required String selectedMessage,
  }) async {
    DateTime inputDateTime = DateTime.now();

    String displayDate = getDisplayDate(inputDateTime);
    String dt = DateFormat.Hm().format(DateTime.now());
    print('oiwejui49 3i9u $displayDate');
    final newMessage = await ChatHistoryData(
      message: message,
      senderId: StorageHelper.getId(),
      senderName: name,
      senderEmail: "",
      attachment: attachment.path,
      createdAt: dt,
      createdDate: displayDate,
      parentSenderName: parrent_message_sender_name,
      parentMessageId: messageId.isNotEmpty ? int.parse(messageId) : 0,
      parentMessage: selectedMessage,
    );
    chatHistoryList.add(newMessage);
    print("message api calling after ");
    await sendMessageApi(
      userId,
      message,
      chatId ?? "",
      fromPage,
      attachment,
      messageId: messageId,
    );
  }

  String getDisplayDate(DateTime inputDateTime) {
    final now = DateTime.now();

    // Remove Time (only Date part)
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
      // Format as "dd MMM yyyy"
      return DateFormat('dd MMM yyyy').format(inputDateTime);
    }
  }

  RxList<int> selectedMemberId = <int>[].obs;
  final TaskController taskController = Get.put(TaskController());

  var isGroupUserAdding = false.obs;
  Future<void> addGroupUser(String? chatId, RxList<int> selectedChatId) async {
    isGroupUserAdding.value = true;
    final result = await ChatService().addGroupUser(chatId, selectedChatId);
    if (result != null) {
      selectedMemberId.clear();
      taskController.selectedLongPress.addAll(
        List<bool>.filled(taskController.responsiblePersonList.length, false),
      );
      await memberListApi(chatId);
    } else {
      isGroupUserAdding.value = false;
    }
    isGroupUserAdding.value = false;
  }

  var isGroupCreating = false.obs;
  List<int> selectedPersonList = <int>[];
  Future<void> groupCreateApi(
    String text,
    RxList<ResponsiblePersonData> selectedList,
  ) async {
    isGroupCreating.value = true;
    selectedPersonList.clear();
    for (var data in selectedList) {
      selectedPersonList.add(data.id);
    }

    final result = await ChatService().groupCreate(text, selectedPersonList);
    if (result != null) {
      await chatListApi('');
      Get.back();
      Get.back();
      Get.back();
    } else {
      isGroupCreating.value = false;
    }
    isGroupCreating.value = false;
  }

  var isMemberLoading = false.obs;
  var membersList = [].obs;
  Future<void> memberListApi(String? chatId) async {
    isMemberLoading.value = true;

    final result = await ChatService().memberListApi(chatId);
    if (result != null) {
      isMemberLoading.value = false;
      membersList.clear();
      membersList.assignAll(result['data']);
    } else {
      isMemberLoading.value = false;
    }
    isMemberLoading.value = false;
  }

  var isMarkSeenLoading = false.obs;
  Future<void> markSeen(dynamic chatId, List<int> seenMessageIds) async {
    isMemberLoading.value = true;

    final result = await ChatService().markSeen(chatId, seenMessageIds);
    if (result != null) {
      isMemberLoading.value = false;
    } else {
      isMemberLoading.value = false;
    }
    isMemberLoading.value = false;
  }

  var isChatTyping = false.obs;
  Future<void> chatTyping(dynamic chatId) async {
    isChatTyping.value = true;

    final result = await ChatService().chatTyping(chatId);
    if (result != null) {
      isChatTyping.value = false;
    } else {
      isChatTyping.value = false;
    }
    isChatTyping.value = false;
  }
}
