import 'dart:developer';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
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

  const BottomNavigationBarExample({
    super.key,
    this.from,
    required this.payloadData,
  });

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

  final BottomBarController bottomBarController = Get.put(
    BottomBarController(),
  );
  final DocumentController documentController = Get.put(DocumentController());
  final ChatController chatController = Get.put(ChatController());
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  var profilePicPath = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  final LeadController leadController = Get.put(LeadController());
  final location = tz.local;

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
      StorageHelper.getAssignedDept(),
      "",
    );
    await leadController.statusListApi(status: '');
    await leadController.sourceList(source: '');
    isLoading.value = false;

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
        ShowDialogFunction().sosMsg(context, widget.payloadData["message"], dt);
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
      StorageHelper.getDepartmentId(),
      "",
    );

    await SosPusherConfig().initPusher(
      _onPusherEvent,
      channelName: "test-channel",
      context: context,
    );
  }

  Future<void> _onPusherEvent(PusherEvent event) async {
    log("Pusher event received: ${event.eventName} - ${event.data}");
  }

  String? selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];

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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          isLoading.value == true &&
                  bottomBarController.isUpdating.value == true &&
                  profileController.isdepartmentListLoading.value == true &&
                  priorityController.isPriorityLoading.value == true &&
                  projectController.isAllProjectCalling.value == true &&
                  notificationController.isNotificationLoading.value == true &&
                  chatController.isChatLoading.value == true
              ? Center(child: CircularProgressIndicator())
              : /*WillPopScope(
                onWillPop: _onWillPop,*/ PopScope(
                canPop: false, // Prevent auto-pop
                onPopInvoked: (didPop) async {
                  if (didPop) {

                    return;
                  }


                  if (isLoading.value) {

                    Fluttertoast.showToast(
                      msg: "Please wait, an operation is in progress",
                    );
                    return;
                  }

                  if (bottomBarController.currentPageIndex.value != 0) {

                    bottomBarController.currentPageIndex.value = 0;
                    return;
                  }

                  final bool? shouldExit = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top Icon
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Title
                            const Text(
                              "Confirm Exit",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Message
                            const Text(
                              "Are you sure you want to exit the app?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Exit"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (shouldExit == true && context.mounted) {
                    SystemNavigator.pop();
                  } else {
                  }
                },
                child: Scaffold(
                  key: _key,
                  drawer: Obx(
                    () => SideDrawer(
                      userPageControlelr.selectedRoleListData.value,
                    ),
                  ),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: whiteColor,
                    title: Row(
                      children: [
                        Container(
                          height: 24.h,
                          width: 24.w,
                          child: InkWell(
                            onTap: () => _key.currentState?.openDrawer(),
                            child: SvgPicture.asset(
                              menuImage,
                              color: textColor,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),
                        GradientText(
                          taskMaster,
                          style: heading2,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [greenColor, Colors.black26],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      InkWell(
                        onTap: () async {
                          // Get.to(() => CalendarEventScreen());
                          if (Platform.isAndroid) {
                            final intent = AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data: 'content://com.android.calendar/time/',
                              flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                            );
                            await intent.launch();
                          } else {
                            print(
                              "Calendar launch not supported on this platform",
                            );
                          }
                        },
                        child: Container(
                          height: 35.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: lightPrimaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(17.5.r),
                            ),
                          ),
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
                          () =>
                              chatController.isLongPressed.contains(true)
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
                            isLabelVisible:
                                notificationController
                                    .unreadNotificationCount
                                    .value >
                                0,
                            label: Text(
                              '${notificationController.unreadNotificationCount.value}',
                            ),
                            child: Container(
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                color: lightPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17.5.r),
                                ),
                              ),
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
                            color: greenColor,
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
                    child: _widgetOptions.elementAt(
                      bottomBarController.currentPageIndex.value,
                    ),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    selectedItemColor: greenColor,
                    unselectedItemColor: textColor,
                    backgroundColor: whiteColor,
                    items: [
                      _buildBottomNavItem(
                        'assets/images/png/home-logo.png',
                        'assets/images/png/white_home.png',
                        'Home',
                      ),
                      _buildBottomNavItem(
                        'assets/images/png/Message square.png',
                        'assets/images/png/WHITE_CHAT.png',
                        'Discussion',
                      ),
                      _attendanceBottomNavItem(
                        'assets/image/svg/add_icon.svg',
                        'assets/image/svg/add_icon.svg',
                        'Attendance',
                      ),
                      _buildBottomNavItem(
                        'assets/images/png/line-chart-up-01.png',
                        'assets/images/png/line-chart-up-01 (1).png',
                        'Report',
                      ),
                      _buildBottomNavItem(
                        'assets/images/png/grid-01.png',
                        'assets/images/png/grid-01 (1).png',
                        'Files',
                      ),
                    ],
                    currentIndex: bottomBarController.currentPageIndex.value,
                    onTap: _onItemTapped,
                  ),
                ),
              ),
    );
  }

  Future<bool> _onWillPop() async {
    if (isLoading.value) {
      Fluttertoast.showToast(msg: "Please wait, an operation is in progress");
      return false; // Prevent back navigation while loading
    }
    log("Back button pressed");
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
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
  }

  BottomNavigationBarItem _buildBottomNavItem(
    String iconPath,
    String activeIconPath,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(iconPath, color: textColor, height: 20.h),
      activeIcon: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.all(Radius.circular(17.5.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(activeIconPath, color: whiteColor, height: 20.h),
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }

  BottomNavigationBarItem _attendanceBottomNavItem(
    String iconPath,
    String activeIconPath,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(iconPath, color: textColor, height: 20.h),
      activeIcon: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.all(Radius.circular(17.5.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(activeIconPath, color: whiteColor),
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }
}
