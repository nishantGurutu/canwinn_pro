import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String hintText;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.itemLabel,
    this.selectedValue,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  Rx<T?> selectedValue = Rx<T?>(null);
  RxString errorText = ''.obs;

  @override
  void initState() {
    super.initState();
    selectedValue.value = widget.selectedValue;
  }

  void validateDropdown() {
    if (selectedValue.value == null) {
      errorText.value = "Please select a value";
    } else {
      errorText.value = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedValue.value = null;
    return DropdownButtonHideUnderline(
      child: Obx(
        () => DropdownButton2<T>(
          isExpanded: true,
          hint: Text(
            widget.hintText,
            style: changeTextColor(rubikRegular, darkGreyColor),
            overflow: TextOverflow.ellipsis,
          ),
          items: widget.items
              .map(
                (T item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    widget.itemLabel(item),
                    style: changeTextColor(rubikRegular, Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          value: selectedValue.value,
          onChanged: (T? value) {
            selectedValue.value = value;
            widget.onChanged(value);
            validateDropdown();
          },
          buttonStyleData: ButtonStyleData(
            height: 45.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
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
            width: 325.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: whiteColor,
              border: Border.all(color: lightBorderColor),
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all<double>(6),
              thumbVisibility: WidgetStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 40.h,
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
          ),
        ),
      ),
    );
  }
}
