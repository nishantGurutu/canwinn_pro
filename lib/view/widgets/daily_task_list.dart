
// // ignore_for_file: must_be_immutable
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:task_management/constant/color_constant.dart';
// import 'package:task_management/constant/text_constant.dart';
// import 'package:task_management/view/widgets/add_daily_task.dart';

// class DailyTaskList extends StatelessWidget {
//   DailyTaskList({super.key});

//   final TextEditingController titleTextController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(20.r)),
//       ),
//       width: double.infinity,
//       height: 600.h,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           spacing: 15.h,
//           children: [
//             SizedBox(
//               height: 0.h,
//             ),
//             Row(
//               children: [
//                 Text(
//                   'Daily Task List',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                 ),
//                 Spacer(),
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       builder: (context) => Padding(
//                         padding: EdgeInsets.only(
//                           bottom: MediaQuery.of(context).viewInsets.bottom,
//                         ),
//                         child: AddDailyTask(),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: secondaryColor,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8.r),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.add,
//                             color: whiteColor,
//                           ),
//                           SizedBox(
//                             width: 5.w,
//                           ),
//                           Text(
//                             addTask,
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: whiteColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
