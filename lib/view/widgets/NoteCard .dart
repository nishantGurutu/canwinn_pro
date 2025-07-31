// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// class NoteCard extends StatelessWidget {
//   final Map note;
//   const NoteCard(this.note, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     quill.QuillController? quillController;
//
//     try {
//       final description = note['description'];
//       if (description != null && description.toString().isNotEmpty) {
//         final deltaJson = jsonDecode(description);
//         final delta = quill.Delta.fromJson(deltaJson);
//         final doc = quill.Document.fromDelta(delta);
//         quillController = quill.QuillController(
//           document: doc,
//           selection: const TextSelection.collapsed(offset: 0),
//         );
//       }
//     } catch (e) {
//       debugPrint("Invalid description: $e");
//     }
//
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => NotesDetails(fromNotesData: note));
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           color: whiteColor,
//           borderRadius: BorderRadius.all(Radius.circular(10.r)),
//         ),
//         padding: EdgeInsets.all(10.sp),
//         child: Row(
//           children: [
//             Container(
//               height: 50.h,
//               width: 50.w,
//               decoration: BoxDecoration(
//                 color: whiteColor,
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Image.network(
//                 "${note['attachment']}",
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Padding(
//                     padding: EdgeInsets.all(10.sp),
//                     child: SvgPicture.asset(noImage, fit: BoxFit.cover),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${note['title']}",
//                     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   if (quillController != null)
//                     SizedBox(
//                       height: 40.h,
//                       child: quill.QuillEditor(
//                         controller: quillController,
//                         focusNode: FocusNode(),
//                         scrollController: ScrollController(),
//                         config: quill.QuillEditorConfig(
//                           enableInteractiveSelection: false,
//                           showCursor: false,
//                           readOnly: true,
//                           expands: false,
//                           padding: EdgeInsets.zero,
//                           scrollable: true,
//                         ),
//                       ),
//                     )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
