import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/department_list_model.dart';

class DepartmentList extends StatelessWidget {
  DepartmentList({super.key});

  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  final HomeController homeController = Get.find();
  final TextEditingController menuController = TextEditingController();
  final controller = MultiSelectController<DepartmentListData>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      menuController.text =
          profileController.selectedDepartMentListData.value?.name ?? '';
      return Container(
        height: 45.h,
        decoration: BoxDecoration(
          border: Border.all(color: lightBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
          child: Obx(
            () => MultiDropdown<DepartmentListData>(
              items:
                  profileController.departmentDataList
                      .map(
                        (item) => DropdownItem<DepartmentListData>(
                          value: item,
                          label: item.name ?? '',
                        ),
                      )
                      .toList(),
              controller: controller,
              enabled: true,
              searchEnabled: true,
              chipDecoration: ChipDecoration(
                backgroundColor: Colors.white,
                wrap: true,
                runSpacing: 2,
                spacing: 10,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
              ),
              fieldDecoration: FieldDecoration(
                borderRadius: BorderSide.strokeAlignCenter,
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.black87),
                backgroundColor: Colors.white,
                showClearIcon: false,
                border: InputBorder.none,
              ),
              dropdownDecoration: DropdownDecoration(
                marginTop: 2,
                maxHeight: 500.h,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
                header: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Select from list',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedIcon: Icon(Icons.check_box, color: Colors.green),
                disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
              ),
              onSelectionChange: (selectedItems) async {
                homeController.selectedDepartMentListData2.assignAll(
                  selectedItems,
                );
                await homeController.responsiblePersonListApi2(
                  homeController.selectedDepartMentListData2,
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
