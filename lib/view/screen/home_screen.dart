import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/home_lead_model.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/model/lead_contact_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/all_followups.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/leads_list.dart';
import 'package:task_management/view/screen/meeting/get_meeting.dart'
    show GetMeetingList;
import 'package:task_management/view/screen/task_screen.dart';
import 'package:task_management/view/widgets/add_task.dart';
import 'package:task_management/view/widgets/admin_user_list.dart';
import 'package:task_management/view/widgets/autoScrollListInfo.dart';
import 'package:task_management/view/widgets/home_discussion_list.dart';
import 'package:task_management/view/widgets/home_event_data.dart';
import 'package:task_management/view/widgets/home_leads.dart';
import 'package:task_management/view/widgets/home_task.dart';
import 'package:task_management/view/widgets/home_task_list.dart';
import 'package:task_management/view/widgets/home_title.dart';
import 'package:task_management/view/widgets/notes_folder.dart'
    show NotesFolder;
import 'package:task_management/view/widgets/task_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'daily_activity.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  RxString firstLetters = ''.obs;
  RxString userName = ''.obs;
  final HomeController homeController = Get.find();
  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  final BottomBarController bottomBarController = Get.find();
  RxList<AssetsSubmitModel> assetsList = <AssetsSubmitModel>[].obs;
  RxList<bool> assetsListCheckbox = <bool>[].obs;
  final FeedController feedController = Get.put(FeedController());
  final ChatController chatController = Get.put(ChatController());
  final LeadController leadController = Get.put(LeadController());
  final PriorityController priorityController = Get.find();
  final ProjectController projectController = Get.find();
  DateTime dt = DateTime.now();
  // ScrollController _scrollController = ScrollController();
  late Animation<double> _animation;
  late AnimationController _animationController;
  // late TabController _tabController;
  @override
  void initState() {
    // _scrollController.addListener(_scrollListener);
    // _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    apiCall(context);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  var isLoading = false.obs;

  Future<void> apiCall(BuildContext context1) async {
    isLoading.value = true;
    await StorageHelper.setIsCurrentDate(dt.toString());
    await checkStoredNotificationData();
    await homeController.anniversarylist(context1);
    isLoading.value = false;
    await profileController.dailyTaskList(context1, '', '');

    if (dt.toString() != StorageHelper.getIsCurrentDate().toString()) {
      await homeController.onetimeMsglist().then((_) {
        if (homeController.onTimemsg.value.isNotEmpty) {
          openOneTimeMsg(
            homeController.onTimemsg.value,
            homeController.onTimemsgUrl.value,
          );
        }
      });
    }

    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     homeController.isButtonVisible.value = false;
    //   } else if (_scrollController.position.pixels ==
    //       _scrollController.position.minScrollExtent) {
    //     homeController.isButtonVisible.value = true;
    //   }
    // });
  }

  _launchURL(param0) async {
    final Uri url = Uri.parse('$param0');
    ErrorDescription(message);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> openOneTimeMsg(String value, String urlValue) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _launchURL(urlValue);
                        },
                        child: Text(
                          urlValue,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: blueColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () {
                    List<String> listSplitDt = dt.toString().split(' ');
                    StorageHelper.setIsCurrentDate(
                      listSplitDt.first.toString(),
                    );
                    Get.back();
                  },
                  child: Icon(Icons.close, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkStoredNotificationData() async {
    final prefs = await SharedPreferences.getInstance();
    String? notificationData = prefs.getString('notification_data');
    if (notificationData.toString() != "null" &&
        notificationData.toString() != "") {}
  }

  Future onrefresher() async {
    String cacheKey = 'home_data_cache';
    final cacheManager = DefaultCacheManager();
    await cacheManager.removeFile('$cacheKey');

    await homeController.homeDataApi('');
    await homeController.leadHomeApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          }
        },
        child: SafeArea(child: _buildHomeContent()),
      ),
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Calender",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.calendar_today,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              if (Platform.isAndroid) {
                final intent = AndroidIntent(
                  action: 'android.intent.action.VIEW',
                  data: 'content://com.android.calendar/time/',
                  flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                );
                await intent.launch();
              } else {
                print("Calendar launch not supported on this platform");
              }
            },
          ),
          Bubble(
            title: "Task",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.task,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddTask(
                        priorityController.priorityList,
                        taskController.allProjectDataList,
                        taskController.responsiblePersonList,
                        0,
                        "",
                      ),
                    ),
              );
              _animationController.reverse();
            },
          ),
        ],
        animation: _animation,
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
        iconColor: whiteColor,
        iconData: Icons.add,
        backGroundColor: primaryColor,
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: onrefresher,
      child: SingleChildScrollView(
        // controller: _scrollController,
        // physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          return Column(
            children: [
              if (homeController.anniversaryListData.isNotEmpty)
                AutoScrollList(homeController.anniversaryListData),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    todaySummary(
                      homeController.homeDataModel.value?.newTask ?? 0,
                      homeController.homeDataModel.value?.dueTodayTask ?? 0,
                    ),
                    SizedBox(height: 10.h),
                    dailyActivityAndPending(),
                    SizedBox(height: 10.h),
                    summary(),
                    if (StorageHelper.getAssignedDept() != null)
                      SizedBox(height: 10.h),
                    if (homeController.userReportDataList.isNotEmpty)
                      AdminUserList(
                        (homeController.homeDataModel.value?.users ?? []).obs,
                        taskController,
                        homeController,
                      ),
                    SizedBox(height: 10.h),
                    HomeTask(
                      (homeController.homeDataModel.value?.tasklist ?? []).obs,
                      taskController,
                    ),
                    SizedBox(height: 10.h),
                    discussion(
                      (homeController.homeDataModel.value?.chatlist ?? []).obs,
                      (homeController.homeDataModel.value?.latestComments ?? [])
                          .obs,
                    ),
                    SizedBox(height: 10.h),
                    pinedData(
                      (homeController.homeDataModel.value?.pinnedNotes ?? [])
                          .obs,
                    ),
                    SizedBox(height: 10.h),
                    HomeEventSummary(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHomeLeadContent() {
    return RefreshIndicator(
      onRefresh: onrefresher,
      child: SingleChildScrollView(
        // controller: _scrollController,
        child: Obx(() {
          return Column(
            children: [
              if (homeController.anniversaryListData.isNotEmpty)
                AutoScrollList(homeController.anniversaryListData),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    leadTodaySummary(homeController.homeLeadData.value),
                    SizedBox(height: 10.h),
                    leadDailyActivityAndPending(
                      homeController.homeLeadData.value,
                    ),
                    SizedBox(height: 10.h),
                    leadSummary(homeController.homeLeadData.value),
                    SizedBox(height: 10.h),
                    HomeLeads(homeController.homeLeadData.value),
                    SizedBox(height: 10.h),
                    leadDiscussion(
                      (homeController.homeDataModel.value?.chatlist ?? []).obs,
                      (homeController.homeDataModel.value?.latestComments ?? [])
                          .obs,
                    ),
                    SizedBox(height: 10.h),
                    leadPinedData(homeController.homeLeadData.value),
                    SizedBox(height: 10.h),
                    HomeEventSummary(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget dailyActivityAndPending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTitle(dailyActivityAndPendingText),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => DailyActivity());
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: boxBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(18.r)),
                    color: whiteColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/image/svg/blue_activity.svg',
                                  height: 32.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Daily\nActivity",
                                  style: heading7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SvgPicture.asset(chevronRightIcon),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await ShowDialogFunction().pendingDialog(
                    context,
                    homeController.homeDataModel.value?.progressTask ?? 0,
                    homeController.homeLeadData.value?.pendingMeetings ?? 0,
                    homeController.homeDataModel.value?.pendingMeetings ?? 0,
                    homeController.homeLeadData.value?.newLeads ?? 0,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: boxBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(18.r)),
                    color: whiteColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  whatsPendingIcon,
                                  height: 32.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "What’s\nPending?",
                                  style: heading7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SvgPicture.asset(chevronRightIcon),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget leadDailyActivityAndPending(HomeLeadData? leadData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTitle("Daily Activity"),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => AllFollowupsList(from: 'home'));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: boxBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(18.r)),
                    color: whiteColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(todayIcon, height: 32.h),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Follow-ups",
                                      style: heading7,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${leadData?.totalfollowups ?? ""}",
                                      style: heading7,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SvgPicture.asset(chevronRightIcon),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await ShowDialogFunction().pendingDialog(
                    context,
                    homeController.homeDataModel.value?.progressTask ?? 0,
                    homeController.homeLeadData.value?.pendingMeetings ?? 0,
                    homeController.homeDataModel.value?.pendingMeetings ?? 0,
                    homeController.homeLeadData.value?.newLeads ?? 0,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: boxBorderColor),
                    borderRadius: BorderRadius.all(Radius.circular(18.r)),
                    color: whiteColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  whatsPendingIcon,
                                  height: 32.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "What’s\nPending?",
                                  style: heading7,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SvgPicture.asset(chevronRightIcon),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source, String type) async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 30,
      );
      if (pickedImage == null) {
        return;
      }
      taskController.isProfilePicUploading.value = true;
      taskController.pickedFile.value = File(pickedImage.path);
      taskController.profilePicPath.value = pickedImage.path.toString();

      taskController.isProfilePicUploading.value = false;
    } catch (e) {
      taskController.isProfilePicUploading.value = false;
    } finally {
      taskController.isProfilePicUploading.value = false;
    }
  }

  final TextEditingController menuController = TextEditingController();
  final controller = MultiSelectController<ResponsiblePersonData>();
  final dropDownKey = GlobalKey<DropdownSearchState>();
  Widget selectUser() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: lightBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: DropdownMenu<ResponsiblePersonData>(
          controller: menuController,
          width: double.infinity,
          trailingIcon: Image.asset(
            'assets/images/png/Vector 3.png',
            color: primaryColor,
            height: 8.h,
          ),
          selectedTrailingIcon: Image.asset(
            'assets/images/png/Vector 3.png',
            color: primaryColor,
            height: 8.h,
          ),
          menuHeight: 350.h,
          hintText: "Select User",
          requestFocusOnTap: true,
          enableSearch: true,
          enableFilter: true,
          inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all<Color>(whiteColor),
          ),
          onSelected: (ResponsiblePersonData? value) {
            if (value != null) {
              taskController.selectedResponsiblePersonData.value = value;
              homeController.homeDataApi(
                taskController.selectedResponsiblePersonData.value?.id,
              );
            }
          },
          dropdownMenuEntries:
              taskController.responsiblePersonList
                  .map<DropdownMenuEntry<ResponsiblePersonData>>((
                    ResponsiblePersonData menu,
                  ) {
                    return DropdownMenuEntry<ResponsiblePersonData>(
                      value: menu,
                      label: menu.name ?? '',
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }

  Widget todaySummary(int newTask, int dueTodayTask) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTitle(todaySummaryText),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => TaskScreenPage(
                        taskType: 'New Task',
                        assignedType: "Assigned to me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: boxBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(18.r)),
                      color: whiteColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/image/svg/new_task.svg',
                          height: 34.sp,
                          width: 34.sp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                newTaskText,
                                style: heading7,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Obx(
                                () => Text(
                                  "${homeController.homeDataModel.value?.newTask ?? 0}",
                                  style: heading9,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => TaskScreenPage(
                        taskType: 'Due Today',
                        assignedType: "Assigned to me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString(),
                      ),
                    );
                  },
                  child: TaskInfo(
                    dueToday,
                    dueTodayTask,
                    'assets/image/svg/orange_svg_icon.svg',
                    Color.fromARGB(255, 152, 33, 243),
                    whiteColor,
                    whiteColor,
                    // dueTodayTaskBoxColor1,
                    // gradientSecondaryBoxColor2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget leadTodaySummary(HomeLeadData? leadData) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTitle(todaySummaryText),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => LeadList(status: 'new lead'));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: boxBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(18.r)),
                      color: whiteColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          newTaskSvgIcon,
                          height: 34.sp,
                          width: 34.sp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New Leads",
                                style: heading7,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                "${leadData?.newLeads ?? ""}",
                                style: heading9,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => GetMeetingList(
                        leadId: '',
                        contactList: <LeadContactData>[].obs,
                        from: 'home',
                        addPeople: [],
                        assignPeople: [],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: boxBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(18.r)),
                      color: whiteColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/image/svg/assigned_new_icon.png",
                          height: 34.sp,
                          width: 34.sp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Visits/Meeting",
                                style: heading7,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                "${leadData?.totalmeedtings ?? ""}",
                                style: heading9,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget summary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTitle(overview),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskScreenPage(
                      taskType: 'All Task',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: Obx(
                  () => TaskInfo(
                    totalTaskText,
                    homeController.totalTask.value,
                    totalTaskSvgIcon,
                    const Color.fromARGB(255, 76, 175, 175),
                    whiteColor,
                    whiteColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskScreenPage(
                      taskType: 'All Task',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: Obx(
                  () => TaskInfo(
                    assignedTaskText,
                    homeController.homeDataModel.value?.totalTaskAssigned ?? 0,
                    "assets/image/svg/assigneed_svg_icon.svg",
                    const Color.fromARGB(255, 244, 54, 54),
                    whiteColor,
                    whiteColor,
                    // asignedTaskBoxColor1,
                    // gradientSecondaryBoxColor2,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskScreenPage(
                      taskType: 'Progress',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: Obx(
                  () => TaskInfo(
                    progressTaskText,
                    homeController.homeDataModel.value?.progressTask ?? 0,
                    "assets/image/svg/assigned_new_icon.png",
                    Colors.blue,
                    whiteColor,
                    whiteColor,
                    // totalTaskBoxColor1,
                    // gradientSecondaryBoxColor2,
                  ),
                ),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskScreenPage(
                      taskType: 'Past Due',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: Obx(
                  () => TaskInfo(
                    pastDueDate,
                    homeController.homeDataModel.value?.totalTasksPastDue ?? 0,
                    assignedTaskSvgIcon,
                    const Color.fromARGB(255, 255, 163, 59),
                    // pastDueTaskBoxColor1,
                    // gradientSecondaryBoxColor2,
                    whiteColor,
                    whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget leadSummary(HomeLeadData? leadData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTitle(overview),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => LeadList(status: "total"));
                },
                child: TaskInfo(
                  "Total Leads",
                  leadData?.totalLeads ?? 0,
                  totalTaskSvgIcon,
                  const Color.fromARGB(255, 76, 175, 175),
                  whiteColor,
                  whiteColor,
                  // totalTaskBoxColor1,
                  // gradientSecondaryBoxColor2,
                ),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => LeadList(status: "pl"));
                },
                child: TaskInfo(
                  "PLS",
                  leadData?.plLeads ?? 0,
                  'assets/image/svg/new_task.svg',
                  const Color.fromARGB(255, 244, 54, 54),
                  // asignedTaskBoxColor1,
                  // gradientSecondaryBoxColor2,
                  whiteColor,
                  whiteColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => LeadList(status: "spl"));
                },
                child: TaskInfo(
                  "SPLS",
                  leadData?.splLeads ?? 0,
                  dueTodayIcon,
                  Color.fromARGB(255, 152, 33, 243),
                  whiteColor,
                  whiteColor,
                  // dueTodayTaskBoxColor1,
                  // gradientSecondaryBoxColor2,
                ),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => LeadList(status: "quotation"));
                },
                child: TaskInfo(
                  'Quotation',
                  leadData?.quotationLeads ?? 0,
                  pastDueDateTaskSvgIcon,
                  const Color.fromARGB(255, 255, 163, 59),
                  whiteColor,
                  whiteColor,
                  // pastDueTaskBoxColor1,
                  // gradientSecondaryBoxColor2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => LeadList(status: "won"));
                    },
                    child: TaskInfo(
                      "Won",
                      leadData?.convertedLeads ?? 0,
                      "assets/image/svg/assigneed_svg_icon.svg",
                      Colors.blue,
                      whiteColor,
                      whiteColor,
                      // totalTaskBoxColor1,
                      // gradientSecondaryBoxColor2,
                    ),
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => LeadList(status: 'lost'));
                    },
                    child: TaskInfo(
                      "Future Leads",
                      leadData?.closedLeads ?? 0,
                      assignedTaskSvgIcon,
                      Colors.blue,
                      whiteColor,
                      whiteColor,
                      // totalTaskBoxColor1,
                      // gradientSecondaryBoxColor2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add spacing if needed
            // Remove Expanded here unless it's inside a scrollable or constrained widget
            // InkWell(
            //   onTap: () {
            //     Get.to(LeadPaymentsScreens());
            //   },
            //   child: TaskInfo(
            //     "Lead Payment",
            //     leadData?.closedLeads ?? 0,
            //     totalTaskSvgIcon,
            //     Colors.blue,
            //     totalTaskBoxColor1,
            //     gradientSecondaryBoxColor2,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget projectWidget(RxList homeProjectList) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: boxBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(18.r)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [totalTaskBoxColor1, gradientSecondaryBoxColor2],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Column(children: []),
    );
  }

  Widget discussion(
    RxList<Chatlist> homeChatList,
    RxList<LatestComments> letestComent,
  ) {
    return Container(
      height: 360.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeTitle(discussionText),
              InkWell(
                onTap: () {
                  bottomBarController.currentPageIndex.value = 1;
                  Get.to(
                    BottomNavigationBarExample(from: 'home', payloadData: {}),
                  );
                },
                child: Text(
                  seeAll,
                  style: changeTextColor(heading7, seeAllColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      homeController.isGeneralSelected.value = true;
                      homeController.isTaskCommentSelected.value = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            homeController.isGeneralSelected.value
                                ? selectedTabBarColor
                                : whiteColor,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(generalIcon, height: 26.h),
                          SizedBox(width: 8.w),
                          Text(generalText, style: heading6),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      homeController.isGeneralSelected.value = false;
                      homeController.isTaskCommentSelected.value = true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            homeController.isTaskCommentSelected.value
                                ? selectedTabBarColor
                                : whiteColor,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(discussionTaskIcon, height: 26.h),
                          SizedBox(width: 8.w),
                          Text(taskComents, style: heading6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: boxBorderColor),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: lightGreyColor.withOpacity(0.1),
                    blurRadius: 13.0,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:
                  homeController.isGeneralSelected.value
                      ? HomeDiscussionList(homeChatList)
                      : HomeTaskList(letestComent),
            ),
          ),
        ],
      ),
    );
  }

  Widget leadDiscussion(
    RxList<Chatlist> homeChatList,
    RxList<LatestComments> commentList,
  ) {
    return Container(
      height: 360.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeTitle(discussionText),
              InkWell(
                onTap: () {
                  bottomBarController.currentPageIndex.value = 1;
                  Get.to(
                    BottomNavigationBarExample(from: 'home', payloadData: {}),
                  );
                },
                child: Text(
                  seeAll,
                  style: changeTextColor(heading7, seeAllColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      homeController.isGeneralSelected.value = true;
                      homeController.isTaskCommentSelected.value = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            homeController.isGeneralSelected.value
                                ? selectedTabBarColor
                                : whiteColor,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(generalIcon, height: 26.h),
                          SizedBox(width: 8.w),
                          Text(generalText, style: heading6),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      homeController.isGeneralSelected.value = false;
                      homeController.isTaskCommentSelected.value = true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            homeController.isTaskCommentSelected.value
                                ? selectedTabBarColor
                                : whiteColor,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(discussionTaskIcon, height: 26.h),
                          SizedBox(width: 8.w),
                          Text("Lead Comments", style: heading6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: boxBorderColor),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: lightGreyColor.withOpacity(0.1),
                    blurRadius: 13.0,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:
                  homeController.isGeneralSelected.value
                      ? HomeDiscussionList(homeChatList)
                      : HomeTaskList(commentList),
            ),
          ),
        ],
      ),
    );
  }

  RxList<Color> pinnedColorList =
      <Color>[
        pinnedColor1,
        pinnedColor2,
        pinnedColor3,
        pinnedColor4,
        pinnedColor5,
        pinnedColor6,
        pinnedColor7,
      ].obs;
  Widget leadPinedData(HomeLeadData? leadData) {
    return Container(
      height: 300.h,
      width: double.infinity,
      padding: EdgeInsets.all(0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeTitle(pinedText),
              InkWell(
                onTap: () {
                  Get.to(() => NotesFolder());
                },
                child: Text(
                  seeAll,
                  style: changeTextColor(heading7, seeAllColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: boxBorderColor),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: lightGreyColor.withOpacity(0.1),
                    blurRadius: 13.0,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:
                  (leadData?.pinnedNotes ?? []).isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/png/pinned 1 (1).png',
                              height: 80.h,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'No pinned notes available',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: leadData?.pinnedNotes?.length,
                        itemBuilder: (context, index) {
                          var note = leadData?.pinnedNotes?[index];
                          quill.QuillController? quillController;
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
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
                                      child: viewNotesBottomSheet(
                                        context,
                                        note,
                                      ),
                                    ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 6.h,
                                horizontal: 8.w,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    pinnedColorList[index %
                                        pinnedColorList.length],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${leadData?.pinnedNotes?[index].title ?? ""}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pinedData(RxList<HomePinnedNotes> homePinnedNotes) {
    return Container(
      height: 300.h,
      width: double.infinity,
      padding: EdgeInsets.all(0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HomeTitle(pinedText),
              InkWell(
                onTap: () {
                  Get.to(() => NotesFolder());
                },
                child: Text(
                  seeAll,
                  style: changeTextColor(heading7, seeAllColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: boxBorderColor),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: lightGreyColor.withOpacity(0.1),
                    blurRadius: 13.0,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Obx(
                () =>
                    homePinnedNotes.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image/png/pinned 1 (1).png',
                                height: 80.h,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'No pinned notes available',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: homePinnedNotes.length,
                          itemBuilder: (context, index) {
                            var note = homePinnedNotes[index];
                            quill.QuillController? quillController;
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
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
                                        child: viewNotesBottomSheet(
                                          context,
                                          note,
                                        ),
                                      ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 6.h,
                                  horizontal: 8.w,
                                ),
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color:
                                      pinnedColorList[index %
                                          pinnedColorList.length],
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${homePinnedNotes[index].title ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    if (quillController != null)
                                      quill.QuillEditor(
                                        controller: quillController,
                                        focusNode: FocusNode(),
                                        scrollController: ScrollController(),
                                        config: quill.QuillEditorConfig(
                                          enableInteractiveSelection: false,
                                          showCursor: false,
                                          expands: false,
                                          padding: EdgeInsets.zero,
                                          scrollable: true,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewNotesBottomSheet(BuildContext context, dynamic homePinnedNot) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 400.h,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${homePinnedNot['title']}',
                  style: changeTextColor(rubikBlack, darkGreyColor),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: 335.w,
              child: Text(
                '${homePinnedNot['description']}',
                style: changeTextColor(rubikRegular, lightGreyColor),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Container(
                  height: 10.h,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color:
                        homePinnedNot['tags'].toString() == '1'
                            ? Colors.blue
                            : homePinnedNot['tags'].toString() == '2'
                            ? Colors.green
                            : homePinnedNot['tags'].toString() == '3'
                            ? Colors.yellow[800]
                            : Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '${homePinnedNot['tags'].toString() == '1'
                      ? "Work"
                      : homePinnedNot['tags'].toString() == '2'
                      ? 'Social'
                      : homePinnedNot['tags'].toString() == '3'
                      ? 'Personal'
                      : 'Public'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        homePinnedNot['tags'].toString() == '1'
                            ? Colors.blue
                            : homePinnedNot['tags'].toString() == '2'
                            ? Colors.green
                            : homePinnedNot['tags'].toString() == '3'
                            ? Colors.yellow[800]
                            : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
