import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/view/widgets/add_group_member.dart';

class GroupMemberlist extends StatefulWidget {
  final String? chatId;
  const GroupMemberlist(this.chatId, {super.key});

  @override
  State<GroupMemberlist> createState() => _GroupMemberlistState();
}

class _GroupMemberlistState extends State<GroupMemberlist> {
  final ChatController chatController = Get.find();
  @override
  void initState() {
    chatController.memberListApi(widget.chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  CustomButton(
                      color: primaryColor,
                      text: Text(
                        'Add Member',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: whiteColor),
                      ),
                      onPressed: () {
                        Get.to(() => AddGroupMember(widget.chatId));
                      },
                      width: 150.w)
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Obx(
                () => chatController.isMemberLoading.value == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : SizedBox(
                        height: 615.h,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: double.infinity,
                              child: Text(
                                '${chatController.membersList.length} members',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: chatController.membersList.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        height: 40.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                          child: Image.network(
                                            chatController.membersList[index]
                                                    ['image'] ??
                                                "",
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.r),
                                                  ),
                                                ),
                                                child:
                                                    Image.asset(backgroundLogo),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${chatController.membersList[index]['name'] ?? ''}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10.h,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
