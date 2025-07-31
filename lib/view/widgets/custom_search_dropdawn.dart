import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_management/constant/color_constant.dart';

class CustomMultiDropdown<T extends Object> extends StatelessWidget {
  final List<DropdownItem<T>> items;
  final MultiSelectController<T> controller;
  final String hintText;
  final void Function(List<T> selectedItems) onSelectionChange;
  final bool isEnabled;
  final String? headerText;
  final bool isDepartmentSelected;

  const CustomMultiDropdown({
    Key? key,
    required this.items,
    required this.controller,
    required this.hintText,
    required this.onSelectionChange,
    this.isEnabled = true,
    this.headerText,
    this.isDepartmentSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lightBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
        child: MultiDropdown<T>(
          items: items,
          controller: controller,
          enabled: isEnabled,
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
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black87),
            backgroundColor: Colors.white,
            showClearIcon: false,
            border: InputBorder.none,
          ),
          dropdownDecoration: DropdownDecoration(
            marginTop: 2,
            maxHeight: 500,
            borderRadius: BorderRadius.all(Radius.circular(14.r)),
            header: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                headerText ?? 'Select from list',
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
          onSelectionChange: (selectedItems) {
            // if (isDepartmentSelected) {
            onSelectionChange(selectedItems);
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("Select department first")),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
