import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlarmBellScreen extends StatefulWidget {
  const AlarmBellScreen({super.key});

  @override
  State<AlarmBellScreen> createState() => _AlarmBellScreenState();
}

class _AlarmBellScreenState extends State<AlarmBellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
