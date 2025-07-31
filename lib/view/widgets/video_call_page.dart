// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:task_management/constant/color_constant.dart';
// import 'package:task_management/constant/text_constant.dart';
// import 'package:task_management/controller/meeting_controller.dart';
// import 'package:task_management/custom_widget/button_widget.dart';
// import 'package:task_management/custom_widget/task_text_field.dart';
// import 'package:task_management/helper/storage_helper.dart';
// import 'package:zego_uikit/zego_uikit.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class JoinPage extends StatefulWidget {
//   final int? meetingId;
//   final String token;

//   const JoinPage({super.key, this.meetingId, required this.token});

//   @override
//   State<JoinPage> createState() => _JoinPageState();
// }

// class _JoinPageState extends State<JoinPage> {
//   final MeetingController meetingController = Get.put(MeetingController());

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }

//   Future<void> _requestPermissions() async {
//     var micStatus = await Permission.microphone.request();
//     var cameraStatus = await Permission.camera.request();

//     if (!micStatus.isGranted || !cameraStatus.isGranted) {
//       print("❌ Permissions not granted");
//     } else {
//       print("✅ Permissions granted");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: 1561983867,
//         appSign:
//             'a76d986af585b0efca9cf192f243c72556ee5d5ad4ee93db8f5be24bb1062669',
//         userID: StorageHelper.getId().toString(),
//         userName: StorageHelper.getName(),
//         callID: widget.meetingId.toString(),
//         token: widget.token,
//         config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//           ..turnOnMicrophoneWhenJoining = true
//           ..turnOnCameraWhenJoining = true
//           ..useSpeakerWhenJoining = true
//           ..useSpeakerWhenJoining = true
//           ..audioVideoView = ZegoCallAudioVideoViewConfig(
//             showSoundWavesInAudioMode: true,
//           )
//           ..layout = ZegoLayout.gallery(
//             margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//           )
//           ..topMenuBar.buttons = [
//             ZegoCallMenuBarButtonName.minimizingButton,
//             ZegoCallMenuBarButtonName.showMemberListButton,
//           ]
//           ..bottomMenuBar.buttons = [
//             ZegoCallMenuBarButtonName.toggleCameraButton,
//             ZegoCallMenuBarButtonName.switchAudioOutputButton,
//             ZegoCallMenuBarButtonName.hangUpButton,
//             ZegoCallMenuBarButtonName.toggleScreenSharingButton,
//             ZegoCallMenuBarButtonName.chatButton,
//             ZegoCallMenuBarButtonName.switchCameraButton,
//             ZegoCallMenuBarButtonName.toggleMicrophoneButton,
//           ],
//         events: ZegoUIKitPrebuiltCallEvents(
//           onCallEnd: (event, defaultAction) {
//             Get.back();
//             selectAttachmentDialog(context, widget.meetingId);
//           },
//           audioVideo: ZegoCallAudioVideoEvents(
//             onMicrophoneStateChanged: (state) {
//               print('🎙️ Microphone state changed: $state');
//             },
//           ),
//           user: ZegoCallUserEvents(
//             onEnter: (p0) {
//               print('enter user skjdh8e $p0');
//               meetingController.attendMeeting(context,
//                   meetingId: widget.meetingId, status: 0);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
//   final TextEditingController momTextController = TextEditingController();
//   Future<void> selectAttachmentDialog(
//     BuildContext context,
//     int? meetingId,
//   ) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext builderContext) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: EdgeInsets.all(10.sp),
//           child: Container(
//             width: double.infinity,
//             height: 200.h,
//             decoration: BoxDecoration(
//               color: whiteColor,
//               borderRadius: BorderRadius.circular(15.r),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TaskCustomTextField(
//                     controller: momTextController,
//                     textCapitalization: TextCapitalization.sentences,
//                     data: "mom",
//                     hintText: "Enter MOM",
//                     labelText: "Enter MOM",
//                     index: 0,
//                     maxLine: 4,
//                     focusedIndexNotifier: focusedIndexNotifier,
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                   CustomButton(
//                     onPressed: () {
//                       if (meetingController.isMomLoading.value == false) {
//                         meetingController.meetingMom(
//                             momTextController.text, meetingId);
//                       }
//                     },
//                     text: Text(
//                       submit,
//                       style: TextStyle(
//                         color: whiteColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     width: double.infinity,
//                     color: primaryColor,
//                     height: 45.h,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
