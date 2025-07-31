import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'image_screen.dart';

class NotesDetails extends StatelessWidget {
  final dynamic fromNotesData;
  const NotesDetails({super.key, required this.fromNotesData});

  @override
  Widget build(BuildContext context) {
    quill.QuillController? quillController;

    try {
      final desc = fromNotesData['description'];
      if (desc != null && desc.toString().isNotEmpty) {
        final deltaJson = jsonDecode(desc);
        final delta = Delta.fromJson(deltaJson);
        final doc = quill.Document.fromDelta(delta);
        quillController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } catch (e) {
      debugPrint("Invalid description: $e");
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          'Note Details',
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "${fromNotesData['title'] ?? 'No Title'}",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: (){ openFile(fromNotesData['attachment'] ?? '');},
                child: Image.network(
                  "${fromNotesData['attachment'] ?? ''}",
                  height: 250.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: SvgPicture.asset(noImage, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),

              // Safely render the description
              if (quillController != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 50.h,
                          maxHeight: 300.h,
                        ),
                        child: quill.QuillEditor(
                          controller: quillController!,
                          focusNode: FocusNode(),
                          scrollController: ScrollController(),
                          config: quill.QuillEditorConfig(
                            enableInteractiveSelection: false,
                            showCursor: false,
                            expands: false,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    );
                  },
                ),

              SizedBox(height: 10.h),
              Text(
                _formatDate(fromNotesData['created_at']),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yy').format(date);
    } catch (e) {
      return '';
    }
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Unsupported file type.')),
      // );
    }
  }
}
