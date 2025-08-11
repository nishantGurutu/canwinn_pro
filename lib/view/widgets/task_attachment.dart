import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class TaskAttachment extends StatelessWidget {
  final dynamic attachment;
  final String? fileName; // Optional, if you want to show file name
  const TaskAttachment(this.attachment, {this.fileName, super.key});

  @override
  Widget build(BuildContext context) {
    String fileUrl = attachment ?? '';
    String fileExtension = '';
    if (fileUrl.isNotEmpty && fileUrl.contains('.')) {
      fileExtension = fileUrl
          .split('.')
          .last
          .toLowerCase();
    }

    Widget filePreview() {
      if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.network(
            fileUrl,
            fit: BoxFit.cover,
            width: 140.w,
            height: 100.h,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 140.w,
                height: 100.h,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                      Icons.broken_image, size: 40.sp, color: Colors.grey),
                ),
              );
            },
          ),
        );
      } else if (fileExtension == 'pdf') {
        return Container(
          width: 140.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 50.sp),
          ),
        );
      } else if (['xls', 'xlsx'].contains(fileExtension)) {
        return Container(
          width: 140.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Icon(Icons.table_chart, color: Colors.green, size: 50.sp),
          ),
        );
      } else {
        return Container(
          width: 140.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Icon(Icons.insert_drive_file, color: Colors.grey.shade700,
                size: 50.sp),
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: InkWell(
        onTap: () {
          openFile(fileUrl, context);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.white,
            //     secondaryColor.withOpacity(0.1),
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 2,
                // offset: Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              filePreview(),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName ?? 'Attachment File',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        fileExtension.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Tap to open',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openFile(String file, BuildContext context) {
    String fileExtension = file
        .split('.')
        .last
        .toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => NetworkImageScreen(file: file));
    } else if (fileExtension == 'pdf') {
      Get.to(() => PDFScreen(file: File(file)));
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }
}
