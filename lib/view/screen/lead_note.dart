import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/view/notes/lead_notes.dart'
    show LeadNoteEditorScreen;
import 'package:task_management/view/widgets/lead_list_view_notes.dart';

class LeadNoteScreen extends StatefulWidget {
  final dynamic leadId;
  const LeadNoteScreen({super.key, required this.leadId, required int index});

  @override
  State<LeadNoteScreen> createState() => _LeadNoteScreenState();
}

class _LeadNoteScreenState extends State<LeadNoteScreen> {
  final LeadController leadController = Get.find();
  @override
  void initState() {
    super.initState();
    leadController.leadNoteList(leadId: widget.leadId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: backgroundColor,
          child: Obx(
            () => leadController.isLeadNotesLoading.value == true
                ? SizedBox(
                    height: 700.h,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : leadController.leadNotesData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Notes data",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Click on add button to create note.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          LeadListViewNotes(leadController.leadNotesData),
                        ],
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryButtonColor,
        onPressed: () {
          Get.to(() => LeadNoteEditorScreen(
                leadId: int.parse(widget.leadId.toString()),
              ));
        },
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }
}
