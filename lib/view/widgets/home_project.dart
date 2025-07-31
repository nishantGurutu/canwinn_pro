// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:task_management/constant/color_constant.dart';
// import 'package:task_management/constant/style_constant.dart';
// import 'package:task_management/controller/task_controller.dart';
// import 'package:task_management/view/screen/task_details.dart';
// import 'package:task_management/view/widgets/home_title.dart';

// class HomeProject extends StatelessWidget {
//   final RxList homeProjectList;
//   final TaskController taskController;
//   const HomeProject(this.homeProjectList, this.taskController, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             HomeTitle('Projects'),
//           ],
//         ),
//         SizedBox(
//           height: 10.h,
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(14.r),
//           child: Container(
//             height: 300.h,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14.r),
//               border: Border.all(color: boxBorderColor),
//               color: whiteColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: lightGreyColor.withOpacity(0.1),
//                   blurRadius: 13.0,
//                   spreadRadius: 2,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: homeProjectList.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Get.to(() => TaskDetails(
//                                   taskId: homeProjectList[index]['id'],
//                                   assignedStatus: taskController
//                                       .selectedAssignedTask.value));
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.w),
//                               child: Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   homeProjectList[index]['title'] ?? "",
//                                   textAlign: TextAlign.left,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(fontSize: 14.sp),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if ((data?.assignedUsers?.length ?? 0) > 0)
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   showModalBottomSheet(
//                                     context: context,
//                                     isScrollControlled: true,
//                                     builder: (context) => Padding(
//                                       padding: EdgeInsets.only(
//                                           bottom: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom),
//                                       child: TaskDetailsUserList(
//                                           data?.assignedUsersList ?? [],
//                                           "Assigned"),
//                                     ),
//                                   );
//                                 },
//                                 child: SizedBox(
//                                   width: 100.w,
//                                   height: 30.h,
//                                   child: Stack(
//                                     children: List.generate(
//                                       (data?.assignedUsersList?.length ?? 0) > 3
//                                           ? 4
//                                           : (data?.assignedUsersList?.length ??
//                                               0),
//                                       (index) {
//                                         if (index < 3) {
//                                           final leftPosition = index == 0
//                                               ? 0.0
//                                               : (index == 1 ? 22.w : 44.w);
//                                           final bgColor = index == 0
//                                               ? redColor
//                                               : index == 1
//                                                   ? blueColor
//                                                   : secondaryColor;

//                                           return Positioned(
//                                             left: leftPosition,
//                                             child: Container(
//                                               height: 30.h,
//                                               width: 30.w,
//                                               decoration: BoxDecoration(
//                                                 color: backgroundColor,
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(15.r)),
//                                               ),
//                                               child: ClipRRect(
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(15.r)),
//                                                 child: Image.network(
//                                                   '${data?.assignedUsersList?[index].image ?? ""}',
//                                                   fit: BoxFit.cover,
//                                                   errorBuilder: (context, error,
//                                                       stackTrace) {
//                                                     return Container(
//                                                       height: 30.h,
//                                                       width: 30.w,
//                                                       decoration: BoxDecoration(
//                                                         color: backgroundColor,
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                                 Radius.circular(
//                                                                     15.r)),
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         } else {
//                                           final extraCount = (data
//                                                       ?.assignedUsersList
//                                                       ?.length ??
//                                                   0) -
//                                               3;
//                                           return Positioned(
//                                             left: 65.w,
//                                             child: Container(
//                                               height: 30.h,
//                                               width: 30.w,
//                                               decoration: BoxDecoration(
//                                                 color: primaryButtonColor,
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(15.r)),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   '+$extraCount',
//                                                   style: changeTextColor(
//                                                       heading9, whiteColor),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           Divider(
//                             thickness: 0.5,
//                             color: lightBorderColor,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
