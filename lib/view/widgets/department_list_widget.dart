import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/department_list_model.dart';

class DepartmentList extends StatelessWidget {
  DepartmentList({super.key});

  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  final TextEditingController menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        menuController.text =
            profileController.selectedDepartMentListData.value?.name ?? '';

        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(color: lightBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(14.r),
            ),
          ),
          child: DropdownMenu<DepartmentListData>(
            controller: menuController,
            width: double.infinity,
            trailingIcon: Image.asset(
              'assets/images/png/Vector 3.png',
              color: secondaryColor,
              height: 8.h,
            ),
            selectedTrailingIcon: Image.asset(
              'assets/images/png/Vector 3.png',
              color: secondaryColor,
              height: 8.h,
            ),
            menuHeight: 350.h,
            hintText: "Select Department",
            requestFocusOnTap: true,
            enableSearch: true,
            enableFilter: true,
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(14.r),
                ),
              ),
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(whiteColor),
            ),
            initialSelection:
                profileController.selectedDepartMentListData.value,
            onSelected: (DepartmentListData? menu) {
              if (menu != null) {
                profileController.selectedDepartMentListData.value = menu;
                taskController.responsiblePersonListApi(
                    profileController.selectedDepartMentListData.value?.id, "");
              }
            },
            dropdownMenuEntries: profileController.departmentDataList
                .map<DropdownMenuEntry<DepartmentListData>>(
                    (DepartmentListData menu) {
              return DropdownMenuEntry<DepartmentListData>(
                value: menu,
                label: menu.name ?? '',
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
