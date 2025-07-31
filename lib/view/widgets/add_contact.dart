import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/task_details_model.dart';

class AddContactIntask extends StatefulWidget {
  const AddContactIntask({super.key});

  @override
  State<AddContactIntask> createState() => _AddContactIntaskState();
}

class _AddContactIntaskState extends State<AddContactIntask> {
  final TextEditingController nameControlelr = TextEditingController();
  final TextEditingController emailControlelr = TextEditingController();
  final TextEditingController mobileControlelr = TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TaskController taskController = Get.find();
  void clearFormFields() {
    nameControlelr.clear();
    emailControlelr.clear();
    mobileControlelr.clear();
  }

  Future<void> addContact() async {
    if (nameControlelr.text.isNotEmpty ||
        emailControlelr.text.isNotEmpty ||
        mobileControlelr.text.isNotEmpty) {
      taskController.addTaskContactList.add(
        ContactsData(
          name: nameControlelr.text.trim(),
          email: emailControlelr.text.trim(),
          mobile: mobileControlelr.text.trim(),
        ),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 250.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Add Contact',
                      style: heading6,
                    ),
                    // SizedBox(
                    //   width: 20.w,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     clearFormFields();
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.add,
                    //         color: chatColor,
                    //       ),
                    //       SizedBox(
                    //         width: 3.w,
                    //       ),
                    //       Text(
                    //         'Add More',
                    //         style: changeTextColor(heading8, chatColor),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TaskCustomTextField(
                            controller: nameControlelr,
                            textCapitalization: TextCapitalization.sentences,
                            data: name,
                            hintText: name,
                            labelText: name,
                            index: 0,
                            focusedIndexNotifier: focusedIndexNotifier,
                          ),
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Expanded(
                          child: TaskCustomTextField(
                            controller: mobileControlelr,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            data: mobileNumber,
                            hintText: mobileNumber,
                            labelText: mobileNumber,
                            index: 1,
                            focusedIndexNotifier: focusedIndexNotifier,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TaskCustomTextField(
                      controller: emailControlelr,
                      textCapitalization: TextCapitalization.none,
                      data: email,
                      hintText: email,
                      labelText: email,
                      index: 2,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  onPressed: () async {
                    await addContact();
                  },
                  text: Text(
                    "Add Contact",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  width: double.infinity,
                  color: primaryColor,
                  height: 45.h,
                ),
              ],
            ),
            Positioned(
              top: 1.h,
              right: 5.w,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  child: Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
