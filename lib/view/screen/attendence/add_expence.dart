import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/expense_controller.dart';
import 'package:task_management/custom_widget/customExpensetextfiel.dart';
import 'package:task_management/model/expensetype_list_model.dart';
import 'package:task_management/view/screen/attendence/widget/custom_expense_calender.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController billNumberTextController =
      TextEditingController();
  final Rx<TextEditingController> expenseTypeTextController =
      TextEditingController().obs;
  final TextEditingController expenseDateTextController =
      TextEditingController();
  final TextEditingController amountTextController = TextEditingController();
  final TextEditingController descriptionTextController =
      TextEditingController();
  final ExpenseController expenseController = Get.put(ExpenseController());
  String currentPath = "";
  @override
  initState() {
    expenseController.expenseTypeListApi(from: "", expenseIdType: '');
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    expenseController.selectedIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBlueColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          addExpense,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: lightBlueColor,
      body: Obx(
        () => expenseController.isExpenseTypeListLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Select expense type',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Obx(
                        () => CustomExpanseTextField(
                          controller: expenseTypeTextController.value,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.emailAddress,
                          data: 'Expense type',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: 'Select expense type',
                          readOnly: true,
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: showTypeBottomSheet(context,
                                    expenseController.expenseTypeListData),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Expanse Date',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomExpenseCalender(
                        hintText: dateFormate,
                        controller: expenseDateTextController,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Bill Number',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomExpanseTextField(
                        controller: billNumberTextController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        data: 'Bill no.',
                        hintText: 'Enter',
                        enable: true,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomExpanseTextField(
                        controller: amountTextController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        data: 'Amount',
                        hintText: 'Enter',
                        enable: true,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomExpanseTextField(
                        controller: descriptionTextController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter',
                        data: 'Description',
                        enable: true,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: lightBorderColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Proofs | Max Size: 5 MB per proof',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              InkWell(
                                onTap: () {
                                  // uploadFile();
                                  showAlertDialog(context);
                                },
                                child: DottedBorder(
                                  color: Colors.grey,
                                  strokeWidth: 1,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(8.r),
                                  dashPattern: [6, 3],
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add,
                                            size: 20.sp, color: Colors.grey),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Upload Single or Multiple Proofs',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '(Only Pdf, JPEG and JPG formats are supported)\nMax Size: 5 MB per proof',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundGreyColor,
                                border: Border.all(color: lightBorderColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 7.h),
                                child: Center(
                                  child: Text(
                                    'Save as Draft',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (expenseController.isExpenseAdding.value ==
                                    false) {
                                  expenseController.addExpense(
                                    expenseTypeTextController.value.text,
                                    billNumberTextController.text,
                                    amountTextController.text,
                                    descriptionTextController.text,
                                    expenseDateTextController.text,
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundGreyColor,
                                  border: Border.all(color: lightBorderColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7.h),
                                  child: Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  final ImagePicker imagePicker = ImagePicker();
  Future<void> takeAttachment(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }

      expenseController.pickedFile.value = File(pickedImage.path);
      Get.back();
    } catch (e) {
    } finally {}
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
        expenseController.pickedFile.value = File(file.path);
        print(
            'selected file path from device is ${expenseController.pickedFile.value}');
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

  Widget showTypeBottomSheet(
    BuildContext context,
    RxList<ExpenseListData> expenseTypeListData,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        ),
      ),
      width: double.infinity,
      height: 170.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Select expense type',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenseTypeListData.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: InkWell(
                            onTap: () {
                              expenseController.selectedIndex.value = index;
                              expenseController.selectedExpenseListData.value =
                                  expenseTypeListData[index];
                              expenseTypeTextController.value.text =
                                  expenseTypeListData[index].name.toString();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      expenseController.selectedIndex.value ==
                                              index
                                          ? blueColor
                                          : lightBorderColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                                child: Row(
                                  children: [
                                    expenseController.selectedIndex.value ==
                                            index
                                        ? Container(
                                            height: 20.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r),
                                                ),
                                                color: blueColor),
                                            child: Center(
                                              child: Icon(
                                                Icons.done,
                                                color: whiteColor,
                                                size: 14.h,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      '${expenseController.expenseTypeListData[index].name}',
                                      style: TextStyle(
                                        color: expenseController
                                                    .selectedIndex.value ==
                                                index
                                            ? blueColor
                                            : textColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
            Positioned(
              right: -5.w,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.close,
                  size: 25.h,
                ),
              ),
            ),
          ],
        ),
      ),
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
                          takeAttachment(ImageSource.camera);
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
}
