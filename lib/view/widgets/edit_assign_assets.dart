import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/model/assetsTypeListmode.dart';
import 'package:task_management/model/assets_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';

class EditAssignAssets extends StatefulWidget {
  final String assetsSerialNo;
  final String assetsName;
  final String id;
  final String assignUser;
  final String allocatedDate;
  final String releaseDate;
  const EditAssignAssets({
    super.key,
    required this.assetsSerialNo,
    required this.assetsName,
    required this.id,
    required this.assignUser,
    required this.allocatedDate,
    required this.releaseDate,
  });

  @override
  State<EditAssignAssets> createState() => _EditAssignAssetsState();
}

class _EditAssignAssetsState extends State<EditAssignAssets> {
  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  @override
  initState() {
    // assetsController.text = widget.assetsName;
    // selectUserController.text = widget.assignUser;
    // allocateDateController.text = widget.assignUser;
    super.initState();
  }

  final TextEditingController assetsTypeController = TextEditingController();
  final TextEditingController assetsController = TextEditingController();
  final TextEditingController selectUserController = TextEditingController();
  final TextEditingController allocateDateController = TextEditingController();
  final TextEditingController releaseDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Assign Assets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 45.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: lightBorderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: DropdownMenu<AssetsTypeData>(
                      controller: assetsTypeController,
                      width: double.infinity,
                      trailingIcon: Image.asset(
                        'assets/images/png/Vector 3.png',
                        color: primaryColor,
                        height: 8.h,
                      ),
                      selectedTrailingIcon: Image.asset(
                        'assets/images/png/Vector 3.png',
                        color: primaryColor,
                        height: 8.h,
                      ),
                      menuHeight: 350.h,
                      hintText: "Assets Type",
                      requestFocusOnTap: true,
                      enableSearch: true,
                      enableFilter: true,
                      inputDecorationTheme:
                          InputDecorationTheme(border: InputBorder.none),
                      menuStyle: MenuStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(whiteColor),
                      ),
                      onSelected: (AssetsTypeData? value) async {
                        if (value != null) {
                          profileController.selectedAssetsTypeData.value =
                              value;
                          await profileController.assetsListApi(value.id);
                        }
                      },
                      dropdownMenuEntries: profileController.assetsTypeListData
                          .map<DropdownMenuEntry<AssetsTypeData>>(
                              (AssetsTypeData menu) {
                        return DropdownMenuEntry<AssetsTypeData>(
                          value: menu,
                          label: menu.name ?? '',
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  height: 45.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: lightBorderColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: DropdownMenu<AssetsListData>(
                      controller: assetsController,
                      width: double.infinity,
                      trailingIcon: Image.asset(
                        'assets/images/png/Vector 3.png',
                        color: primaryColor,
                        height: 8.h,
                      ),
                      selectedTrailingIcon: Image.asset(
                        'assets/images/png/Vector 3.png',
                        color: primaryColor,
                        height: 8.h,
                      ),
                      menuHeight: 350.h,
                      hintText: "Select User",
                      requestFocusOnTap: true,
                      enableSearch: true,
                      enableFilter: true,
                      inputDecorationTheme:
                          InputDecorationTheme(border: InputBorder.none),
                      menuStyle: MenuStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(whiteColor),
                      ),
                      onSelected: (AssetsListData? value) async {
                        if (value != null) {
                          profileController.selectedAssetsListData.value =
                              value;
                        }
                      },
                      dropdownMenuEntries: profileController.assetsListData
                          .map<DropdownMenuEntry<AssetsListData>>(
                              (AssetsListData menu) {
                        return DropdownMenuEntry<AssetsListData>(
                          value: menu,
                          label: menu.assetName ?? '',
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: lightBorderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(14.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Obx(
                  () => DropdownMenu<ResponsiblePersonData>(
                    controller: selectUserController,
                    width: double.infinity,
                    trailingIcon: Image.asset(
                      'assets/images/png/Vector 3.png',
                      color: primaryColor,
                      height: 8.h,
                    ),
                    selectedTrailingIcon: Image.asset(
                      'assets/images/png/Vector 3.png',
                      color: primaryColor,
                      height: 8.h,
                    ),
                    menuHeight: 350.h,
                    hintText: "User List",
                    requestFocusOnTap: true,
                    enableSearch: true,
                    enableFilter: true,
                    inputDecorationTheme:
                        InputDecorationTheme(border: InputBorder.none),
                    menuStyle: MenuStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(whiteColor),
                    ),
                    onSelected: (ResponsiblePersonData? value) async {
                      if (value != null) {
                        profileController.selectedUser.value = value;
                      }
                    },
                    dropdownMenuEntries: taskController.responsiblePersonList
                        .map<DropdownMenuEntry<ResponsiblePersonData>>(
                            (ResponsiblePersonData menu) {
                      return DropdownMenuEntry<ResponsiblePersonData>(
                        value: menu,
                        label: menu.name ?? '',
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: CustomCalender(
                    hintText: allocateDate,
                    controller: allocateDateController,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: CustomCalender(
                    hintText: releaseDate,
                    controller: releaseDateController,
                  ),
                ),
              ],
            ),
            CustomButton(
              onPressed: () async {
                // await profileController.editAssignAssets(
                //   assetsType: assetsTypeController.text,
                //   assetsName: assetsController.text,
                //   selectUserController.text,
                //   allocateDateController,
                //   releaseDateController,
                //   widget.id,
                // );
              },
              text: Text(
                submit,
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
          ],
        ),
      ),
    );
  }
}
