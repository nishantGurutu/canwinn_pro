import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/view/widgets/note_details.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class GridNotes extends StatelessWidget {
  final RxList notesList;
  const GridNotes(this.notesList, {super.key});

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
    // Group notes by formatted date
    Map<String, List> groupedNotes = {};
    for (var note in notesList) {
      final createdAt =
          DateTime.tryParse(note['createdAt'] ?? '') ?? DateTime.now();
      final formatted = formatDate(createdAt);
      groupedNotes.putIfAbsent(formatted, () => []).add(note);
    }

    return Expanded(
      child: ListView(
        children: groupedNotes.entries.map((entry) {
          final notes = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: Text(
                  entry.key,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                itemCount: notes.length,
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
                    final description = notesList[index]['description'];

                    if (description != null &&
                        description.toString().isNotEmpty) {
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
                      Get.to(() => NotesDetails(fromNotesData: notes[index]));
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
                              "${notesList[index]['attachment']}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: SvgPicture.asset(noImage,
                                      fit: BoxFit.cover),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              children: [
                                Text(
                                  "${notesList[index]['title']}",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (quillController != null)
                                  SizedBox(
                                    height: 50.h,
                                    child: quill.QuillEditor(
                                      controller: quillController,
                                      focusNode: FocusNode(),
                                      scrollController: ScrollController(),
                                      config: quill.QuillEditorConfig(
                                        maxContentWidth: 90,
                                        enableInteractiveSelection: false,
                                        showCursor: false,
                                      ),
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
            ],
          );
        }).toList(),
      ),
    );
  }
}
