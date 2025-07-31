// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// class UnreadNotification extends StatefulWidget {
//   const UnreadNotification({super.key});

//   @override
//   State<UnreadNotification> createState() => _UnreadNotificationState();
// }

// class _UnreadNotificationState extends State<UnreadNotification> {

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.separated(
//         controller: _scrollController,
//         itemCount: notificationController.notificationList.length + 1,
//         itemBuilder: (context, index) {
//           if (index == notificationController.notificationList.length) {
//             return Obx(
//               () => notificationController.isScrolling.value
//                   ? Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Center(
//                         child: SizedBox(
//                           width: 30,
//                           height: 30,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       ),
//                     )
//                   : SizedBox.shrink(),
//             );
//           }
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
//             child: InkWell(
//               onTap: () async {
//                 await showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) => Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: viewNotification(context,
//                         notificationController.notificationList[index]),
//                   ),
//                 );
//                 await notificationController.readNotification(
//                     notificationController.notificationList[index]["id"]);
//               },
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: whiteColor,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10.r),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: lightGreyColor.withOpacity(0.2),
//                       blurRadius: 13.0,
//                       spreadRadius: 2,
//                       blurStyle: BlurStyle.normal,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 45.h,
//                         width: 45.w,
//                         decoration: BoxDecoration(
//                           color: lightGreyColor,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(25.r),
//                           ),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.notifications,
//                             color: whiteColor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 8.w,
//                       ),
//                       Container(
//                         width: 262.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: 240.w,
//                                   child: Text(
//                                     "${notificationController.notificationList[index]['title'] ?? ""}",
//                                     style: rubikBold,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 SizedBox(
//                                   height: 20.h,
//                                   width: 20.w,
//                                   child: Obx(
//                                     () => Checkbox(
//                                       value: notificationController
//                                           .notificationSelectList[index],
//                                       onChanged: (value) {
//                                         notificationController
//                                                 .notificationSelectList[index] =
//                                             value!;

//                                         if (value) {
//                                           notificationController
//                                               .notificationSelectidList
//                                               .add(
//                                             notificationController
//                                                 .notificationList[index]['id']
//                                                 .toString(),
//                                           );
//                                           notificationController
//                                               .notificationSelectTypeList
//                                               .add(
//                                             notificationController
//                                                 .notificationList[index]['type']
//                                                 .toString(),
//                                           );
//                                         } else {
//                                           notificationController
//                                               .notificationSelectidList
//                                               .remove(
//                                             notificationController
//                                                 .notificationList[index]['id']
//                                                 .toString(),
//                                           );
//                                           notificationController
//                                               .notificationSelectTypeList
//                                               .remove(
//                                             notificationController
//                                                 .notificationList[index]['type']
//                                                 .toString(),
//                                           );
//                                         }

//                                         notificationController
//                                                 .isAllSelect.value =
//                                             notificationController
//                                                 .notificationSelectList
//                                                 .every(
//                                                     (isSelected) => isSelected);
//                                       },
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 6.h),
//                             Text(
//                               "${notificationController.notificationList[index]['description'] ?? ""}",
//                               style:
//                                   changeTextColor(rubikRegular, subTextColor),
//                             ),
//                             SizedBox(height: 6.h),
//                             Text(
//                               "${notificationController.notificationList[index]['created_at'] ?? ""}",
//                               style: changeTextColor(rubikMedium, subTextColor),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return SizedBox(
//             height: 0.h,
//           );
//         },
//       ),
//     );
//   }
// }
