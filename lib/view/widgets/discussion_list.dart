import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class DiscussionList extends StatelessWidget {
  final List<ChatListData> filteredList;
  DiscussionList(this.filteredList, {super.key});

  final ChatController chatController = Get.find();
  final TextEditingController searchAssignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxList<ChatListData> rxFilteredList = RxList<ChatListData>(filteredList);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: TextFormField(
            controller: searchAssignController,
            onChanged: (value) {
              rxFilteredList.value = chatController.chatList
                  .where((person) =>
              person.name?.toLowerCase().contains(value.toLowerCase()) ??
                  false)
                  .toList();
            },
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                child: SvgPicture.asset(searchIcon),
              ),
              hintText: 'Search here...',
              fillColor: searchBackgroundColor,
              filled: true,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(30.r)),
              ),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Expanded(
          child: Obx(
                () => ListView.builder(
              itemCount: rxFilteredList.length + 1,
              itemBuilder: (context, index) {
                if (index >= rxFilteredList.length) {
                  return SizedBox(height: 60.h);
                }

                final item = rxFilteredList[index];

                return InkWell(
                  onLongPress: () {
                    chatController.isLongPressed[index] =
                    !chatController.isLongPressed[index];
                    if (chatController.selectedChatId.contains(item.chatId)) {
                      chatController.selectedChatId.remove(item.chatId ?? 0);
                    } else {
                      chatController.selectedChatId.add(item.chatId ?? 0);
                    }
                  },
                  onTap: () {
                    Get.to(() => MessageScreen(
                      item.name,
                      item.chatId.toString(),
                      item.userId.toString(),
                      'chat_list',
                      item.members,
                      item.type.toString(),
                      item.image.toString(),
                      item.groupIcon.toString(),
                      "",
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 45.h,
                              width: 45.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffF4E2FF),
                                borderRadius: BorderRadius.circular(22.5.h),
                              ),
                              child: item.type?.toLowerCase() == 'group'
                                  ? ClipRRect(
                                borderRadius:
                                BorderRadius.circular(22.5.h),
                                child: Image.network(
                                  '${item.groupIcon}',
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(backgroundLogo);
                                  },
                                ),
                              )
                                  : InkWell(
                                onTap: () {
                                  openFile(item.image ?? "");
                                },
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(22.5.h),
                                  child: Image.network(
                                    '${item.image}',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(backgroundLogo);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.name ?? ""}',
                                          style: heading7,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        '${item.lastMessageTime ?? ""}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff262626)
                                              .withOpacity(0.38),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${item.lastMessage ?? ""}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff262626)
                                          .withOpacity(0.38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: backgroundColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => NetworkImageScreen(file: file));
    }
  }
}
