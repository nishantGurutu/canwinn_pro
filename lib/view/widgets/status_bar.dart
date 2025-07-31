import 'package:flutter/material.dart';
import 'package:task_management/constant/color_constant.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: whiteColor),
    );
  }
}
