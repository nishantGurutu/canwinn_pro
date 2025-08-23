import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/location_trackimg.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/canwin_member.dart';
import 'package:task_management/view/screen/canwinn_brand.dart';
import 'package:task_management/view/screen/contact.dart';
import 'package:task_management/view/screen/inscreen/hr_screen.dart';
import 'package:task_management/view/screen/inscreen/in_screen_department.dart';
import 'package:task_management/view/screen/inscreen/in_screen_form.dart';
import 'package:task_management/view/screen/inscreen/in_screen_security.dart';
import 'package:task_management/view/screen/meeting_screen.dart';
import 'package:task_management/view/screen/outscreen/out_screen.dart';
import 'package:task_management/view/screen/outscreen/out_screen_chalan_list.dart';
import 'package:task_management/view/screen/page_screen.dart';
import 'package:task_management/view/screen/profile.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/setting.dart';
import 'package:task_management/view/screen/task_screen.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:task_management/view/screen/user.dart';
import 'package:task_management/view/screen/vehicleManagement.dart';
import 'package:task_management/view/widgets/all_assets.dart';
import 'package:task_management/view/widgets/notes_folder.dart';
import 'package:task_management/view/widgets/select_user.dart';
import '../screen/CalendarScreenPage.dart';
import '../screen/outscreen/hr_screen.dart';
import '../screen/outscreen/security.dart';
import 'add_assets.dart';

