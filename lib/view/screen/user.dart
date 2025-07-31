import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/task_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TaskController taskController = Get.put(TaskController());
  final HomeController homeController = Get.find();
  @override
  void initState() {
    taskController.responsiblePersonListApi('', "");

    super.initState();
  }

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
          user,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => taskController.isResponsiblePersonLoading.value
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: backgroundColor,
                child: ListView.separated(
                  itemCount: taskController.responsiblePersonList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        Get.back();
                        await homeController.homeDataApi(
                          taskController.responsiblePersonList[index].id,
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffF4E2FF).withOpacity(0.50),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(22.5),
                                    ),
                                    child: Image.network(
                                      '${taskController.responsiblePersonList[index].image}',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.r),
                                            ),
                                          ),
                                          child: Image.asset(backgroundLogo),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${taskController.responsiblePersonList[index].name}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      taskController
                                                  .responsiblePersonList[index]
                                                  .phone ==
                                              null
                                          ? ""
                                          : '${taskController.responsiblePersonList[index].phone}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color(0xff262626).withOpacity(0.38),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 8.h,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
