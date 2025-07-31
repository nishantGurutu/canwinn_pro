import 'package:flutter/material.dart';

class StartMeetingFromScreens extends StatefulWidget {
  const StartMeetingFromScreens({super.key});

  @override
  State<StartMeetingFromScreens> createState() => _StartMeetingFromScreensState();
}

class _StartMeetingFromScreensState extends State<StartMeetingFromScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Meeting"),
      ),
    );
  }
}