class SideDrawer extends StatefulWidget {
  final RoleListData? roleData;
  const SideDrawer(this.roleData, {super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final BottomBarController bottomBarController = Get.find();
  final RegisterController registerController = Get.put(RegisterController());
  RxString firstLetters = ''.obs;
  final FeedController feedController = Get.put(FeedController());
  final ProfileController profileController = Get.find();

  RxBool isGatePasOpen = false.obs;
  RxBool isOutScreenOpen = false.obs;
  RxBool isInScreenOpen = false.obs;
  RxList<AssetsSubmitModel> selectedAssetsList = <AssetsSubmitModel>[].obs;

  RxList<AssetsSubmitModel> assetsList = <AssetsSubmitModel>[].obs;
  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController assetsSrnoTextController =
      TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TaskController taskController = Get.find();

  @override
  void initState() {
    bottomBarController.selectedTabIndex.value = 0;
    profileController.dailyTaskList(context, '', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        backgroundColor: whiteColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 105.h,
                    width: double.infinity,
                    color: whiteColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => ProfilePage());
                            },
                            child: Container(
                              height: 46.h,
                              width: 46.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(13.r),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(13.r),
                                ),
                                child: Image.network(
                                  StorageHelper.getImage(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
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
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  '${StorageHelper.getName()}',
                                  style: heading3,
                                ),
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  '${widget.roleData?.name ?? ''}',
                                  style: changeTextColor(
                                    robotoRegular,
                                    secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 0;
                            bottomBarController.currentPageIndex.value = 0;
                            Get.to(
                              BottomNavigationBarExample(
                                from: ' ',
                                payloadData: {},
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    bottomBarController
                                                .selectedTabIndex
                                                .value ==
                                            0
                                        ? selectedTabColor
                                        : whiteColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 5.h,
                                  bottom: 5.h,
                                ),
                                child: Row(
                                  spacing: 10.w,
                                  children: [
                                    Image.asset(
                                      dashboardIcon,
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  0
                                              ? whiteColor
                                              : textColor,
                                      height: 18.h,
                                    ),
                                    Text(
                                      dashboard,
                                      style: TextStyle(
                                        color:
                                            bottomBarController
                                                        .selectedTabIndex
                                                        .value ==
                                                    0
                                                ? whiteColor
                                                : textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 1;
                            Get.back();
                            Get.to(
                              TaskScreenPage(
                                taskType: "All Task",
                                assignedType: "Assigned to me",
                                '',
                                '',
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          1
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    drawerTaskicon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                1
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    task,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  1
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 48;
                            Get.back();
                            Get.to(
                              Calendarscreenpage(
                                '', // navigationType
                                '', // userId
                                taskType: "Data Calendar",
                                assignedType: " me",
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bottomBarController.selectedTabIndex.value == 48
                                  ? selectedTabColor
                                  : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, top: 7.h, bottom: 7.h),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    drawerTaskicon,
                                    color: bottomBarController.selectedTabIndex.value == 48
                                        ? whiteColor
                                        : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Data Calendar",
                                    style: TextStyle(
                                      color: bottomBarController.selectedTabIndex.value == 48
                                          ? whiteColor
                                          : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 50;
                            Get.back();
                            Get.to(() => LocationPage());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          50
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    drawerTaskicon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                50
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Location Page",
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  50
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10.h),
                        // InkWell(
                        //   onTap: () {
                        //     bottomBarController.selectedTabIndex.value = 50;
                        //     Get.back();
                        //     Get.to(() => StoredLocationPage());
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color:
                        //           bottomBarController.selectedTabIndex.value ==
                        //                   50
                        //               ? selectedTabColor
                        //               : whiteColor,
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(6.r),
                        //       ),
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.only(
                        //           left: 10.w, top: 7.h, bottom: 7.h),
                        //       child: Row(
                        //         spacing: 10.w,
                        //         children: [
                        //           SvgPicture.asset(
                        //             drawerTaskicon,
                        //             color: bottomBarController
                        //                         .selectedTabIndex.value ==
                        //                     50
                        //                 ? whiteColor
                        //                 : textColor,
                        //             height: 20.h,
                        //           ),
                        //           Text(
                        //             "Stored Location",
                        //             style: TextStyle(
                        //                 color: bottomBarController
                        //                             .selectedTabIndex.value ==
                        //                         50
                        //                     ? whiteColor
                        //                     : textColor,
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.w500),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 2;
                            Get.back();
                            Get.to(() => BrandingImage());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          2
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    taskIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                2
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    iAmCanwinn,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  2
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 3;
                            Get.to(const ContactPage());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          3
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    contactPhoneIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                3
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    contacts,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  3
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 4;
                            Get.to(const CalendarScreen(''));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          4
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    calenderTaskicon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                4
                                            ? whiteColor
                                            : textColor,
                                    height: 22.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    calendar,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  4
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 5;
                            Get.to(() => MeetingListScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          5
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    calenderIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                5
                                            ? whiteColor
                                            : textColor,
                                    height: 22.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    meeting,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  5
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (StorageHelper.getType() == 1)
                          SizedBox(height: 10.h),
                        if (StorageHelper.getType() == 1)
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(() => Vehiclemanagement());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    bottomBarController
                                                .selectedTabIndex
                                                .value ==
                                            5
                                        ? selectedTabColor
                                        : whiteColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 7.h,
                                  bottom: 7.h,
                                ),
                                child: Row(
                                  spacing: 10.w,
                                  children: [
                                    Image.asset(
                                      calenderIcon,
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  5
                                              ? whiteColor
                                              : textColor,
                                      height: 22.h,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      vehicleManagement,
                                      style: TextStyle(
                                        color:
                                            bottomBarController
                                                        .selectedTabIndex
                                                        .value ==
                                                    5
                                                ? whiteColor
                                                : textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 6;
                            feedController.fromPage.value = 'home';
                            bottomBarController.currentPageIndex.value = 2;
                            Get.to(
                              BottomNavigationBarExample(
                                from: 'home',
                                payloadData: {},
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          6
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    celebrationIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                6
                                            ? whiteColor
                                            : textColor,
                                    height: 22.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    "Event",
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  6
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () async {
                            // Get.to(()=> DailyActivity());
                            bottomBarController.selectedTabIndex.value = 7;
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                      ),
                                      child: dailyTaskListWidget(context),
                                    ),
                                  ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          7
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    checkBoxIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                7
                                            ? whiteColor
                                            : textColor,
                                    height: 22.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    "Submit Daily Activity",
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  7
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (StorageHelper.getType() == 1)
                          SizedBox(height: 10.h),
                        if (StorageHelper.getType() == 1)
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.back();
                                  bottomBarController.selectedTabIndex.value =
                                      8;
                                  selectedAssetsList.clear();
                                  assetsList.clear();
                                  assetsNameTextController.clear();
                                  assetsSrnoTextController.clear();
                                  quantityTextController.clear();
                                  taskController.assignedUserId.clear();

                                  taskController
                                      .responsiblePersonSelectedCheckBox
                                      .clear();
                                  taskController
                                      .responsiblePersonSelectedCheckBox
                                      .addAll(
                                        List<bool>.filled(
                                          taskController
                                              .responsiblePersonList
                                              .length,
                                          false,
                                        ),
                                      );
                                  taskController.selectAll.value = false;
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:
                                        (context) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                          ),
                                          child: AddAssets(),
                                          // child: assignAssets(context),
                                        ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                8
                                            ? selectedTabColor
                                            : whiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 7.h,
                                      bottom: 7.h,
                                    ),
                                    child: Row(
                                      spacing: 10.w,
                                      children: [
                                        Image.asset(
                                          calenderIcon,
                                          color:
                                              bottomBarController
                                                          .selectedTabIndex
                                                          .value ==
                                                      8
                                                  ? whiteColor
                                                  : textColor,
                                          height: 22.h,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "Assign assets",
                                          style: TextStyle(
                                            color:
                                                bottomBarController
                                                            .selectedTabIndex
                                                            .value ==
                                                        8
                                                    ? whiteColor
                                                    : textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              InkWell(
                                onTap: () async {
                                  Get.back();
                                  bottomBarController.selectedTabIndex.value =
                                      26;
                                  Get.to(() => AllAssetsList());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                26
                                            ? selectedTabColor
                                            : whiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 7.h,
                                      bottom: 7.h,
                                    ),
                                    child: Row(
                                      spacing: 10.w,
                                      children: [
                                        Image.asset(
                                          calenderIcon,
                                          color:
                                              bottomBarController
                                                          .selectedTabIndex
                                                          .value ==
                                                      26
                                                  ? whiteColor
                                                  : textColor,
                                          height: 22.h,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "All assets",
                                          style: TextStyle(
                                            color:
                                                bottomBarController
                                                            .selectedTabIndex
                                                            .value ==
                                                        26
                                                    ? whiteColor
                                                    : textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () async {
                            bottomBarController.selectedTabIndex.value = 9;
                            await profileController.dailyTaskList(
                              context,
                              'pastTask',
                              '',
                            );
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          9
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    previewIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                9
                                            ? whiteColor
                                            : textColor,
                                    height: 22.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    "Download Report",
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  9
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 10;
                            Get.to(Project(''));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          10
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    assignementIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                10
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    project,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  10
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (StorageHelper.getType() == 1)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  bottomBarController.selectedTabIndex.value =
                                      11;
                                  Get.to(const PageScreen());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                11
                                            ? selectedTabColor
                                            : whiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 7.h,
                                      bottom: 7.h,
                                    ),
                                    child: Row(
                                      spacing: 10.w,
                                      children: [
                                        Image.asset(
                                          taskIcon,
                                          color:
                                              bottomBarController
                                                          .selectedTabIndex
                                                          .value ==
                                                      11
                                                  ? whiteColor
                                                  : textColor,
                                          height: 20.h,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          page,
                                          style: TextStyle(
                                            color:
                                                bottomBarController
                                                            .selectedTabIndex
                                                            .value ==
                                                        11
                                                    ? whiteColor
                                                    : textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 12;
                            Get.to(() => NotesFolder());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          12
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    addNotesIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                12
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    notes,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  12
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (StorageHelper.getType() == 1)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  bottomBarController.selectedTabIndex.value =
                                      13;
                                  Get.to(const UserPage());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                13
                                            ? selectedTabColor
                                            : whiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 7.h,
                                      bottom: 7.h,
                                    ),
                                    child: Row(
                                      spacing: 10.w,
                                      children: [
                                        Image.asset(
                                          notesIcon,
                                          color:
                                              bottomBarController
                                                          .selectedTabIndex
                                                          .value ==
                                                      13
                                                  ? whiteColor
                                                  : textColor,
                                          height: 20.h,
                                        ),
                                        Text(
                                          user,
                                          style: TextStyle(
                                            color:
                                                bottomBarController
                                                            .selectedTabIndex
                                                            .value ==
                                                        13
                                                    ? whiteColor
                                                    : textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 14;
                            Get.to(const ToDoList(''));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          14
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  SvgPicture.asset(
                                    fastCheckIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                14
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    todo,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  14
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 15;
                            isGatePasOpen.value = !isGatePasOpen.value;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          15
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    getPassIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                15
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    gatePass,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  15
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () =>
                              !isGatePasOpen.value
                                  ? SizedBox()
                                  : Padding(
                                    padding: EdgeInsets.only(left: 25.w),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10.h),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            bottomBarController
                                                .selectedTabIndex
                                                .value = 16;
                                            Get.to(
                                              StorageHelper.getDepartmentId() ==
                                                      12
                                                  ? const InScreenForm()
                                                  : const OutScreen(),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  bottomBarController
                                                              .selectedTabIndex
                                                              .value ==
                                                          16
                                                      ? selectedTabColor
                                                      : whiteColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 10.w,
                                                top: 7.h,
                                                bottom: 7.h,
                                              ),
                                              child: Row(
                                                spacing: 10.w,
                                                children: [
                                                  Image.asset(
                                                    notesIcon,
                                                    color:
                                                        bottomBarController
                                                                    .selectedTabIndex
                                                                    .value ==
                                                                16
                                                            ? whiteColor
                                                            : textColor,
                                                    height: 20.h,
                                                  ),
                                                  Text(
                                                    create,
                                                    style: TextStyle(
                                                      color:
                                                          bottomBarController
                                                                      .selectedTabIndex
                                                                      .value ==
                                                                  16
                                                              ? whiteColor
                                                              : textColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () =>
                                              !isOutScreenOpen.value
                                                  ? SizedBox()
                                                  : Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 30.w,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 10.h),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            11)
                                                          SizedBox(
                                                            height: 20.h,
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            11)
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                              bottomBarController
                                                                      .selectedTabIndex
                                                                      .value ==
                                                                  17;
                                                              bottomBarController
                                                                  .selectedTabIndex
                                                                  .value = 17;
                                                              Get.to(
                                                                const HrScreen(),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    bottomBarController.selectedTabIndex.value ==
                                                                            17
                                                                        ? selectedTabColor
                                                                        : whiteColor,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        6.r,
                                                                      ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left:
                                                                          10.w,
                                                                      top: 7.h,
                                                                      bottom:
                                                                          7.h,
                                                                    ),
                                                                child: Row(
                                                                  spacing: 10.w,
                                                                  children: [
                                                                    Image.asset(
                                                                      notesIcon,
                                                                      color:
                                                                          bottomBarController.selectedTabIndex.value ==
                                                                                  17
                                                                              ? whiteColor
                                                                              : textColor,
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Text(
                                                                      hrScreen,
                                                                      style: TextStyle(
                                                                        color:
                                                                            bottomBarController.selectedTabIndex.value ==
                                                                                    17
                                                                                ? whiteColor
                                                                                : textColor,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            12)
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            12)
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                              bottomBarController
                                                                      .selectedTabIndex
                                                                      .value ==
                                                                  18;
                                                              Get.to(
                                                                const SecurityScreen(),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    bottomBarController.selectedTabIndex.value ==
                                                                            18
                                                                        ? selectedTabColor
                                                                        : whiteColor,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        6.r,
                                                                      ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left:
                                                                          10.w,
                                                                      top: 7.h,
                                                                      bottom:
                                                                          7.h,
                                                                    ),
                                                                child: Row(
                                                                  spacing: 10.w,
                                                                  children: [
                                                                    Image.asset(
                                                                      notesIcon,
                                                                      color:
                                                                          bottomBarController.selectedTabIndex.value ==
                                                                                  18
                                                                              ? whiteColor
                                                                              : textColor,
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Text(
                                                                      sceurityScreen,
                                                                      style: TextStyle(
                                                                        color:
                                                                            bottomBarController.selectedTabIndex.value ==
                                                                                    18
                                                                                ? whiteColor
                                                                                : textColor,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                        ),
                                        SizedBox(height: 10.h),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                19;
                                            Get.to(const OutScreenChalanList());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  bottomBarController
                                                              .selectedTabIndex
                                                              .value ==
                                                          19
                                                      ? selectedTabColor
                                                      : whiteColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 10.w,
                                                top: 7.h,
                                                bottom: 7.h,
                                              ),
                                              child: Row(
                                                spacing: 10.w,
                                                children: [
                                                  Image.asset(
                                                    notesIcon,
                                                    color:
                                                        bottomBarController
                                                                    .selectedTabIndex
                                                                    .value ==
                                                                19
                                                            ? whiteColor
                                                            : textColor,
                                                    height: 20.h,
                                                  ),
                                                  Text(
                                                    approve,
                                                    style: TextStyle(
                                                      color:
                                                          bottomBarController
                                                                      .selectedTabIndex
                                                                      .value ==
                                                                  19
                                                              ? whiteColor
                                                              : textColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () =>
                                              !isInScreenOpen.value
                                                  ? SizedBox()
                                                  : Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 30.w,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 20.h),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                            bottomBarController
                                                                .selectedTabIndex
                                                                .value = 20;
                                                            Get.to(
                                                              const InScreenDepartment(),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  bottomBarController
                                                                              .selectedTabIndex
                                                                              .value ==
                                                                          20
                                                                      ? selectedTabColor
                                                                      : whiteColor,
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      6.r,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    left: 10.w,
                                                                    top: 7.h,
                                                                    bottom: 7.h,
                                                                  ),
                                                              child: Row(
                                                                spacing: 10.w,
                                                                children: [
                                                                  Image.asset(
                                                                    notesIcon,
                                                                    color:
                                                                        bottomBarController.selectedTabIndex.value ==
                                                                                20
                                                                            ? whiteColor
                                                                            : textColor,
                                                                    height:
                                                                        20.h,
                                                                  ),
                                                                  Text(
                                                                    inScreenDepartment,
                                                                    style: TextStyle(
                                                                      color:
                                                                          bottomBarController.selectedTabIndex.value ==
                                                                                  20
                                                                              ? whiteColor
                                                                              : textColor,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            11)
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            11)
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                              bottomBarController
                                                                  .selectedTabIndex
                                                                  .value = 21;
                                                              Get.to(
                                                                const InHrScreen(),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    bottomBarController.selectedTabIndex.value ==
                                                                            21
                                                                        ? selectedTabColor
                                                                        : whiteColor,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        6.r,
                                                                      ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left:
                                                                          10.w,
                                                                      top: 7.h,
                                                                      bottom:
                                                                          7.h,
                                                                    ),
                                                                child: Row(
                                                                  spacing: 10.w,
                                                                  children: [
                                                                    Image.asset(
                                                                      notesIcon,
                                                                      color:
                                                                          bottomBarController.selectedTabIndex.value ==
                                                                                  21
                                                                              ? whiteColor
                                                                              : textColor,
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Text(
                                                                      inScreenHr,
                                                                      style: TextStyle(
                                                                        color:
                                                                            bottomBarController.selectedTabIndex.value ==
                                                                                    21
                                                                                ? whiteColor
                                                                                : textColor,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            12)
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                        if (StorageHelper.getDepartmentId() ==
                                                            12)
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                              bottomBarController
                                                                  .selectedTabIndex
                                                                  .value = 22;
                                                              Get.to(
                                                                const InScreenSecurity(),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    bottomBarController.selectedTabIndex.value ==
                                                                            22
                                                                        ? selectedTabColor
                                                                        : whiteColor,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        6.r,
                                                                      ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left:
                                                                          10.w,
                                                                      top: 7.h,
                                                                      bottom:
                                                                          7.h,
                                                                    ),
                                                                child: Row(
                                                                  spacing: 10.w,
                                                                  children: [
                                                                    Image.asset(
                                                                      notesIcon,
                                                                      color:
                                                                          bottomBarController.selectedTabIndex.value ==
                                                                                  22
                                                                              ? selectedTabColor
                                                                              : whiteColor,
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Text(
                                                                      inScreenSecurity,
                                                                      style: TextStyle(
                                                                        color:
                                                                            bottomBarController.selectedTabIndex.value ==
                                                                                    22
                                                                                ? selectedTabColor
                                                                                : whiteColor,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 23;
                            Get.to(const CanwinMember());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          23
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    canwinMemberIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                23
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    canwinMember,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  23
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            Get.back();
                            bottomBarController.selectedTabIndex.value = 24;
                            Get.to(const SettingScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          24
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    settingIcon,
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                24
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    setting,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  24
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            bottomBarController.selectedTabIndex.value = 25;
                            logoutApp();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  bottomBarController.selectedTabIndex.value ==
                                          25
                                      ? selectedTabColor
                                      : whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                top: 7.h,
                                bottom: 7.h,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/png/logout-04.png",
                                    color:
                                        bottomBarController
                                                    .selectedTabIndex
                                                    .value ==
                                                25
                                            ? whiteColor
                                            : textColor,
                                    height: 20.h,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    logout,
                                    style: TextStyle(
                                      color:
                                          bottomBarController
                                                      .selectedTabIndex
                                                      .value ==
                                                  25
                                              ? whiteColor
                                              : textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          appVersion,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: lightBorderColor,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dailyTaskListWidget(BuildContext context) {
    if (profileController.timeControllers.isEmpty ||
        profileController.timeControllers.length !=
            profileController.dailyTaskDataList.length) {
      profileController.initializeTimeControllers(
        profileController.dailyTaskDataList.length,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: SafeArea(
        child: Obx(
          () =>
              profileController.isDailyTaskLoading.value == true
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Submit Daily Task',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        profileController.isDailyTaskLoading.value == true
                            ? Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            )
                            : Expanded(
                              child: ListView.builder(
                                itemCount:
                                    profileController.dailyTaskDataList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(11.r),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: lightGreyColor.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 13.0,
                                              spreadRadius: 2,
                                              blurStyle: BlurStyle.normal,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${index + 1}.',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Container(
                                                    width: 260.w,
                                                    child: Text(
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      '${profileController.dailyTaskDataList[index].taskName}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Obx(
                                                    () => SizedBox(
                                                      height: 20.h,
                                                      width: 20.w,
                                                      child: Checkbox(
                                                        value:
                                                            profileController
                                                                .dailyTaskListCheckbox[index],
                                                        onChanged: (value) {
                                                          if (profileController
                                                                  .isDailyTaskSubmitting
                                                                  .value ==
                                                              false) {
                                                            if (profileController
                                                                    .timeControllers[index]
                                                                    .text
                                                                    .isNotEmpty &&
                                                                profileController
                                                                    .remarkControllers[index]
                                                                    .text
                                                                    .isNotEmpty) {
                                                              profileController
                                                                      .dailyTaskListCheckbox[index] =
                                                                  value!;
                                                              if (value) {
                                                                final taskId =
                                                                    profileController
                                                                        .dailyTaskDataList[index]
                                                                        .id;

                                                                profileController.dailyTaskSubmitList.add(
                                                                  DailyTaskSubmitModel(
                                                                    taskId:
                                                                        taskId ??
                                                                        0,
                                                                    doneTime:
                                                                        profileController
                                                                            .timeControllers[index]
                                                                            .text,
                                                                    remarks:
                                                                        profileController
                                                                            .remarkControllers[index]
                                                                            .text,
                                                                  ),
                                                                );
                                                              } else {
                                                                final taskId =
                                                                    profileController
                                                                        .dailyTaskDataList[index]
                                                                        .id;
                                                                profileController
                                                                    .dailyTaskSubmitList
                                                                    .removeWhere(
                                                                      (task) =>
                                                                          task.taskId ==
                                                                          taskId,
                                                                    );
                                                              }
                                                            } else {
                                                              CustomToast()
                                                                  .showCustomToast(
                                                                    "Please select time & remarks.",
                                                                  );
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 120.w,
                                                    child: TextFormField(
                                                      controller:
                                                          profileController
                                                              .timeControllers[index],
                                                      decoration: InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.access_time,
                                                          color: secondaryColor,
                                                        ),
                                                        hintText: timeFormate,
                                                        hintStyle: rubikRegular,
                                                        fillColor:
                                                            lightSecondaryColor,
                                                        filled: true,

                                                        // enabled: false,
                                                        border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  16.r,
                                                                ),
                                                              ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  16.r,
                                                                ),
                                                              ),
                                                        ),
                                                        disabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  16.r,
                                                                ),
                                                              ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  16.r,
                                                                ),
                                                              ),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 10.h,
                                                            ),
                                                      ),
                                                      readOnly: true,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  InkWell(
                                                    onTap: () {
                                                      remarkShowAlertDialog(
                                                        context,
                                                        index,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            lightSecondaryColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                11.r,
                                                              ),
                                                            ),
                                                      ),
                                                      width: 180.w,
                                                      height: 40.h,
                                                      child: Center(
                                                        child: Text(
                                                          '${profileController.remarkControllers[index].text.isEmpty ? "Add Remark" : profileController.remarkControllers[index].text}',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                    ],
                                  );
                                },
                              ),
                            ),
                        Obx(
                          () => CustomButton(
                            onPressed: () {
                              if (profileController
                                      .isDailyTaskSubmitting
                                      .value ==
                                  false) {
                                if (profileController
                                    .dailyTaskSubmitList
                                    .isNotEmpty) {
                                  profileController.submitDailyTask(
                                    profileController.dailyTaskSubmitList,
                                    context,
                                  );
                                  profileController.timeControllers.clear();
                                  profileController.remarkControllers.clear();
                                } else {
                                  CustomToast().showCustomToast(
                                    "Please select daily task.",
                                  );
                                }
                              }
                            },
                            text:
                                profileController.isDailyTaskSubmitting.value ==
                                        true
                                    ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: whiteColor,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor,
                                          ),
                                        ),
                                      ],
                                    )
                                    : Text(
                                      submit,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            width: double.infinity,
                            color: primaryColor,
                            height: 45.h,
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Future<void> remarkShowAlertDialog(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TaskCustomTextField(
                    controller: profileController.remarkControllers[index],
                    textCapitalization: TextCapitalization.sentences,
                    data: remark,
                    hintText: remark,
                    labelText: remark,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    color: primaryColor,
                    text: Text(
                      add,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                    ),
                    onPressed: () {
                      profileController.remarkControllers[index].text =
                          profileController.remarkControllers[index].text
                              .trim();
                      Get.back();
                    },
                    width: 200,
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  RxList<bool> assetsListCheckbox = <bool>[].obs;
  Widget assignAssets(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Assign Assets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: assetsNameTextController,
                    textCapitalization: TextCapitalization.sentences,
                    data: assets,
                    hintText: assets,
                    labelText: assets,
                    index: 0,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: quantityTextController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    data: qty,
                    hintText: qty,
                    labelText: qty,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            SizedBox(
              child: TaskCustomTextField(
                controller: assetsSrnoTextController,
                textCapitalization: TextCapitalization.sentences,
                data: srNo,
                hintText: srNo,
                labelText: srNo,
                index: 3,
                focusedIndexNotifier: focusedIndexNotifier,
              ),
            ),
            SizedBox(height: 15.h),
            UesrListWidget(),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  color: primaryColor,
                  text: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    int qty = int.parse(quantityTextController.text.trim());
                    List<String> serialNumbers =
                        assetsSrnoTextController.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();
                    if (assetsNameTextController.text.isNotEmpty &&
                        quantityTextController.text.isNotEmpty &&
                        assetsSrnoTextController.text.isNotEmpty) {
                      if (qty == serialNumbers.length) {
                        assetsList.add(
                          AssetsSubmitModel(
                            name: assetsNameTextController.text.trim(),
                            qty: int.parse(quantityTextController.text.trim()),
                            serialNo: serialNumbers,
                          ),
                        );
                        assetsListCheckbox.addAll(
                          List<bool>.filled(assetsList.length, false),
                        );
                        assetsNameTextController.clear();
                        quantityTextController.clear();
                        assetsSrnoTextController.clear();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Add serial number according to quantity.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please enter Asset Name, Quantity, and Serial Numbers",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                  width: 150.w,
                  height: 40.h,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            profileController.isDailyTaskLoading.value == true
                ? Center(child: CircularProgressIndicator(color: whiteColor))
                : Obx(
                  () => Expanded(
                    child: ListView.builder(
                      itemCount: assetsList.length,
                      itemBuilder: (context, index) {
                        String srNumberString = assetsList[index].serialNo.join(
                          ", ",
                        );

                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightGreyColor.withOpacity(0.2),
                                    blurRadius: 13.0,
                                    spreadRadius: 2,
                                    blurStyle: BlurStyle.normal,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 8.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 110.w,
                                          child: Text(
                                            '$srNumberString',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Container(
                                          width: 110.w,
                                          child: Text(
                                            '${assetsList[index].name ?? ""}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Container(
                                          width: 40.w,
                                          child: Center(
                                            child: Text(
                                              '${assetsList[index].qty ?? ""}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Spacer(),
                                        Obx(
                                          () => SizedBox(
                                            height: 20.h,
                                            width: 20.w,
                                            child: Checkbox(
                                              value: assetsListCheckbox[index],
                                              onChanged: (value) {
                                                assetsListCheckbox[index] =
                                                    value!;
                                                if (value) {
                                                  if (!selectedAssetsList
                                                      .contains(
                                                        assetsList[index],
                                                      )) {
                                                    selectedAssetsList.add(
                                                      assetsList[index],
                                                    );
                                                  }
                                                } else {
                                                  selectedAssetsList.remove(
                                                    assetsList[index],
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),
            CustomButton(
              onPressed: () async {
                if (selectedAssetsList.isNotEmpty) {
                  // await profileController.assignAssets(
                  //     selectedAssetsList, taskController.assignedUserId);
                } else {
                  CustomToast().showCustomToast("Please select assets.");
                }
              },
              text: Text(
                assigneButton,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              width: double.infinity,
              color: primaryColor,
              height: 45.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logoutApp() async {
    registerController.userLogout();
  }
}
