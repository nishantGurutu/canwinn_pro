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
  // final controller = MultiSelectController<DepartmentListData>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          profileController.isdepartmentListLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  border: Border.all(color: lightBorderColor),
                ),
                child: MultiDropdown<DepartmentListData>(
                  fieldDecoration: FieldDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                  ),

                  items:
                      profileController.departmentDataList
                          .map(
                            (item) => DropdownItem<DepartmentListData>(
                              value: item,
                              label: item.name ?? '',
                            ),
                          )
                          .toList(),
                  controller: MultiSelectController<DepartmentListData>(),
                  enabled: true,
                  searchEnabled: true,
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
    );
  }
}
