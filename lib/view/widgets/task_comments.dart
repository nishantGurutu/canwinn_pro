import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/discussion_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/widgets/customAudioPlayer.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/voiceRecorderButton.dart';
import '../../constant/style_constant.dart';
import '../../constant/text_constant.dart';
import '../../controller/task_controller.dart';
import 'package:task_management/helper/pusher_config.dart';

class TaskComments extends StatefulWidget {
  final int? taskId;
  final DiscussionController discussionController;
  const TaskComments(this.taskId, this.discussionController, {super.key});

  @override
  State<TaskComments> createState() => _TaskCommentsState();
}

class _TaskCommentsState extends State<TaskComments> {
  final TextEditingController commentTextController = TextEditingController();
  TextEditingController messageTextEditingController = TextEditingController();
  String previousCreateddate = "";

  final TaskController taskController = Get.put(TaskController());
  final DiscussionController discussionController =
      Get.put(DiscussionController());
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    discussionController.taskMessageListApi(widget.taskId);
    widget.discussionController.chatIdvalue.value = widget.taskId.toString();
    if (widget.discussionController.chatIdvalue.value.isNotEmpty) {
      PusherConfig().initPusher(widget.discussionController.onPusherEvent,
          channelName: "task.id",
          roomId: widget.discussionController.chatIdvalue.value);
    }
  }

  final imojiscrollController = ScrollController();
  bool _isEmojiPickerVisible = false;
  String prevDate = '';
  @override
  Widget build(BuildContext context) {
    final int loggedInUserId = StorageHelper.getId();
    return Obx(
      () => Column(
        children: [
          widget.discussionController.taskMessageList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      noMessage,
                      style: changeTextColor(robotoBlack, lightGreyColor),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      reverse: true,
                      child: Column(
                        children:
                            discussionController.taskMessageList.map((chat) {
                          final isCurrentUser = chat.senderId == loggedInUserId;
                          final showDate = chat.createdDate?.toLowerCase() !=
                              prevDate.toLowerCase();

                          prevDate = chat.createdDate ?? '';
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (showDate == true)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xff27B1A2),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            "${chat.createdDate ?? ''}",
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 100000,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: isCurrentUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        isCurrentUser
                                            ? SizedBox()
                                            : Text(
                                                "${chat.senderName ?? ''}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 100000,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        InkWell(
                                          onLongPress: () {},
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minWidth: 70.w,
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isCurrentUser
                                                  ? Color(0xffF1F1F1)
                                                  : Color(0xffEFF7FF),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(11.r),
                                                topRight: Radius.circular(11.r),
                                                bottomLeft: isCurrentUser
                                                    ? Radius.circular(11.r)
                                                    : Radius.zero,
                                                bottomRight: isCurrentUser
                                                    ? Radius.zero
                                                    : Radius.circular(11.r),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 6.w,
                                                      right: 10.w,
                                                      top: 5.h,
                                                      bottom: 17.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      chat.attachment != null
                                                          ? Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: chat
                                                                        .attachment
                                                                        .toString()
                                                                        .contains(
                                                                            ".m4a")
                                                                    ? 40.h
                                                                    : MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.7,
                                                              ),
                                                              child: chat
                                                                      .attachment
                                                                      .toString()
                                                                      .contains(
                                                                          ".m4a")
                                                                  ? CustomAudioPlayer(
                                                                      audioUrl:
                                                                          chat.attachment!,
                                                                      chatId: chat
                                                                          .id
                                                                          .toString(),
                                                                    )
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        openFile(
                                                                            chat.attachment ??
                                                                                "",
                                                                            context);
                                                                      },
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(11.r)),
                                                                        child: chat.attachment.toString().contains('https')
                                                                            ? Image.network(
                                                                                "${chat.attachment ?? ""}",
                                                                                errorBuilder: (context, error, stackTrace) {
                                                                                  return SizedBox();
                                                                                },
                                                                              )
                                                                            : Image.file(
                                                                                File(chat.attachment ?? ''),
                                                                                errorBuilder: (context, error, stackTrace) {
                                                                                  return SizedBox();
                                                                                },
                                                                              ),
                                                                      ),
                                                                    ),
                                                            )
                                                          : SizedBox(),
                                                      Text(
                                                        "${chat.message ?? ''}  ",
                                                        style: changeTextColor(
                                                          robotoRegular,
                                                          Colors.black,
                                                        ),
                                                        maxLines: 100000,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 3.h,
                                                  right: 7.w,
                                                  child: Text(
                                                    (chat.createdAt ?? "")
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
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
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                Obx(
                  () => discussionController.messagePicPath.value.isNotEmpty
                      ? Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                  image: FileImage(File(discussionController
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
                                  discussionController.messagePicPath.value =
                                      '';
                                  discussionController.pickedFile.value =
                                      File('');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageTextEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _isEmojiPickerVisible = !_isEmojiPickerVisible;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 9.sp, bottom: 9.sp, left: 9.sp),
                              child: Image.asset(
                                'assets/image/png/imoji_icon_chat.png',
                                height: 12.sp,
                              ),
                            ),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  showAlertDialog(context, 'chat');
                                },
                                child: Icon(Icons.attachment),
                              ),
                              SizedBox(width: 8.w),
                              VoiceRecorderButton(
                                onRecordingComplete: (File audioFile) async {
                                  attachment = audioFile;
                                },
                              ),
                              SizedBox(width: 8.w),
                            ],
                          ),
                          hintText: writeYourMessage,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 15.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () async {
                        if (messageTextEditingController.text.isNotEmpty ||
                            attachment.path.isNotEmpty) {
                          String message = messageTextEditingController.text;

                          messageTextEditingController.clear();
                          widget.discussionController.messagePicPath.value = '';
                          widget.discussionController.pickedFile.value =
                              File('');
                          await widget.discussionController.updateuidata(
                            messagetext: message,
                            attachment: attachment,
                            taskId: widget.taskId,
                          );
                          attachment = File('');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Icon(Icons.send, color: whiteColor, size: 20.h),
                      ),
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
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  File attachment = File('');

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
                          uploadFile();
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
      },
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> uploadFile() async {
    attachment = File("");
    try {
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
        attachment = File(file.path);
        widget.discussionController.pickedFile.value = File(file.path);
        widget.discussionController.messagePicPath.value =
            widget.discussionController.pickedFile.value.path.toString();
        Get.back();
        print(
            'selected file path from device is ${widget.discussionController.pickedFile.value}');
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
      widget.discussionController.pickedFile.value = File(pickedImage.path);
      widget.discussionController.messagePicPath.value =
          pickedImage.path.toString();
    } catch (e) {
      print('Error picking image: $e');
    } finally {}
  }

  void openFile(String file, context) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      if (file.contains('https')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkImageScreen(file: file),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageScreen(file: File(file)),
          ),
        );
      }
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: File(file)),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }
}
