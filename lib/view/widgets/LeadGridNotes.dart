import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/model/LeadNoteModel.dart';
import 'package:task_management/view/widgets/note_details.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class LeadGridNotes extends StatelessWidget {
  final RxList<LeadNoteData> leadNotesData;
  const LeadGridNotes(this.leadNotesData, {super.key});

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
    Map<String, List> groupedNotes = {};
    for (var note in leadNotesData) {
      final createdAt =
          DateTime.tryParse(note.createdAt ?? '') ?? DateTime.now();
      final formatted = formatDate(createdAt);
      groupedNotes.putIfAbsent(formatted, () => []).add(note);
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: leadNotesData.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.sp,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
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
                debugPrint("Invalid description at index $index: $e");
              }

              return GestureDetector(
                onTap: () {
                  Get.to(
                      () => NotesDetails(fromNotesData: leadNotesData[index]));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),
                      SizedBox(
                        height: 70.h,
                        width: 80.w,
                        child: Image.network(
                          "${leadNotesData[index].attachments}",
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            Text(
                              "${leadNotesData[index].title}",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (quillController != null)
                              quill.QuillEditor(
                                controller: quillController,
                                focusNode: FocusNode(),
                                scrollController: ScrollController(),
                                config: quill.QuillEditorConfig(
                                  maxContentWidth: 90,
                                  enableInteractiveSelection: false,
                                  showCursor: false,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
