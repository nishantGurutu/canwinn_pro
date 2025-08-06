import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';

class TaskCustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? data;
  final Widget? prefixIcon;
  final int index;
  GestureTapCallback? onTap;
  final bool? readOnly;
  final ValueNotifier<int?> focusedIndexNotifier;

  TaskCustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.keyboardType,
    required this.controller,
    required this.textCapitalization,
    this.maxLine,
    this.maxLength,
    this.suffixIcon,
    this.obscureText,
    this.data,
    required this.index,
    this.onTap,
    this.readOnly,
    required this.focusedIndexNotifier,
    this.prefixIcon,
  });

  @override
  _TaskCustomTextFieldState createState() => _TaskCustomTextFieldState();
}

class _TaskCustomTextFieldState extends State<TaskCustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.focusedIndexNotifier.value = widget.index;
      } else if (widget.focusedIndexNotifier.value == widget.index) {
        widget.focusedIndexNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: widget.focusedIndexNotifier,
      builder: (context, focusedIndex, child) {
        final bool isFocused = focusedIndex == widget.index;
        return TextFormField(
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          readOnly: widget.readOnly ?? false,
          onTap: widget.onTap,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.obscureText == true ? 1 : widget.maxLine,
          maxLength: widget.maxLength,
          obscureText: widget.obscureText ?? false,
          validator: (value) {
            if (widget.data == "") {
              return null;
            }
            if (value == null || value.isEmpty) {
              return "Please Enter ${widget.data}";
            }
            if (widget.data == "Name") {
              final String namePattern = r'^[a-zA-Z. ]+$';
              final RegExp regex = RegExp(namePattern);
              if (!regex.hasMatch(value)) {
                return "Please Enter a Valid Name";
              }
            }
            if (widget.data == "Email") {
              const String emailPattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              final RegExp regex = RegExp(emailPattern);
              if (!regex.hasMatch(value)) {
                return "Please Enter a Valid Email";
              }
            }
            if (widget.data == "Phone") {
              final String phonePattern = r'^[0-9]+$';
              final RegExp regex = RegExp(phonePattern);
              if (!regex.hasMatch(value) && (widget.data?.length ?? 0) < 10) {
                return "Please Enter a Valid Phone Number";
              }
            }
            if (widget.data == "Name") {
              final String phonePattern = r'^[0-9]+$';
              final RegExp regex = RegExp(phonePattern);
              if (!regex.hasMatch(value)) {
                return "Please Enter a Valid Phone Number";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.suffixIcon,
            fillColor: whiteColor,
            prefixIcon: widget.prefixIcon,
            filled: true,
            labelStyle: TextStyle(
              color: isFocused ? secondaryColor : darkGreyColor,
            ),
            counterText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: lightBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(14.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: lightBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(14.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor),
              borderRadius: BorderRadius.all(Radius.circular(14.r)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          ),
        );
      },
    );
  }
}
