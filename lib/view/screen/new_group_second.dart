import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import '../../constant/text_constant.dart';

class NewGroupSecond extends StatelessWidget {
  final RxList<ResponsiblePersonData> selectedList;
  NewGroupSecond(this.selectedList, {super.key});

  final ChatController chatController = Get.put(ChatController());

  final TextEditingController groupNameTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          newGroup,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: lightBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: SvgPicture.asset(cameraIcon),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: groupNameTextEditingController,
                      // autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Group Name',
                          hintStyle: TextStyle(color: lightGreyColor)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  Text(
                    "${memberName} ",
                    style: changeTextColor(rubikRegular, lightGreyColor),
                  ),
                  SvgPicture.asset(arrowRightIcon)
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: selectedList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
                    child: Column(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: lightGreyColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.r),
                            ),
                            child: Image.network(
                              "${selectedList[index].image}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return SvgPicture.asset(
                                  backgroundLogo,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        SizedBox(
                          width: 82.w,
                          child: Text(
                            "${selectedList[index].name}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: changeTextColor(rubikRegular, darkGreyColor),
                          ),
                        ),
                      ],
                    ),
                  );
                  // : SizedBox();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.h,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (chatController.isGroupCreating.value == false) {
            chatController.groupCreateApi(
                groupNameTextEditingController.text, selectedList);
          }
        },
        shape: CircleBorder(),
        backgroundColor: primaryColor,
        child: Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}
