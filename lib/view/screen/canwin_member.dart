import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/member_controller.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/model/member_list_model.dart';

class CanwinMember extends StatefulWidget {
  const CanwinMember({super.key});

  @override
  State<CanwinMember> createState() => _CanwinMemberState();
}

class _CanwinMemberState extends State<CanwinMember> {
  final MemberController canwinMemberController = Get.put(MemberController());
  @override
  void initState() {
    canwinMemberController.memberListApi();
    super.initState();
  }

  final TextEditingController industryNameTextEditingControlelr =
      TextEditingController();
  final TextEditingController industryNameTextEditingControlelr2 =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          canwinMember,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => canwinMemberController.isMemberRoleLoading.value == true
            ? Container(
                color: backgroundColor,
                height: 700.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              )
            : canwinMemberController.memberList.isEmpty
                ? Container(
                    color: backgroundColor,
                    child: Center(
                      child: Text(
                        noIndustry,
                        style: rubikBold,
                      ),
                    ),
                  )
                : Container(
                    color: backgroundColor,
                    child: Column(
                      children: [
                        sourceList(canwinMemberController.memberList),
                      ],
                    ),
                  ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Get.to(const AddProject());
      //   },
      //   backgroundColor: primaryColor,
      //   child: Icon(
      //     Icons.add,
      //     color: whiteColor,
      //     size: 30.h,
      //   ),
      // ),
    );
  }

  List<Color> colorList = [backgroundColor, whiteColor];
  Widget sourceList(RxList<MemberData> memberList) {
    return Expanded(
      child: ListView.separated(
        itemCount: memberList.length,
        itemBuilder: (BuildContext context, int index) {
          int colorIndex = index % colorList.length;
          DateTime? dt = DateTime.parse(memberList[index].createdAt.toString());
          return Container(
            color: colorList[colorIndex],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name : ${memberList[index].name}',
                      style: changeTextColor(rubikBold, darkGreyColor),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Phone : ${memberList[index].phone}',
                      style: TextStyle(color: darkGreyColor),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Email : ${memberList[index].email}',
                      style: TextStyle(color: darkGreyColor),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Location : ${memberList[index].countryName}',
                      style: TextStyle(color: darkGreyColor),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Role : ${memberList[index].roleName}',
                      style: TextStyle(color: darkGreyColor),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateConverter.formatDate(dt),
                          style: changeTextColor(rubikMedium, darkGreyColor),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.r))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            child: Center(
                              child: Text(
                                memberList[index].status.toString() == "1"
                                    ? "Active"
                                    : "",
                                style: changeTextColor(rubikBold, whiteColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5.h);
        },
      ),
    );
  }
}
