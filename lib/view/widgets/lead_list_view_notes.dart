import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/model/LeadNoteModel.dart';
import 'package:task_management/view/notes/lead_notes.dart'
    show EditorController;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';

class LeadListViewNotes extends StatelessWidget {
  final RxList<LeadNoteData> leadNotesData;
  final EditorController editorController = Get.put(EditorController());
  LeadListViewNotes(this.leadNotesData, {super.key});
  final LeadController notesController = Get.find();
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(noteDay).inDays;

    if (diff == 0) return 'Today';
    if (diff <= 7) return '$diff days ago';
    return '${date.day} ${_monthName(date.month)} ${date.year % 100}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: leadNotesData.length,
        itemBuilder: (context, index) {
          quill.QuillController? quillController;

          try {
            final description = leadNotesData[index].description;
            if (description != null && description.toString().isNotEmpty) {
              final deltaJson = jsonDecode(description);
              final delta = Delta.fromJson(deltaJson);
              final doc = quill.Document.fromDelta(delta);
              quillController = quill.QuillController(
                document: doc,
                selection: const TextSelection.collapsed(offset: 0),
              );
            }
          } catch (e) {
            // debugPrint("Invalid description at index $index: $e");
          }
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Image.network(
                          "${leadNotesData[index].attachments ?? ""}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Padding(
                              padding: EdgeInsets.all(10.sp),
                              child:
                                  SvgPicture.asset(noImage, fit: BoxFit.cover),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${leadNotesData[index].title ?? ""}",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (quillController != null)
                              quill.QuillEditor(
                                controller: quillController,
                                focusNode: FocusNode(),
                                scrollController: ScrollController(),
                                config: quill.QuillEditorConfig(
                                  enableInteractiveSelection: false,
                                  showCursor: false,
                                  expands: false,
                                  padding: EdgeInsets.zero,
                                  scrollable: true,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 17.w,
                top: 12.h,
                child: GestureDetector(
                  onTap: () {
                    notesController.pinNote(leadNotesData[index].id);
                  },
                  child: Container(
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: buttonRedColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.r),
                      ),
                    ),
                    child: Center(
                        child: SvgPicture.asset('assets/image/svg/keep.svg')),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
