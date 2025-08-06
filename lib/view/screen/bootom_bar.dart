import 'dart:developer';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/document_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/controller/notification_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/custom_text_convert.dart';
import 'package:task_management/custom_widget/gradient_text.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/attendence/checkin_screen.dart';
import 'package:task_management/view/screen/callender_event_screen.dart';
import 'package:task_management/view/screen/chat_list.dart';
import 'package:task_management/view/screen/document.dart';
import 'package:task_management/view/screen/home_screen.dart';
import 'package:task_management/view/screen/notification.dart';
import 'package:task_management/view/screen/profile.dart';
import 'package:task_management/view/screen/reports.dart';
import 'package:task_management/view/widgets/drawer.dart';

class BottomNavigationBarExample extends StatefulWidget {
  final String? from;
  final Map<String, dynamic> payloadData;
  const BottomNavigationBarExample(
      {super.key, this.from, required this.payloadData});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  static const List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ChatList(),
    const CheckinScreen(),
    const ReportScreen(),
    const DocumentFile(),
  ];

  void _onItemTapped(int index) {
    bottomBarController.currentPageIndex.value = index;
  }

  final BottomBarController bottomBarController =
      Get.put(BottomBarController());
  final DocumentController documentController = Get.put(DocumentController());
  final ChatController chatController = Get.put(ChatController());
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  var profilePicPath = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  final LeadController leadController = Get.put(LeadController());
  @override
  void initState() {
    super.initState();
    callApi();
  }

  var isLoading = false.obs;
  Future<void> callApi() async {
    isLoading.value = true;
    await notificationController.notificationListApi('');
    await homeController.homeDataApi(StorageHelper.getId());
    await homeController.leadHomeApi();
    // if (StorageHelper.getAssignedDept() != null) {
    await homeController.userReportApi(StorageHelper.getId());
    // }
    await homeController.taskResponsiblePersonListApi(
        StorageHelper.getAssignedDept(), "");
    await leadController.statusListApi(status: '');
    await leadController.sourceList(source: '');
    isLoading.value = false;
    await LocationHandler.determinePosition(context);
    homeController.isButtonVisible.value = true;
    await userPageControlelr.roleListApi(StorageHelper.getDepartmentId());
    print('s value in tasklist api 1 ${widget.from}');
    debugPrint('s value in tasklist api 2 ${widget.payloadData}');
    if (widget.from == "reminder") {
      await profileController.dailyTaskList(context, 'reminder', '');
    }

    if (widget.from == "true") {
      DateTime dt = DateTime.now();
      if (widget.payloadData['type'].toString() == "sos") {
        ShowDialogFunction().sosMsg(
          context,
          widget.payloadData["message"],
          dt,
        );
      } else {
        ShowDialogFunction().dailyMessage(
          context,
          widget.payloadData["message"],
          dt,
          widget.payloadData["title"],
        );
      }
    }

    profilePicPath.value = await StorageHelper.getImage() ?? "";
    await priorityController.priorityApi();
    await taskController.allProjectListApi();
    await taskController.responsiblePersonListApi(
        StorageHelper.getDepartmentId(), "");

    await SosPusherConfig().initPusher(_onPusherEvent,
        channelName: "test-channel", context: context);
  }

  Future<void> _onPusherEvent(PusherEvent event) async {
    log("Pusher event received: ${event.eventName} - ${event.data}");
  }

  String? selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];

  bool _isBackButtonPressed = false;
  @override
  void dispose() {
    profileController.selectedDepartMentListData.value = null;
    projectController.selectedAllProjectListData.value = null;
    taskController.reviewerCheckBox.clear();
    taskController.reviewerUserId.clear();
    taskController.responsiblePersonSelectedCheckBox.clear();
    taskController.assignedUserId.clear();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> _addEventToGoogleCalendar() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.EDIT',
        type: 'vnd.android.cursor.item/event',
        data: 'content://com.android.calendar/events',
        arguments: {
          'title': 'Test Title',
          'beginTime': "10-04-2025",
          'endTime': "10-04-2025",
          'allDay': false,
        },
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      try {
        await intent.launch();
        await Future.delayed(Duration(seconds: 5));
      } catch (e) {
        print('Error launching Google Calendar: $e');
      }
    } else {
      print('Calendar event creation not supported on this platform');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value == true &&
              bottomBarController.isUpdating.value == true &&
              profileController.isdepartmentListLoading.value == true &&
              priorityController.isPriorityLoading.value == true &&
              projectController.isAllProjectCalling.value == true &&
              notificationController.isNotificationLoading.value == true &&
              chatController.isChatLoading.value == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                key: _key,
                drawer: Obx(
                  () =>
                      SideDrawer(userPageControlelr.selectedRoleListData.value),
                ),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: whiteColor,
                  title: Row(
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () => _key.currentState?.openDrawer(),
                          child: SvgPicture.asset(menuImage,
                              color: textColor, height: 28.h),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GradientText(
                        taskMaster,
                        style: heading2,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            taskMasterGradientColor1,
                            taskMasterGradientColor2,
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () async {
                        Get.to(() => CalendarEventScreen());
                        // if (Platform.isAndroid) {
                        //   final intent = AndroidIntent(
                        //     action: 'android.intent.action.VIEW',
                        //     data: 'content://com.android.calendar/time/',
                        //     flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                        //   );
                        //   await intent.launch();
                        // } else {
                        //   print(
                        //       "Calendar launch not supported on this platform");
                        // }
                      },
                      child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                            color: boxBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(17.5.r))),
                        child: Padding(
                          padding: EdgeInsets.all(7.sp),
                          child: Image.asset(
                            'assets/images/png/calendar_icon.png',
                            height: 25.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        chatController.deleteChat();
                      },
                      child: Obx(
                        () => chatController.isLongPressed.contains(true)
                            ? Icon(Icons.delete)
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    InkWell(
                      onTap: () {
                        Get.to(() => NotificationPage());
                      },
                      child: Obx(
                        () => Badge(
                          isLabelVisible: notificationController
                                  .unreadNotificationCount.value >
                              0,
                          label: Text(
                              '${notificationController.unreadNotificationCount.value}'),
                          child: Container(
                            height: 35.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                                color: boxBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(17.5.r))),
                            child: Padding(
                              padding: EdgeInsets.all(7.sp),
                              child: SvgPicture.asset(
                                notificationImageSvg,
                                height: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18.w),
                    InkWell(
                      onTap: () {
                        Get.to(() => ProfilePage());
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: BoxDecoration(
                          color: Color(0xff1d9c03),
                          // color: darkBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${CustomTextConvert().getNameChar(StorageHelper.getName() ?? "")}',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                ),
                body: Center(
                  child: _widgetOptions
                      .elementAt(bottomBarController.currentPageIndex.value),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Color(0xff1d9c03),
                  unselectedItemColor: textColor,
                  backgroundColor: whiteColor,
                  items: [
                    _buildBottomNavItem('assets/images/png/home-logo.png',
                        'assets/images/png/white_home.png', 'Home'),
                    _buildBottomNavItem('assets/images/png/Message square.png',
                        'assets/images/png/WHITE_CHAT.png', 'Discussion'),
                    _attendanceBottomNavItem('assets/image/svg/add_icon.svg',
                        'assets/image/svg/add_icon.svg', 'Attendance'),
                    _buildBottomNavItem(
                        'assets/images/png/line-chart-up-01.png',
                        'assets/images/png/line-chart-up-01 (1).png',
                        'Report'),
                    _buildBottomNavItem('assets/images/png/grid-01.png',
                        'assets/images/png/grid-01 (1).png', 'Files'),
                  ],
                  currentIndex: bottomBarController.currentPageIndex.value,
                  onTap: _onItemTapped,
                ),
              ),
            ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return "Discussion";
      case 2:
        return "Attendance";
      case 3:
        return "Report";
      case 4:
        return "Document";
      default:
        return "";
    }
  }

  BottomNavigationBarItem _buildBottomNavItem(
      String iconPath, String activeIconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        color: textColor,
        height: 20.h,
      ),
      activeIcon: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          color: Color(0xff1d9c03),
          borderRadius: BorderRadius.all(
            Radius.circular(17.5.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            activeIconPath,
            color: whiteColor,
            height: 20.h,
          ),
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }

  BottomNavigationBarItem _attendanceBottomNavItem(
      String iconPath, String activeIconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        color: textColor,
        height: 20.h,
      ),
      activeIcon: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          color: Color(0xff1d9c03),
          borderRadius: BorderRadius.all(
            Radius.circular(17.5.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(
            activeIconPath,
            color: whiteColor,
          ),
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }
}
