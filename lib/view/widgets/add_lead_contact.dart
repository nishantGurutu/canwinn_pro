import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';

class AddLeadContactShet extends StatefulWidget {
  final dynamic leadId;
  const AddLeadContactShet({super.key, required this.leadId});

  @override
  State<AddLeadContactShet> createState() => _AddLeadContactShetState();
}

class _AddLeadContactShetState extends State<AddLeadContactShet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final LeadController taskController = Get.find();
  void clearFormFields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    designationController.clear();
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
      height: 300.h,
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
                            controller: nameController,
                            textCapitalization: TextCapitalization.sentences,
                            data: "Name",
                            hintText: "Name",
                            labelText: "Name",
                            index: 0,
                            focusedIndexNotifier: focusedIndexNotifier,
                          ),
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Expanded(
                          child: TaskCustomTextField(
                            controller: phoneController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            data: "Phone",
                            hintText: "Phone",
                            labelText: "Phone",
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
                      controller: emailController,
                      textCapitalization: TextCapitalization.none,
                      data: "Email",
                      hintText: "Email",
                      labelText: "Email",
                      index: 2,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TaskCustomTextField(
                      controller: designationController,
                      textCapitalization: TextCapitalization.none,
                      data: "Designation",
                      hintText: "Designation",
                      labelText: "Designation",
                      index: 3,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  onPressed: () async {
                    await taskController.addContact(
                        leadId: widget.leadId,
                        name: nameController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                        designation: designationController.text);
                    clearFormFields();
                  },
                  text: Text(
                    "Add",
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
