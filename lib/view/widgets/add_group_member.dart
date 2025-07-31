import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart'
    show backgroundLogo;
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class AddGroupMember extends StatefulWidget {
  final String? chatId;
  const AddGroupMember(this.chatId, {super.key});

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  final TaskController taskController = Get.put(TaskController());
  final ChatController chatController = Get.find();
  @override
  void initState() {
    taskController.responsiblePersonListApi('', "");
    super.initState();
  }

  @override
  void dispose() {
    chatController.selectedMemberId.clear();
    super.dispose();
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkImageScreen(file: file),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          "Members",
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => taskController.isResponsiblePersonLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                color: backgroundColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (chatController.isGroupUserAdding.value ==
                                false) {
                              if (chatController.selectedMemberId.isNotEmpty) {
                                chatController.addGroupUser(
                                  widget.chatId,
                                  chatController.selectedMemberId,
                                );
                              } else {
                                CustomToast()
                                    .showCustomToast('Please select member.');
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: whiteColor,
                                        size: 18.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(
                                      "Add Member",
                                      style: changeTextColor(
                                          robotoRegular, primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: taskController.responsiblePersonList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (chatController.selectedMemberId.contains(
                                      taskController
                                          .responsiblePersonList[index].id)) {
                                    taskController.selectedLongPress[index] =
                                        false;
                                    chatController.selectedMemberId.remove(
                                        taskController
                                            .responsiblePersonList[index].id);
                                  } else {
                                    taskController.selectedLongPress[index] =
                                        true;
                                    chatController.selectedMemberId.add(
                                        taskController
                                            .responsiblePersonList[index].id);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w, top: 10.h, right: 10.w),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          Color(0xffF4E2FF).withOpacity(0.50),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF4E2FF),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(22.5),
                                              ),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                openFile(
                                                  taskController
                                                          .responsiblePersonList[
                                                              index]
                                                          .image ??
                                                      "",
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(22.5),
                                                ),
                                                child: Image.network(
                                                  taskController
                                                          .responsiblePersonList[
                                                              index]
                                                          .image ??
                                                      "",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20.r),
                                                        ),
                                                      ),
                                                      child: Image.asset(
                                                          backgroundLogo),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${taskController.responsiblePersonList[index].name}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: textColor),
                                              ),
                                              Text(
                                                taskController
                                                            .responsiblePersonList[
                                                                index]
                                                            .phone ==
                                                        null
                                                    ? ""
                                                    : '${taskController.responsiblePersonList[index].phone}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff262626)
                                                        .withOpacity(0.38)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => taskController.selectedLongPress[index] ==
                                        true
                                    ? Positioned(
                                        top: 35.h,
                                        right: 25.w,
                                        child: Icon(
                                          Icons.done,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 8.h,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
