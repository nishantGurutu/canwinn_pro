import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart'
    show
        ButtonStyleData,
        DropdownButton2,
        DropdownStyleData,
        IconStyleData,
        MenuItemStyleData;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/human_gatepass_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/customExpensetextfiel.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final EmployeeFormController controller = Get.put(EmployeeFormController());
  final TextEditingController empNameTextController = TextEditingController();
  final TextEditingController empIdTextController = TextEditingController();
  final TextEditingController contactNumberTextController =
      TextEditingController();
  final TextEditingController purposeOfVisitingTextController =
      TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();
  final TextEditingController destinationTextController =
      TextEditingController();
  final TextEditingController transportModeTextController =
      TextEditingController();
  final TextEditingController outTimeTextController = TextEditingController();
  final TextEditingController returnTimeTextController =
      TextEditingController();
  final ProfileController profileController = Get.find();
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep3 = GlobalKey<FormState>();

  @override
  void initState() {
    empNameTextController.text = StorageHelper.getName();
    contactNumberTextController.text = StorageHelper.getPhone();
    profileController.departmentList('');
    super.initState();
  }

  @override
  dispose() {
    empNameTextController.clear();
    empIdTextController.clear();
    contactNumberTextController.clear();
    purposeOfVisitingTextController.clear();
    descriptionTextController.clear();
    destinationTextController.clear();
    transportModeTextController.clear();
    outTimeTextController.clear();
    returnTimeTextController.clear();
    controller.pickedFile.value = File("");
    profileController.selectedDepartMentListData.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create Human Gatepass',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
        ),
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
        backgroundColor: backgroundColor,
      ),
      body: Obx(() => profileController.isdepartmentListLoading.value == true
          ? Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: controller.currentStep.value,
              onStepContinue: () {
                bool isValid = false;
                print('skjdyue 7t73 ${controller.currentStep.value}');
                if (controller.currentStep.value == 0) {
                  isValid = formKeyStep1.currentState!.validate();
                } else if (controller.currentStep.value == 1) {
                  isValid = formKeyStep2.currentState!.validate();
                } else if (controller.currentStep.value == 2) {
                  isValid = formKeyStep3.currentState!.validate();
                }

                if (isValid) {
                  if (profileController.selectedDepartMentListData.value ==
                      null) {
                    CustomToast().showCustomToast('Please select department.');
                    return;
                  }
                  if (controller.currentStep.value == 1) {
                    if (controller.pickedFile.value.path.isEmpty) {
                      CustomToast().showCustomToast('Please select image.');
                      return;
                    }
                  }

                  controller.nextStep(
                    empName: empNameTextController.text,
                    empId: empIdTextController.text,
                    contact: contactNumberTextController.text,
                    purposeOfVisiting: purposeOfVisitingTextController.text,
                    description: descriptionTextController.text,
                    destination: destinationTextController.text,
                    outTime: outTimeTextController.text,
                    returnTime: returnTimeTextController.text,
                    deptId: profileController
                            .selectedDepartMentListData.value?.id ??
                        0,
                    transportMode: transportModeTextController.text,
                  );
                }
              },
              onStepCancel: () {
                controller.backStep();
              },
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    InkWell(
                      onTap: details.onStepContinue,
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            color: primaryButtonColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            controller.currentStep.value == 2 ? "Next" : "Next",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (controller.currentStep.value >= 0)
                      InkWell(
                        onTap: details.onStepCancel,
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                              color: primaryButtonColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: Text(
                    "Employee Details",
                  ),
                  content: Form(
                    key: formKeyStep1,
                    child: Column(
                      spacing: 10.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomExpanseTextField(
                          controller: empNameTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Employee Name',
                          hintText: 'Employee Name',
                          enable: true,
                          readOnly: true,
                        ),
                        CustomExpanseTextField(
                          controller: empIdTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Employee ID',
                          hintText: 'Employee ID',
                          enable: true,
                        ),
                        DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton2<DepartmentListData>(
                              isExpanded: true,
                              hint: Text(
                                selectDepartment,
                                style: changeTextColor(
                                    rubikRegular, darkGreyColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              items: profileController.departmentDataList
                                  .map(
                                    (DepartmentListData item) =>
                                        DropdownMenuItem<DepartmentListData>(
                                      value: item,
                                      child: Text(
                                        item.name ?? '',
                                        style: changeTextColor(
                                            rubikRegular, Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: profileController
                                  .selectedDepartMentListData.value,
                              onChanged: (DepartmentListData? value) {
                                profileController
                                    .selectedDepartMentListData.value = value!;
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 45.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: lightBorderColor),
                                  color: whiteColor,
                                ),
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
                                width: 312.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: whiteColor,
                                    border:
                                        Border.all(color: lightBorderColor)),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                                padding:
                                    EdgeInsets.only(left: 12.w, right: 12.w),
                              ),
                            ),
                          ),
                        ),
                        CustomExpanseTextField(
                          controller: contactNumberTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          data: 'Contact Number',
                          hintText: 'Contact Number',
                          enable: true,
                          readOnly: true,
                        ),
                        SizedBox(
                          height: 8.h,
                        )
                      ],
                    ),
                  ),
                  state: controller.currentStep.value > 0
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: controller.currentStep.value >= 0,
                ),
                Step(
                  title: Text(
                    "Visit Details",
                  ),
                  content: Form(
                    key: formKeyStep2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        CustomExpanseTextField(
                          controller: purposeOfVisitingTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Purpose of Visit',
                          hintText: 'Purpose of Visit',
                          enable: true,
                        ),
                        CustomExpanseTextField(
                          controller: descriptionTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Description / Remarks',
                          hintText: 'Description / Remarks',
                          enable: true,
                        ),
                        CustomExpanseTextField(
                          controller: destinationTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Destination',
                          hintText: 'Destination',
                          enable: true,
                        ),
                        CustomExpanseTextField(
                          controller: transportModeTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Mode of transport',
                          hintText: 'Mode of transport',
                          enable: true,
                        ),
                        SizedBox(height: 10),
                        Text("Photograph Proof"),
                        SizedBox(height: 8),
                        Obx(
                          () => InkWell(
                            onTap: () async {
                              await showAlertDialog(context);
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration:
                                  BoxDecoration(color: Color(0xFFE5E5E5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  controller.pickedFile.value,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  state: controller.currentStep.value > 1
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: controller.currentStep.value >= 1,
                ),
                Step(
                  title: Text("Timing"),
                  content: Form(
                    key: formKeyStep3,
                    child: Column(
                      spacing: 10.h,
                      children: [
                        CustomExpanseTextField(
                          controller: outTimeTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Expected out time',
                          hintText: 'Expected out time',
                          enable: true,
                          readOnly: true,
                          onTap: () {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              currentTime: DateTime.now(),
                              minTime: DateTime.now(),
                              maxTime:
                                  DateTime(DateTime.now().year + 50, 12, 31),
                              onChanged: (date) {
                                print(
                                    'change $date in time zone ${date.timeZoneOffset.inHours}');
                              },
                              onConfirm: (date) {
                                String formattedDate =
                                    DateFormat('MMM dd, yyyy – HH:mm')
                                        .format(date);
                                outTimeTextController.text = formattedDate;
                                print('confirm sdef sedawda $formattedDate');
                              },
                              locale: picker.LocaleType.en,
                            );
                          },
                        ),
                        CustomExpanseTextField(
                          controller: returnTimeTextController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          data: 'Expected return time',
                          hintText: 'Expected return time',
                          enable: true,
                          readOnly: true,
                          onTap: () {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              currentTime: DateTime.now(),
                              minTime: DateTime.now(),
                              maxTime:
                                  DateTime(DateTime.now().year + 50, 12, 31),
                              onChanged: (date) {
                                print(
                                    'change $date in time zone ${date.timeZoneOffset.inHours}');
                              },
                              onConfirm: (date) {
                                String formattedDate =
                                    DateFormat('MMM dd, yyyy – HH:mm')
                                        .format(date);
                                returnTimeTextController.text = formattedDate;
                                print('confirm sdef sedawda $formattedDate');
                              },
                              locale: picker.LocaleType.en,
                            );
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    ),
                  ),
                  state: controller.currentStep.value > 2
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: controller.currentStep.value >= 2,
                ),
              ],
            )),
    );
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          uploadFile();
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/gallery-icon-removebg-preview.png',
                                height: 20.h,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.camera);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  File? pickedFile;
  String fileName = "";
  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        controller.pickedFile.value = File(file.path);
        Get.back();
        print(
            'selected file path from device is ${controller.pickedFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      profileController.isProfilePicUploading.value = true;

      controller.pickedFile.value = File(pickedImage.path);

      profileController.isProfilePicUploading.value = false;
      Get.back();
    } catch (e) {
      profileController.isProfilePicUploading.value = false;
    } finally {
      profileController.isProfilePicUploading.value = false;
    }
  }

  // dateTimePickerWidget(BuildContext context) {
  //   return DatePicker.showDatePicker(
  //     context,
  //     dateFormat: 'dd MMMM yyyy HH:mm',
  //     initialDateTime: DateTime.now(),
  //     minDateTime: DateTime(2000),
  //     maxDateTime: DateTime(3000),
  //     onMonthChangeStartWithFirstDate: true,
  //     onConfirm: (dateTime, List<int> index) {
  //       DateTime selectdate = dateTime;
  //       final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
  //       print(selIOS);
  //     },
  //   );
  // }

  // Future<DateTime?> showDateTimePicker({
  //   required BuildContext context,
  //   DateTime? initialDate,
  //   DateTime? firstDate,
  //   DateTime? lastDate,
  // }) async {
  //   initialDate ??= DateTime.now();
  //   firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  //   lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  //   final DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: firstDate,
  //     lastDate: lastDate,
  //   );

  //   if (selectedDate == null) return null;

  //   if (!context.mounted) return selectedDate;

  //   final TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(initialDate),
  //   );

  //   return selectedTime == null
  //       ? selectedDate
  //       : DateTime(
  //           selectedDate.year,
  //           selectedDate.month,
  //           selectedDate.day,
  //           selectedTime.hour,
  //           selectedTime.minute,
  //         );
  // }
}
