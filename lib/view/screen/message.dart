import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/helper/pusher_config.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/group_member.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/widgets/customAudioPlayer.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/voiceRecorderButton.dart';

class MessageScreen extends StatefulWidget {
  final String? name;
  final String? chatId;
  final String? userId;
  final String? fromPage;
  final String? type;
  final List<dynamic>? members;
  final String image;
  final String groupIcon;
  final String? navigationType;
  const MessageScreen(this.name, this.chatId, this.userId, this.fromPage,
      this.members, this.type, this.image, this.groupIcon, this.navigationType,
      {super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageTextEditingController = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController.pageCountValue.value = 1;
    chatController.selectedMessage.value = "";
    chatController.selectedParentMessageSender.value = '';
    chatController.chatIdvalue.value = widget.chatId.toString();
    _scrollController.addListener(_scrollListener);
    chatController.chatHistoryListApi(
        widget.chatId, chatController.pageCountValue.value, 'initstate');
    if (chatController.chatIdvalue.value.isNotEmpty) {
      PusherConfig().initPusher(chatController.onPusherEvent,
          channelName: "chat", roomId: chatController.chatIdvalue.value);
    }
  }

  @override
  void dispose() {
    chatController.selectedMessage.value = "";
    chatController.selectedMessageId.value = "";
    chatController.selectedParentMessageSender.value = '';
    _scrollController.removeListener(_scrollListener);
    chatController.chatHistoryList.clear();
    PusherConfig().disconnect();
    chatController.pageCountValue.value = 1;
    chatController.isChatOptionOpenAppbar.value = false;
    chatController.chatIdvalue.value = '';
    super.dispose();
  }

  String previousCreateddate = "";

  bool _isBackButtonPressed = false;
  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      if (widget.navigationType == "notification") {
        Get.offAll(() => SplashScreen());
      } else {
        Get.back();
        await chatController.chatListApi('');
      }
      return true;
    } else {
      return true;
    }
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      chatController.pageCountValue.value += 1;
      await chatController.chatHistoryListApi(
        widget.chatId,
        chatController.pageCountValue.value,
        'pagination',
      );
    }
  }

  RxBool isCreatedDateShow = false.obs;

  final imojiscrollController = ScrollController();
  bool _isEmojiPickerVisible = false;

  @override
  Widget build(BuildContext context) {
    final int loggedInUserId = StorageHelper.getId();
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Obx(
        () => Scaffold(
          backgroundColor: whiteColor,
          appBar: chatController.isChatOptionOpenAppbar.value == true
              ? AppBar(
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () async {
                      chatController.isChatOptionOpenAppbar.value = false;
                    },
                    icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
                  ),
                  backgroundColor: backgroundColor,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.copy,
                      ),
                    )
                  ],
                )
              : AppBar(
                  elevation: 0,
                  leadingWidth: 85.w,
                  leading: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (widget.navigationType == "notification") {
                            Get.offAll(() => SplashScreen());
                          } else {
                            Navigator.of(context).pop(true);
                            Get.back();
                            await chatController.chatListApi('');
                          }
                        },
                        icon: SvgPicture.asset(
                            'assets/images/svg/back_arrow.svg'),
                      ),
                      SizedBox(
                        width: 45.w,
                        height: 45.h,
                        child: widget.type.toString().toLowerCase() == "group"
                            ? Obx(
                                () => InkWell(
                                  onTap: () {
                                    chatController.grouppickedFile.value =
                                        File('');
                                    chatController.groupmessagePicPath.value =
                                        '';
                                    chatController.pickedFile.value = File('');
                                    chatController.messagePicPath.value = '';
                                    showAlertDialog(context, 'group');
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF4E2FF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.5),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: chatController.groupmessagePicPath
                                              .value.isNotEmpty
                                          ? InkWell(
                                              onTap: () {},
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(22.5),
                                                child: Image.file(
                                                  File(chatController
                                                      .groupmessagePicPath
                                                      .value),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : widget.image.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.5),
                                                  child: Image.network(
                                                    widget.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.network(
                                                        widget.groupIcon,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return SizedBox();
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/images/png/group_icon.png',
                                                  fit: BoxFit.cover,
                                                  color: whiteColor,
                                                ),
                                    ),
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(22.5),
                                child: InkWell(
                                  onTap: () {
                                    openFile(widget.image);
                                  },
                                  child: Image.network(
                                    widget.image,
                                    width: 40.w,
                                    height: 40.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SizedBox();
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  backgroundColor: backgroundColor,
                  automaticallyImplyLeading: false,
                  title: InkWell(
                    onTap: () {
                      if (widget.type.toString().toLowerCase() == "group") {
                        Get.to(GroupMemberlist(widget.chatId));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.name}", style: rubikBlack),
                        Text("Active", style: rubikSmall),
                      ],
                    ),
                  ),
                ),
          body: SafeArea(
            child: chatController.isChatHistoryLoading.value == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : Column(
                    children: [
                      chatController.chatHistoryList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  noMessage,
                                  style: changeTextColor(
                                      robotoBlack, lightGreyColor),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  reverse: true,
                                  child: Obx(
                                    () => Column(
                                      children: List.generate(
                                          chatController.chatHistoryList.length,
                                          (index) {
                                        final chat = chatController
                                            .chatHistoryList[index];
                                        final isCurrentUser =
                                            chat.senderId == loggedInUserId;
                                        final currentDate =
                                            chat.createdDate?.split(' ')[0] ??
                                                '';
                                        String previousDate = '';
                                        if (index > 0) {
                                          previousDate = chatController
                                                  .chatHistoryList[index - 1]
                                                  .createdDate
                                                  ?.split(' ')[0] ??
                                              '';
                                        }
                                        final bool showDateHeader =
                                            index == 0 ||
                                                currentDate != previousDate;
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.h),
                                          child: SwipeTo(
                                            key: ValueKey(chat.id),
                                            onRightSwipe: (details) {
                                              chatController
                                                      .selectedMessage.value =
                                                  chat.message.toString();
                                              chatController.selectedMessageId
                                                  .value = chat.id.toString();
                                              chatController
                                                      .selectedParentMessageSender
                                                      .value =
                                                  chat.senderName.toString();
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (showDateHeader)
                                                      timeContainer(
                                                          chat.createdDate),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      isCurrentUser
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        isCurrentUser
                                                            ? SizedBox()
                                                            : Text(
                                                                "${chat.senderName ?? ''}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                maxLines:
                                                                    100000,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        GestureDetector(
                                                          onLongPress: () {
                                                            chatController
                                                                .isChatOptionOpenAppbar
                                                                .value = true;
                                                          },
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                              minWidth: 70.w,
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isCurrentUser
                                                                  ? Color(
                                                                      0xffF1F1F1)
                                                                  : Color(
                                                                      0xffEFF7FF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        11.r),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        11.r),
                                                                bottomLeft: isCurrentUser
                                                                    ? Radius
                                                                        .circular(11
                                                                            .r)
                                                                    : Radius
                                                                        .zero,
                                                              ),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 3.w,
                                                                    right: 3.w,
                                                                    top: 3.h,
                                                                    bottom: 3.h,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (chat.parentMessageId != null &&
                                                                          chat.parentMessageId !=
                                                                              "null" &&
                                                                          chat.parentMessageId !=
                                                                              0)
                                                                        Container(
                                                                          constraints:
                                                                              BoxConstraints(
                                                                            minWidth:
                                                                                70.w,
                                                                            maxWidth:
                                                                                MediaQuery.of(context).size.width * 0.9,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.r),
                                                                            color:
                                                                                dotColor,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsets.only(
                                                                                top: 4.h,
                                                                                bottom: 4.h,
                                                                                left: 8.w,
                                                                                right: 8.w),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  '${chat.parentSenderName ?? ''}',
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(fontSize: 12.sp, color: textColor),
                                                                                ),
                                                                                Text(
                                                                                  '${chat.parentMessage ?? ''}',
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(fontSize: 12.sp, color: textColor),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (chat.attachment !=
                                                                              null &&
                                                                          chat.attachment!
                                                                              .isNotEmpty)
                                                                        Column(
                                                                          children: [
                                                                            chat.attachment.toString().contains(".m4a")
                                                                                ? CustomAudioPlayer(
                                                                                    audioUrl: chat.attachment!,
                                                                                    chatId: chat.id.toString(),
                                                                                  )
                                                                                : Container(
                                                                                    constraints: BoxConstraints(
                                                                                      maxHeight: MediaQuery.of(context).size.width * 0.7,
                                                                                    ),
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        openFile(chat.attachment!);
                                                                                      },
                                                                                      child: getFilePreview(chat.attachment!),
                                                                                    ),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                      if (chat.message !=
                                                                              null &&
                                                                          chat.message!
                                                                              .isNotEmpty)
                                                                        Column(
                                                                          children: [
                                                                            (chat.message?.split(" ").length ?? 0) > 3
                                                                                ? Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          "${chat.message ?? ''}",
                                                                                          style: changeTextColor(heading8, Colors.black),
                                                                                          maxLines: 100000,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 15.h,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                                                                    child: Text(
                                                                                      "${chat.message ?? ''}              ",
                                                                                      style: changeTextColor(heading8, Colors.black),
                                                                                      maxLines: 100000,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (chat.message !=
                                                                            null &&
                                                                        chat.message!
                                                                            .isNotEmpty ||
                                                                    chat.attachment !=
                                                                        null)
                                                                  Positioned(
                                                                    bottom: 3.h,
                                                                    right: 7.w,
                                                                    child: Text(
                                                                      DateConverter.convertTo12HourFormat(
                                                                          chat.createdAt ??
                                                                              ""),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10.sp,
                                                                      ),
                                                                    ),
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          children: [
                            Obx(
                              () => chatController
                                      .messagePicPath.value.isNotEmpty
                                  ? Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 8.h),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            image: DecorationImage(
                                              image: FileImage(File(
                                                  chatController
                                                      .messagePicPath.value)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              chatController
                                                  .messagePicPath.value = '';
                                              chatController.pickedFile.value =
                                                  File('');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: borderColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.r))),
                                        child: Obx(
                                          () => Column(
                                            children: [
                                              if (chatController
                                                      .selectedMessage.value !=
                                                  "")
                                                Padding(
                                                  padding: EdgeInsets.all(6.0),
                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                          '${chatController.selectedMessage.value ?? ''}'),
                                                      Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.r),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10.r),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10.r),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10.r),
                                                                ),
                                                                color:
                                                                    dotColor),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.w,
                                                                  top: 8.h,
                                                                  bottom: 8.h),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${chatController.selectedParentMessageSender.value ?? ''}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color:
                                                                        textColor),
                                                              ),
                                                              Text(
                                                                '${chatController.selectedMessage.value ?? ''}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color:
                                                                        textColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 5.w,
                                                        top: 3.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            chatController
                                                                .selectedMessage
                                                                .value = "";
                                                          },
                                                          child: Icon(
                                                              Icons.close,
                                                              color: textColor,
                                                              size: 16.h),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              TextFormField(
                                                controller:
                                                    messageTextEditingController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                decoration: InputDecoration(
                                                  prefixIcon: InkWell(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      setState(() {
                                                        _isEmojiPickerVisible =
                                                            !_isEmojiPickerVisible;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 9.sp,
                                                          bottom: 9.sp,
                                                          left: 9.sp),
                                                      child: Image.asset(
                                                        'assets/image/png/imoji_icon_chat.png',
                                                        height: 12.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  suffixIcon: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          showAlertDialog(
                                                              context, 'chat');
                                                        },
                                                        child: Icon(
                                                            Icons.attachment),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      VoiceRecorderButton(
                                                        onRecordingComplete: (File
                                                            audioFile) async {
                                                          attachment =
                                                              audioFile;
                                                        },
                                                      ),
                                                      SizedBox(width: 8.w),
                                                    ],
                                                  ),
                                                  hintText: writeYourMessage,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8.h,
                                                          horizontal: 0.w),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    InkWell(
                                      onTap: () async {
                                        if (messageTextEditingController
                                                .text.isNotEmpty ||
                                            chatController.messagePicPath.value
                                                .isNotEmpty ||
                                            attachment.path.isNotEmpty) {
                                          String selectedMessage =
                                              chatController
                                                  .selectedMessage.value = '';
                                          chatController.selectedMessage.value =
                                              "";
                                          String message =
                                              messageTextEditingController.text;

                                          messageTextEditingController.clear();
                                          chatController.messagePicPath.value =
                                              '';
                                          chatController.pickedFile.value =
                                              File('');
                                          String selectedMessageId =
                                              chatController
                                                  .selectedMessageId.value;
                                          String selectedMessageSender =
                                              chatController
                                                  .selectedParentMessageSender
                                                  .value;
                                          chatController
                                              .selectedMessageId.value = "";
                                          chatController
                                              .selectedParentMessageSender
                                              .value = '';
                                          await chatController
                                              .updateMessageData(
                                            message: message,
                                            attachment: attachment,
                                            name: widget.name,
                                            userId: widget.userId ?? "",
                                            chatId: widget.chatId ?? "",
                                            fromPage: widget.fromPage,
                                            messageId: selectedMessageId,
                                            parrent_message_sender_name:
                                                selectedMessageSender,
                                            selectedMessage: selectedMessage,
                                          );
                                          attachment = File('');
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(23.r),
                                        ),
                                        child: Icon(Icons.send,
                                            color: whiteColor, size: 20.h),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Offstage(
                        offstage: !_isEmojiPickerVisible,
                        child: EmojiPicker(
                          textEditingController: messageTextEditingController,
                          config: Config(
                            height: 250.h,
                            emojiViewConfig: EmojiViewConfig(
                                emojiSizeMax: 28, backgroundColor: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget timeContainer(String? createdDate) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff27B1A2),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          "${createdDate ?? ''}",
          style: TextStyle(
              color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
          maxLines: 100000,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  File attachment = File('');
  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {
      Get.to(() => NetworkPDFScreen(file: file));
    }
  }

  // void openFile(String file) {
  //   String fileExtension = file.split('.').last.toLowerCase();

  //   if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
  //     Get.to(NetworkImageScreen(file: file));
  //   } else {
  //     Get.to(
  //       () => NetworkPDFScreen(
  //         file: file,
  //       ),
  //     );
  //   }
  // }

  Future<void> showAlertDialog(
    BuildContext context,
    String from,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10.sp),
            child: Container(
              width: double.infinity,
              height: 140.h,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            uploadFile(from);
                          },
                          child: Container(
                            height: 40.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/gallery-icon-removebg-preview.png',
                                  height: 20.h,
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // uploadFile();
                            takeAttachment(ImageSource.camera, from);
                          },
                          child: Container(
                            height: 40.h,
                            width: 130.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: whiteColor,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget getFilePreview(String url) {
    final fileExtension = url.split('.').last.toLowerCase();

    if (["jpg", "jpeg", "png", "gif", "webp"].contains(fileExtension)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11.r),
        child: url.toString().contains('https')
            ? Image.network(
                url,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image),
              )
            : Image.file(
                File(url),
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image),
              ),
      );
    } else if (fileExtension == "pdf") {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/image/png/pdf.png",
              height: 25.h,
            ),
            SizedBox(width: 10),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200.w),
              child: Text(
                "${url.split('/').last.toLowerCase()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    }
    return SizedBox();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> uploadFile(String from) async {
    try {
      attachment = File('');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        attachment = file;
        if (from == 'group') {
          chatController.grouppickedFile.value = File(file.path);
        } else {
          chatController.pickedFile.value = File(file.path);
        }
        if (from == 'group') {
          chatController.groupmessagePicPath.value =
              chatController.grouppickedFile.value.path.toString();
        } else {
          chatController.messagePicPath.value =
              chatController.pickedFile.value.path.toString();
        }

        Get.back();
        if (from == 'group') {
          await chatController.updateGroupIconApi(widget.chatId);
        }
        print(
            'selected file path from device is ${chatController.pickedFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> takeAttachment(ImageSource source, String from) async {
    try {
      attachment = File('');
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);

      if (pickedImage == null) {
        return;
      }
      Get.back();
      attachment = File(pickedImage.path);
      chatController.isMessagePicUploading.value = true;

      if (from == 'group') {
        chatController.grouppickedFile.value = File(pickedImage.path);
      } else {
        chatController.pickedFile.value = File(pickedImage.path);
      }
      if (from == 'group') {
        chatController.groupmessagePicPath.value = pickedImage.path.toString();
      } else {
        chatController.messagePicPath.value = pickedImage.path.toString();
      }

      chatController.isMessagePicUploading.value = false;
      // Get.back();
      if (from == 'group') {
        await chatController.updateGroupIconApi(widget.chatId);
      }
    } catch (e) {
      chatController.isMessagePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      chatController.isMessagePicUploading.value = false;
    }
  }
}
