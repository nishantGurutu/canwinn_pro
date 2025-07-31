import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/data/model/visit_type_list.dart';

class AddVisitScreen extends StatefulWidget {
  final dynamic leadId;
  const AddVisitScreen({super.key, required this.leadId});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final LeadController leadController = Get.find();

  @override
  void initState() {
    leadController.listVisitTypeApi();
    super.initState();
  }

  @override
  void dispose() {
    leadController.selectedVisitTypeListData.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF000000),
            size: 20,
          ),
        ),
        title: const Text(
          "Create Visit",
          style: TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Obx(
        () => leadController.isListVisitTypeLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Visit types",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton2<VisitTypeData>(
                              isExpanded: true,
                              items: leadController
                                      .leadVisitTypeListData.isEmpty
                                  ? null
                                  : leadController.leadVisitTypeListData
                                      .map((VisitTypeData item) {
                                      return DropdownMenuItem<VisitTypeData>(
                                        value: item,
                                        child: Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Roboto',
                                            color: darkGreyColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                              value: leadController
                                  .selectedVisitTypeListData.value,
                              onChanged: (VisitTypeData? value) {
                                if (value != null) {
                                  leadController
                                      .selectedVisitTypeListData.value = value;
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: lightBorderColor),
                                  color: whiteColor,
                                ),
                              ),
                              hint: Text(
                                "Select visit type".tr,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Roboto',
                                  color: darkGreyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                iconSize: 14,
                                iconEnabledColor: lightGreyColor,
                                iconDisabledColor: lightGreyColor,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200.h,
                                width: 330.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    color: whiteColor,
                                    border:
                                        Border.all(color: lightBorderColor)),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Visitor Name",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'name',
                          hintText: 'Name',
                          labelText: 'Name',
                          index: 4,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Visitor Phone",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: phoneController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          data: 'phone',
                          hintText: 'Phone',
                          labelText: 'Phone',
                          index: 1,
                          maxLength: 10,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Visitor email",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: emailController,
                          textCapitalization: TextCapitalization.none,
                          data: 'Email',
                          hintText: 'Email',
                          labelText: 'Email',
                          index: 2,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Visit address",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: addressController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'address',
                          hintText: 'Address',
                          labelText: 'Address',
                          index: 3,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Visit description",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TaskCustomTextField(
                          controller: descriptionController,
                          textCapitalization: TextCapitalization.sentences,
                          data: 'description',
                          hintText: 'Description',
                          labelText: 'Description',
                          index: 4,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              leadController.addVisit(
                                nameController: nameController.text,
                                phoneController: phoneController.text,
                                emailController: emailController.text,
                                addressController: addressController.text,
                                descriptionController:
                                    descriptionController.text,
                                visitType: leadController
                                    .selectedVisitTypeListData.value,
                                leadId: widget.leadId,
                              );
                            }
                          },
                          text: Text(
                            create,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          width: double.infinity,
                          color: primaryColor,
                          height: 45.h,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
