import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/responsible_person_list_model.dart';

class UesrListWidget extends StatelessWidget {
  UesrListWidget({super.key});

  final TaskController taskController = Get.find();
  final TextEditingController menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        menuController.text =
            taskController.selectedResponsiblePersonData.value?.name ?? '';

        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: lightSecondaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: DropdownMenu<ResponsiblePersonData>(
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
              hintText: "Select Person",
              requestFocusOnTap: true,
              enableSearch: true,
              enableFilter: true,
              inputDecorationTheme:
                  InputDecorationTheme(border: InputBorder.none),
              menuStyle: MenuStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(lightSecondaryColor),
              ),
              initialSelection:
                  taskController.selectedResponsiblePersonData.value,
              onSelected: (ResponsiblePersonData? menu) {
                if (menu != null) {
                  taskController.selectedResponsiblePersonData.value = menu;
                  if (taskController.assignedUserId.contains(taskController
                      .selectedResponsiblePersonData.value?.id
                      .toString())) {
                    taskController.assignedUserId.remove(taskController
                        .selectedResponsiblePersonData.value?.id
                        .toString());
                  } else {
                    taskController.assignedUserId.add((taskController
                            .selectedResponsiblePersonData.value?.id
                            .toString()) ??
                        "");
                  }
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
        );
      },
    );
  }
}
