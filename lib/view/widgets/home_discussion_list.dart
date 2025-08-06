import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/custom_widget/custom_text_convert.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class HomeDiscussionList extends StatelessWidget {
  final RxList<Chatlist> homeChatList;
  HomeDiscussionList(this.homeChatList, {super.key});
  final ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeChatList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/png/chat 1.png',
                  height: 80.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'No discussion data',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ))
          : ListView.builder(
              itemCount: homeChatList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      InkWell(
                        onLongPress: () {
                          chatController.isLongPressed[index] =
                              !chatController.isLongPressed[index];
                          if (chatController.selectedChatId
                              .contains(homeChatList[index].chatId)) {
                            chatController.selectedChatId
                                .remove(homeChatList[index].chatId ?? 0);
                          } else {
                            chatController.selectedChatId
                                .add(homeChatList[index].chatId ?? 0);
                          }
                        },
                        onTap: () {
                          Get.to(
                            () => MessageScreen(
                              homeChatList[index].name ?? '',
                              homeChatList[index].chatId.toString(),
                              homeChatList[index].userId.toString(),
                              'chat_list',
                              [],
                              homeChatList[index].type.toString(),
                              '',
                              '',
                              "",
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.r)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Get.to(() => ProfilePage());
                                    },
                                    child: Container(
                                      height: 32.h,
                                      width: 32.w,
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${CustomTextConvert().getNameChar(homeChatList[index].name)}',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  '${homeChatList[index].name ?? ""}',
                                                  style: heading6),
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                                '${homeChatList[index].lastMessageTime ?? ""}',
                                                style: changeTextColor(
                                                    heading9, timeColor)),
                                          ],
                                        ),
                                        SizedBox(height: 3.h),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                              '${homeChatList[index].lastMessage ?? ""}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: changeTextColor(
                                                  heading9, timeColor)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            homeChatList.length - 1 == index
                                ? SizedBox(
                                    height: 4.h,
                                  )
                                : Divider(
                                    thickness: 1,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => NetworkImageScreen(file: file));
    }
  }
}
