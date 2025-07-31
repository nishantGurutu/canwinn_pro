import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class CreateFolder extends StatefulWidget {
  const CreateFolder({super.key});

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  final TextEditingController folderNameTextEditingController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Image.asset(
                backArrowIcon,
              ),
            ),
          ),
        ),
        title: Text(
          createFolder,
          style: rubikBlack,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            CustomTextField(
              hintText: folderName,
              keyboardType: TextInputType.emailAddress,
              controller: folderNameTextEditingController,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 50.h),
            CustomButton(
              onPressed: () {
                final folderName = folderNameTextEditingController.text.trim();
                if (folderName.isNotEmpty) {
                  Get.back(result: folderName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Folder name cannot be empty')),
                  );
                }
              },
              text: Text(create,
                  style: changeTextColor(mediumSizeText, whiteColor)),
              width: double.infinity,
              color: primaryColor,
              height: 45.h,
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
