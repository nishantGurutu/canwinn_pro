// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:task_management/constant/color_constant.dart';
// import 'package:task_management/constant/style_constant.dart';
// import 'package:task_management/constant/text_constant.dart';
// import 'package:task_management/controller/chat_controller.dart';
// import 'package:task_management/helper/date_helper.dart';
// import 'package:task_management/helper/pusher_config.dart';
// import 'package:task_management/helper/storage_helper.dart';
// import 'package:task_management/model/chat_history_model.dart';

// class MessageScreen extends StatefulWidget {
//   final String? name;
//   final String? chatId;
//   final String? userId;
//   final String? fromPage;
//   const MessageScreen(this.name, this.chatId, this.userId, this.fromPage,
//       {super.key});

//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen> {
//   TextEditingController messageTextEditingController = TextEditingController();
//   final ChatController chatController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     chatController.chatHistoryList.clear();
//     chatController.chatHistoryListApi(widget.chatId);
//     // PusherConfig()
//     //     .initPusher(_onPusherEvent, channelName: "chat", roomId: widget.chatId);
//   }

//   // void _onPusherEvent(PusherEvent event) {
//   //   log("Pusher event received: ${event.eventName} - ${event.data}");
//   //   final eventData = jsonDecode(event.data);
//   //   final newMessage = ChatHistoryModel.fromJson(eventData);
//   //   chatController.chatHistoryList.add(newMessage.data as ChatHistoryData);
//   //   setState(() {});
//   // }

//   // @override
//   // void dispose() {
//   //   PusherConfig().disconnect();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final int loggedInUserId = StorageHelper.getId();
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
//         ),
//         backgroundColor: whiteColor,
//         automaticallyImplyLeading: false,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("${widget.name}", style: rubikBlack),
//             Text("Active", style: rubikSmall),
//           ],
//         ),
//       ),
//       body: Obx(
//         () => Column(
//           children: [
//             chatController.chatHistoryList.isEmpty
//                 // messages.isEmpty
//                 ? Expanded(
//                     child: Center(
//                       child: Text(
//                         noMessage,
//                         style: changeTextColor(robotoBlack, lightGreyColor),
//                       ),
//                     ),
//                   )
//                 : Expanded(
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                       child: SingleChildScrollView(
//                         reverse: true,
//                         child: Column(
//                           children: chatController.chatHistoryList.map((chat) {
//                             final isCurrentUser =
//                                 chat.senderId == loggedInUserId;
//                             return Padding(
//                               padding: EdgeInsets.only(bottom: 12.h),
//                               child: Row(
//                                 mainAxisAlignment: isCurrentUser
//                                     ? MainAxisAlignment.end
//                                     : MainAxisAlignment.start,
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           isCurrentUser
//                                               ? SizedBox()
//                                               : Text(
//                                                   "${chat.senderName ?? ''}",
//                                                   style: TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                   maxLines: 100000,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                           SizedBox(
//                                             height: 3.h,
//                                           ),
//                                           Container(
//                                             constraints: BoxConstraints(
//                                               maxWidth: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.6,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: isCurrentUser
//                                                   ? chatColor
//                                                   : lightGreyColor,
//                                               borderRadius: BorderRadius.only(
//                                                 topLeft: Radius.circular(15.r),
//                                                 topRight: Radius.circular(15.r),
//                                                 bottomLeft: isCurrentUser
//                                                     ? Radius.circular(15.r)
//                                                     : Radius.zero,
//                                                 bottomRight: isCurrentUser
//                                                     ? Radius.zero
//                                                     : Radius.circular(15.r),
//                                               ),
//                                             ),
//                                             child: Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: 10.w,
//                                                   right: 10.h,
//                                                   top: 10.h,
//                                                   bottom: 18.h),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "${chat.message ?? ''}                  ",
//                                                     style: changeTextColor(
//                                                       robotoRegular,
//                                                       isCurrentUser
//                                                           ? whiteColor
//                                                           : Colors.black,
//                                                     ),
//                                                     // maxLines: 0,
//                                                     maxLines: 100000,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Positioned(
//                                         bottom: 3.h,
//                                         right: 7.w,
//                                         child: Text(
//                                           DateConverter.convertTo12HourFormat(
//                                               chat.createdAt ?? ""),
//                                           style: TextStyle(
//                                             color: isCurrentUser
//                                                 ? whiteColor
//                                                 : Colors.black,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: messageTextEditingController,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: InputDecoration(
//                         hintText: writeYourMessage,
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: borderColor),
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: borderColor),
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 8.h, horizontal: 15.w),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   InkWell(
//                     onTap: () {
//                       chatController.sendMessageApi(
//                           widget.userId ?? "",
//                           messageTextEditingController.text,
//                           widget.chatId ?? "",
//                           widget.fromPage);
//                       messageTextEditingController.clear();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10.w),
//                       decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(23.r),
//                       ),
//                       child: Icon(Icons.send, color: whiteColor, size: 20.h),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
