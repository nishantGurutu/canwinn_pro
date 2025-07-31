import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/widgets/customAudioPlayer.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/voiceRecorderButton.dart';
import 'dart:io';
import '../../controller/lead_controller.dart';

class LeadDiscussionList extends StatefulWidget {
  final dynamic leadId;
  const LeadDiscussionList({super.key, required this.leadId});

  @override
  State<LeadDiscussionList> createState() => _LeadDiscussionListState();
}

class _LeadDiscussionListState extends State<LeadDiscussionList> {
  final LeadController leadController = Get.put(LeadController());
  String prevDate = '';
  ScrollController _scrollController = ScrollController();
  File attachment = File('');
  bool _isEmojiPickerVisible = false;

  @override
  void initState() {
    prevDate = '';
    leadController.leadDiscussionList(int.parse(widget.leadId.toString()));
    super.initState();
  }

  @override
  void dispose() {
    prevDate = '';
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int loggedInUserId = StorageHelper.getId();
    return Obx(
      () => Column(
        children: [
          leadController.leadDiscussionListData.isEmpty
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
                            leadController.leadDiscussionListData.map((chat) {
                          final isCurrentUser = chat.senderId == loggedInUserId;
                          final currentDate =
                              chat.timestamp?.split(' ').first ?? '';
                          final showDate = currentDate != prevDate;
                          prevDate = currentDate;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Column(
                              children: [
                                if (showDate)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                            currentDate,
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
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
                                        if (!isCurrentUser)
                                          Text(
                                            "${chat.senderName ?? ''}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        SizedBox(height: 3.h),
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
                                                    bottom: 15.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (chat.attachment !=
                                                              null &&
                                                          chat.attachment!
                                                              .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            chat.attachment!
                                                                    .contains(
                                                                        ".m4a")
                                                                ? CustomAudioPlayer(
                                                                    audioUrl: chat
                                                                        .attachment!,
                                                                    chatId: chat
                                                                        .id
                                                                        .toString(),
                                                                  )
                                                                : Container(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                      maxHeight:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.7,
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        openFile(
                                                                            chat.attachment!,
                                                                            context);
                                                                      },
                                                                      child: getFilePreview(
                                                                          chat.attachment!),
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                                height: 6.h),
                                                          ],
                                                        ),
                                                      if (chat.message !=
                                                              null &&
                                                          chat.message!
                                                              .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "${chat.message}",
                                                              style:
                                                                  changeTextColor(
                                                                      heading8,
                                                                      Colors
                                                                          .black),
                                                              maxLines: 100000,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                if (chat.message != null &&
                                                        chat.message!
                                                            .isNotEmpty ||
                                                    chat.attachment != null)
                                                  Positioned(
                                                    bottom: 3.h,
                                                    right: 7.w,
                                                    child: Text(
                                                      "${chat.timestamp?.split(' ')[1]} ${chat.timestamp?.split(' ').last}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
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
                  () => leadController.messagePicPath.value.isNotEmpty
                      ? Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                  image: FileImage(File(
                                      leadController.messagePicPath.value)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  leadController.messagePicPath.value = '';
                                  leadController.pickedFile.value = File('');
                                  attachment = File('');
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
                        controller: leadController.messageTextEditingController,
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
                        if (leadController
                                .messageTextEditingController.text.isNotEmpty ||
                            attachment.path.isNotEmpty) {
                          String message =
                              leadController.messageTextEditingController.text;
                          await leadController.updateLeadDiscussionChat(
                              message: message,
                              attachment: attachment,
                              leadId: widget.leadId);
                          leadController.messageTextEditingController.clear();
                          leadController.messagePicPath.value = '';
                          leadController.pickedFile.value = File('');
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
          SizedBox(height: 10.h),
          Offstage(
            offstage: !_isEmojiPickerVisible,
            child: EmojiPicker(
              textEditingController:
                  leadController.messageTextEditingController,
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

  Widget getFilePreview(String url) {
    final fileExtension = url.split('.').last.toLowerCase();

    if (["jpg", "jpeg", "png", "gif", "webp"].contains(fileExtension)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11.r),
        child: url.contains('https')
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
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }

  Future<void> showAlertDialog(BuildContext context, String from) async {
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/gallery-icon-removebg-preview.png',
                                height: 20.h,
                                color: whiteColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                color: whiteColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
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
        leadController.pickedFile.value = File(file.path);
        attachment = File(file.path);
        leadController.messagePicPath.value =
            leadController.pickedFile.value.path.toString();
        Get.back();
        print(
            'selected file path from device is ${leadController.pickedFile.value}');
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
      leadController.pickedFile.value = File(pickedImage.path);
      attachment = File(pickedImage.path);
      leadController.messagePicPath.value = pickedImage.path.toString();
    } catch (e) {
      print('Error picking image: $e');
    }
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
