import 'package:flutter/material.dart';
import 'package:task_management/constant/style_constant.dart';

class HomeTitle extends StatelessWidget {
  final String titleText;
  const HomeTitle(this.titleText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: heading15,
    );
  }
}
