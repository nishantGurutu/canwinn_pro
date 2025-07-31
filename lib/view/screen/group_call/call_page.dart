// import 'package:flutter/material.dart';
// import 'package:task_management/view/screen/group_call/group_constant.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class CallPage extends StatefulWidget {
//   const CallPage({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => CallPageState();
// }

// class CallPageState extends State<CallPage> {
//   @override
//   Widget build(BuildContext context) {
//     final arguments = (ModalRoute.of(context)?.settings.arguments ??
//         <String, String>{}) as Map<String, String>;
//     final callID = arguments[PageParam.call_id] ?? '';

//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: 422763624,
//         appSign:
//             'a523374d9db23c9bab986a12e0f6c58cd6c0883d188ecf56dbd237d5fe9ab79c',
//         userID: currentUser.id,
//         userName: currentUser.name,
//         callID: callID,
//         config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//           ..avatarBuilder
//           ..topMenuBar.isVisible = true
//           ..topMenuBar.buttons = [
//             ZegoCallMenuBarButtonName.minimizingButton,
//             ZegoCallMenuBarButtonName.showMemberListButton,
//           ],
//       ),
//     );
//   }
// }
