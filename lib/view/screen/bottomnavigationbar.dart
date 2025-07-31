// import 'dart:io';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:task_management/constant/color_constant.dart';
// import 'package:task_management/constant/custom_toast.dart';
// import 'package:task_management/constant/text_constant.dart';
// import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
// import 'package:task_management/controller/chat_controller.dart';
// import 'package:task_management/controller/document_controller.dart';
// import 'package:task_management/controller/notification_controller.dart';
// import 'package:task_management/controller/priority_controller.dart';
// import 'package:task_management/controller/profile_controller.dart';
// import 'package:task_management/controller/project_controller.dart';
// import 'package:task_management/controller/task_controller.dart';
// import 'package:task_management/controller/user_controller.dart';
// import 'package:task_management/custom_widget/button_widget.dart';
// import 'package:task_management/custom_widget/task_text_field.dart';
// import 'package:task_management/helper/storage_helper.dart';
// import 'package:task_management/model/all_project_list_model.dart';
// import 'package:task_management/model/priority_model.dart';
// import 'package:task_management/model/responsible_person_list_model.dart';
// import 'package:task_management/view/screen/add_project.dart';
// import 'package:task_management/view/screen/chat_list.dart';
// import 'package:task_management/view/screen/document.dart';
// import 'package:task_management/view/screen/feed.dart';
// import 'package:task_management/view/screen/home_screen.dart';
// import 'package:task_management/view/screen/notification.dart';
// import 'package:task_management/view/screen/profile.dart';
// import 'package:task_management/view/screen/reports.dart';
// import 'package:task_management/view/screen/todo_list.dart';
// import 'package:task_management/view/widgets/custom_calender.dart';
// import 'package:task_management/view/widgets/custom_dropdawn.dart';
// import 'package:task_management/view/widgets/custom_timer.dart';
// import 'package:task_management/view/widgets/department_list_widget.dart';
// import 'package:task_management/view/widgets/drawer.dart';
// import 'package:task_management/view/widgets/image_screen.dart';
// import 'package:task_management/view/widgets/pdf_screen.dart';
// import 'package:task_management/view/widgets/responsible_person_list.dart';

// class BottomNavBar extends StatefulWidget {
//   final String? from;
//   const BottomNavBar({super.key, this.from});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   final BottomBarController bottomBarController =
//       Get.put(BottomBarController());
//   final DocumentController documentController = Get.put(DocumentController());
//   final ChatController chatController = Get.put(ChatController());
//   final TaskController taskController = Get.put(TaskController());
//   final PriorityController priorityController = Get.put(PriorityController());
//   final ProjectController projectController = Get.put(ProjectController());
//   final ProfileController profileController = Get.put(ProfileController());
//   final NotificationController notificationController =
//       Get.put(NotificationController());
//   final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
//   var profilePicPath = ''.obs;
//   @override
//   void initState() {
//     profilePicPath.value = StorageHelper.getImage();
//     priorityController.priorityApi();
//     taskController.allProjectListApi();
//     chatController.chatListApi();
//     taskController.responsiblePersonListApi(StorageHelper.getDepartmentId());
//     notificationController.notificationListApi('');
//     super.initState();
//     userPageControlelr.roleListApi(StorageHelper.getDepartmentId());
//   }

//   String? selectedValue;
//   List<int> selectedItems = [];
//   final List<DropdownMenuItem> items = [];

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const ChatList(),
//     const FeedPage(),
//     const ReportScreen(),
//     const DocumentFile(),
//   ];
//   bool _isBackButtonPressed = false;
//   @override
//   void dispose() {
//     profileController.selectedDepartMentListData.value = null;
//     projectController.selectedAllProjectListData.value = null;
//     taskController.reviewerCheckBox.clear();
//     taskController.reviewerUserId.clear();
//     taskController.responsiblePersonSelectedCheckBox.clear();
//     taskController.assignedUserId.clear();
//     super.dispose();
//   }

//   Future<bool> _onWillPop() async {
//     if (!_isBackButtonPressed) {
//       return await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Confirm Exit'),
//               content: Text('Are you sure you want to exit the app?'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                     SystemNavigator.pop();
//                   },
//                   child: Text('Confirm'),
//                 ),
//               ],
//             ),
//           ) ??
//           false;
//     } else {
//       return true;
//     }
//   }

//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => bottomBarController.isUpdating.value == true &&
//               profileController.isdepartmentListLoading.value == true &&
//               priorityController.isPriorityLoading.value == true &&
//               projectController.isAllProjectCalling.value == true &&
//               notificationController.isNotificationLoading.value == true &&
//               chatController.isChatLoading.value == true
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           // ignore: deprecated_member_use
//           : WillPopScope(
//               onWillPop: _onWillPop,
//               child: Scaffold(
//                 resizeToAvoidBottomInset: false,
//                 key: _key,
//                 backgroundColor: whiteColor,
//                 drawer: Obx(
//                   () =>
//                       SideDrawer(userPageControlelr.selectedRoleListData.value),
//                 ),
//                 appBar: AppBar(
//                   // automaticallyImplyLeading: false,
//                   backgroundColor: backgroundColor,
//                   leading: documentController.isLeadingVisible.value == true
//                       ? IconButton(
//                           icon: Icon(Icons.arrow_back),
//                           onPressed: () {
//                             if (documentController.navigationStack.isNotEmpty) {
//                               documentController.currentPath =
//                                   documentController.navigationStack
//                                       .removeLast();
//                             }
//                           },
//                         )
//                       : null,
//                   title: Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.to(ProfilePage());
//                         },
//                         child: Container(
//                           height: 40.h,
//                           width: 40.w,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: primaryColor),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20.r),
//                             ),
//                           ),
//                           child: Obx(
//                             () => ClipRRect(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(20.r),
//                               ),
//                               child: Image.network(
//                                 profileController
//                                         .profilePicPath.value.isNotEmpty
//                                     ? '${profileController.profilePicPath.value}'
//                                     : profilePicPath.value,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.asset(
//                                     'assets/images/png/profile-image-removebg-preview.png',
//                                     fit: BoxFit.cover,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 7.w),
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               hello,
//                               style: TextStyle(
//                                   fontSize: 13.sp,
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                             Text(
//                               '${StorageHelper.getName()}',
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     InkWell(
//                       onTap: () {
//                         chatController.deleteChat();
//                       },
//                       child: Obx(
//                         () => chatController.isLongPressed.contains(true)
//                             ? Icon(Icons.delete)
//                             : SizedBox(),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 12.w,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Get.to(const NotificationPage());
//                       },
//                       child: Obx(
//                         () => Badge(
//                           isLabelVisible:
//                               notificationController.notificationCounter.value >
//                                       0
//                                   ? true
//                                   : false,
//                           label: Text(
//                               '${notificationController.notificationCounter.value}'),
//                           child: SvgPicture.asset(
//                             'assets/images/svg/icon.svg',
//                             height: 20.h,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 12.w,
//                     ),
//                     // InkWell(
//                     //   onTap: () => _key.currentState?.openDrawer(),
//                     //   child: SvgPicture.asset(
//                     //     'assets/images/svg/menu.svg',
//                     //     height: 30.h,
//                     //   ),
//                     // ),
//                     // SizedBox(
//                     //   width: 12.w,
//                     // )
//                   ],
//                 ),
//                 body: SafeArea(
//                   child: Stack(
//                     children: [
//                       _pages[bottomBarController.currentPageIndex.value],
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 0.h),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15.r)),
//                               border: Border.all(
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                             child: ClipRRect(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15.r)),
//                               child: BottomAppBar(
//                                 color: Colors.transparent,
//                                 elevation: 0,
//                                 shape: CircularNotchedRectangle(),
//                                 child: Material(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(15.r)),
//                                   child: Container(
//                                     height: 80.h,
//                                     decoration: BoxDecoration(
//                                       color: whiteColor,
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(15.r),
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color:
//                                               lightGreyColor.withOpacity(0.2),
//                                           blurRadius: 13.0,
//                                           spreadRadius: 2,
//                                           blurStyle: BlurStyle.normal,
//                                           offset: Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         _buildNavItem(
//                                             0,
//                                             'assets/images/png/home-logo.png',
//                                             'Home',
//                                             'assets/images/png/white_home.png'),
//                                         _buildNavItem(
//                                             1,
//                                             'assets/images/png/Message square.png',
//                                             'Chat',
//                                             "assets/images/png/WHITE_CHAT.png"),
//                                         _buildNavItem(
//                                             2,
//                                             'assets/images/png/Component.png',
//                                             'Alerts',
//                                             "assets/images/png/Component (1).png"),
//                                         _buildNavItem(
//                                             3,
//                                             'assets/images/png/line-chart-up-01.png',
//                                             'Report',
//                                             "assets/images/png/line-chart-up-01 (1).png"),
//                                         _buildNavItem(
//                                             4,
//                                             'assets/images/png/grid-01.png',
//                                             'Documents',
//                                             "assets/images/png/grid-01 (1).png"),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 55.h,
//                         left: 150.w,
//                         child: floatingActionButton(),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget floatingActionButton() {
//     return Obx(
//       () => bottomBarController.currentPageIndex.value == 0
//           ? InkWell(
//               onTap: () {
//                 showAlertDialog(
//                     context,
//                     taskController.allProjectDataList,
//                     taskController.responsiblePersonList,
//                     priorityController.priorityList);
//               },
//               child: Container(
//                 height: 50.h,
//                 width: 50.w,
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(27.r),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: lightGreyColor.withOpacity(0.2),
//                       blurRadius: 13.0,
//                       spreadRadius: 2,
//                       blurStyle: BlurStyle.normal,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.add,
//                     color: whiteColor,
//                     size: 30.sp,
//                   ),
//                 ),
//               ),
//             )
//           : SizedBox(),
//     );
//   }

//   Widget _buildNavItem(
//       int index, String iconPath, String label, String whiteImage) {
//     bool isSelected = bottomBarController.currentPageIndex.value == index;
//     return InkWell(
//       onTap: () {
//         bottomBarController.currentPageIndex.value = index;
//         if (index == 4) {
//           documentController.isLeadingVisible.value = true;
//         }
//       },
//       child: Badge(
//         isLabelVisible: index == 1
//             ? chatController.totalUnsenMessage.value > 0
//                 ? true
//                 : false
//             : false,
//         label: Obx(() => Text('${chatController.totalUnsenMessage.value}')),
//         child: Container(
//           height: 37.h,
//           decoration: BoxDecoration(
//             color: isSelected ? secondaryColor : whiteColor,
//             borderRadius: BorderRadius.all(Radius.circular(50.r)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: Row(
//               children: [
//                 Image.asset(
//                   isSelected ? whiteImage : iconPath,
//                   height: 18.h,
//                   color: isSelected ? whiteColor : tabIconColor,
//                 ),
//                 if (isSelected)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 5),
//                     child: Text(
//                       label,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: whiteColor,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> showAlertDialog(
//     BuildContext context,
//     RxList<AllProjectListData> allProjectDataList,
//     RxList<ResponsiblePersonData> responsiblePersonList,
//     RxList<PriorityData> priorityList,
//   ) async {
//     return showDialog(
//         // barrierDismissible: false,
//         context: context,
//         builder: (BuildContext builderContext) {
//           return Dialog(
//             backgroundColor: Colors.transparent,
//             insetPadding: EdgeInsets.all(10.sp),
//             child: Container(
//               width: double.infinity,
//               height: 140.h,
//               decoration: BoxDecoration(
//                 color: whiteColor,
//                 borderRadius: BorderRadius.circular(15.r),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 15.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Add New",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomButton(
//                           onPressed: () async {
//                             taskNameController.clear();
//                             remarkController.clear();
//                             startDateController.clear();
//                             dueDateController.clear();
//                             dueTimeController.clear();

//                             profileController.selectedDepartMentListData.value =
//                                 null;

//                             taskController.assignedUserId.clear();
//                             taskController.reviewerUserId.clear();
//                             taskController.reviewerCheckBox.clear();
//                             taskController.responsiblePersonSelectedCheckBox
//                                 .clear();
//                             taskController.responsiblePersonSelectedCheckBox
//                                 .addAll(List<bool>.filled(
//                                     responsiblePersonList.length, false));
//                             taskController.reviewerCheckBox.addAll(
//                                 List<bool>.filled(
//                                     taskController.responsiblePersonList.length,
//                                     false));

//                             taskController.profilePicPath.value = '';
//                             priorityController.selectedPriorityData.value ==
//                                 null;

//                             taskController.selectedAllProjectListData.value =
//                                 null;
//                             profileController.selectedDepartMentListData.value =
//                                 null;
//                             taskController.selectedAllProjectListData.value =
//                                 taskController.allProjectDataList.first;
//                             await showModalBottomSheet(
//                               context: context,
//                               isScrollControlled: true,
//                               builder: (context) => Padding(
//                                 padding: EdgeInsets.only(
//                                     bottom: MediaQuery.of(context)
//                                         .viewInsets
//                                         .bottom),
//                                 child: addTaskBottomSheet(context, priorityList,
//                                     allProjectDataList, responsiblePersonList),
//                               ),
//                             );
//                           },
//                           text: Text(
//                             addTask2,
//                             style: TextStyle(color: whiteColor),
//                           ),
//                           width: 101.w,
//                           color: primaryColor,
//                           height: 40.h,
//                         ),
//                         CustomButton(
//                           onPressed: () {
//                             Get.to(AddProject());
//                           },
//                           text: Text(
//                             addProject,
//                             style: TextStyle(color: whiteColor),
//                           ),
//                           width: 101.w,
//                           color: secondaryColor,
//                           height: 40.h,
//                         ),
//                         CustomButton(
//                           onPressed: () {
//                             Get.to(ToDoList(''));
//                           },
//                           text: Text(
//                             todo,
//                             style: TextStyle(color: whiteColor),
//                           ),
//                           width: 101.w,
//                           color: chatColor,
//                           height: 40.h,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15.h,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   Widget bottomSheet(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(20.r)),
//       ),
//       width: double.infinity,
//       height: 150.h,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.w),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Add New",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomButton(
//                       onPressed: () {},
//                       text: Text(
//                         create,
//                         style: TextStyle(color: whiteColor),
//                       ),
//                       width: 101.w,
//                       color: primaryColor,
//                       height: 40.h,
//                     ),
//                     CustomButton(
//                       onPressed: () {},
//                       text: Text(
//                         create,
//                         style: TextStyle(color: whiteColor),
//                       ),
//                       width: 101.w,
//                       color: secondaryColor,
//                       height: 40.h,
//                     ),
//                     CustomButton(
//                       onPressed: () {},
//                       text: Text(
//                         create,
//                         style: TextStyle(color: whiteColor),
//                       ),
//                       width: 101.w,
//                       color: chatColor,
//                       height: 40.h,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   final ImagePicker imagePicker = ImagePicker();

//   Future<void> takePhoto(ImageSource source) async {
//     try {
//       final pickedImage =
//           await imagePicker.pickImage(source: source, imageQuality: 5);
//       if (pickedImage == null) {
//         return;
//       }
//       taskController.isProfilePicUploading.value = true;
//       taskController.pickedFile.value = File(pickedImage.path);
//       taskController.profilePicPath.value = pickedImage.path.toString();
//       taskController.isProfilePicUploading.value = false;
//     } catch (e) {
//       taskController.isProfilePicUploading.value = false;
//       print('Error picking image: $e');
//     } finally {
//       taskController.isProfilePicUploading.value = false;
//     }
//   }

//   int selectedProjectId = 0;
//   final TextEditingController taskNameController = TextEditingController();
//   final TextEditingController remarkController = TextEditingController();
//   final TextEditingController startDateController = TextEditingController();
//   final TextEditingController dueDateController = TextEditingController();
//   final TextEditingController dueTimeController = TextEditingController();
//   final TextEditingController menuController = TextEditingController();
//   Widget addTaskBottomSheet(
//       BuildContext context,
//       RxList<PriorityData> priorityList,
//       RxList<AllProjectListData> allProjectDataList,
//       RxList<ResponsiblePersonData> responsiblePersonList) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(20.r)),
//       ),
//       width: double.infinity,
//       height: 610.h,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.w),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       createNewTask,
//                       style: TextStyle(
//                           fontSize: 20.sp, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 TaskCustomTextField(
//                   controller: taskNameController,
//                   textCapitalization: TextCapitalization.sentences,
//                   data: taskName,
//                   hintText: taskName,
//                   labelText: taskName,
//                   index: 0,
//                   focusedIndexNotifier: focusedIndexNotifier,
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 TaskCustomTextField(
//                   controller: remarkController,
//                   textCapitalization: TextCapitalization.sentences,
//                   data: enterRemark,
//                   hintText: enterRemark,
//                   labelText: enterRemark,
//                   index: 1,
//                   maxLine: 3,
//                   focusedIndexNotifier: focusedIndexNotifier,
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectProject,
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           Obx(
//                             () => DropdownButtonHideUnderline(
//                               child: DropdownButton2<AllProjectListData>(
//                                 isExpanded: true,
//                                 items: taskController.allProjectDataList
//                                     .map((AllProjectListData item) {
//                                   return DropdownMenuItem<AllProjectListData>(
//                                     value: item,
//                                     child: Text(
//                                       item.name ?? '',
//                                       style: TextStyle(
//                                         decoration: TextDecoration.none,
//                                         fontFamily: 'Roboto',
//                                         color: darkGreyColor,
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 16,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   );
//                                 }).toList(),
//                                 value: taskController
//                                     .selectedAllProjectListData.value,
//                                 onChanged: (AllProjectListData? value) {
//                                   if (value != null) {
//                                     taskController.selectedAllProjectListData
//                                         .value = value;
//                                     profileController.departmentList(value.id);
//                                   }
//                                 },
//                                 buttonStyleData: ButtonStyleData(
//                                   height: 50,
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.only(
//                                       left: 14, right: 14),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.r),
//                                     border:
//                                         Border.all(color: lightSecondaryColor),
//                                     color: lightSecondaryColor,
//                                   ),
//                                 ),
//                                 hint: Text(
//                                   "Select Project".tr,
//                                   style: TextStyle(
//                                     decoration: TextDecoration.none,
//                                     fontFamily: 'Roboto',
//                                     color: darkGreyColor,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 16,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 iconStyleData: IconStyleData(
//                                   icon: Image.asset(
//                                     'assets/images/png/Vector 3.png',
//                                     color: secondaryColor,
//                                     height: 8.h,
//                                   ),
//                                   iconSize: 14,
//                                   iconEnabledColor: lightGreyColor,
//                                   iconDisabledColor: lightGreyColor,
//                                 ),
//                                 dropdownStyleData: DropdownStyleData(
//                                   maxHeight: 200,
//                                   width: 330,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5.r),
//                                       color: lightSecondaryColor,
//                                       border: Border.all(
//                                           color: lightSecondaryColor)),
//                                   offset: const Offset(0, 0),
//                                   scrollbarTheme: ScrollbarThemeData(
//                                     radius: const Radius.circular(40),
//                                     thickness:
//                                         WidgetStateProperty.all<double>(6),
//                                     thumbVisibility:
//                                         WidgetStateProperty.all<bool>(true),
//                                   ),
//                                 ),
//                                 menuItemStyleData: const MenuItemStyleData(
//                                   height: 40,
//                                   padding: EdgeInsets.only(left: 14, right: 14),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectDepartment,
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           SizedBox(width: 150.w, child: DepartmentList()),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               takePhoto(ImageSource.gallery);
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: primaryColor,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(7.r)),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 12.w, vertical: 10.h),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Attachment",
//                                       style: TextStyle(
//                                         color: whiteColor,
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(width: 5.w),
//                                     Image.asset(
//                                       'assets/images/png/attachment_rounded.png',
//                                       color: whiteColor,
//                                       height: 20.h,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Obx(
//                             () => Badge(
//                               backgroundColor: secondaryPrimaryColor,
//                               isLabelVisible:
//                                   taskController.assignedUserId.isEmpty
//                                       ? false
//                                       : true,
//                               label: Text(
//                                 "${taskController.assignedUserId.length}",
//                                 style:
//                                     TextStyle(color: textColor, fontSize: 16),
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   taskController.assignedUserId.clear();
//                                   taskController
//                                       .responsiblePersonSelectedCheckBox2
//                                       .clear();
//                                   for (var person in responsiblePersonList) {
//                                     taskController
//                                             .responsiblePersonSelectedCheckBox2[
//                                         person.id] = false;
//                                   }
//                                   showModalBottomSheet(
//                                     isScrollControlled: true,
//                                     context: context,
//                                     builder: (context) => Padding(
//                                       padding: EdgeInsets.only(
//                                           bottom: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom),
//                                       child: ResponsiblePersonList('assign'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: secondaryColor,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(7.r)),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 17.w, vertical: 11.2.h),
//                                     child: Text(
//                                       "Assigned To",
//                                       style: TextStyle(
//                                         color: whiteColor,
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Obx(
//                             () => Badge(
//                               backgroundColor: secondaryPrimaryColor,
//                               isLabelVisible:
//                                   taskController.reviewerUserId.isEmpty
//                                       ? false
//                                       : true,
//                               label: Text(
//                                 "${taskController.reviewerUserId.length}",
//                                 style:
//                                     TextStyle(color: textColor, fontSize: 16),
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   taskController.reviewerUserId.clear();
//                                   taskController
//                                       .responsiblePersonSelectedCheckBox2
//                                       .clear();
//                                   for (var person in responsiblePersonList) {
//                                     taskController
//                                             .responsiblePersonSelectedCheckBox2[
//                                         person.id] = false;
//                                   }
//                                   showModalBottomSheet(
//                                     context: context,
//                                     isScrollControlled: true,
//                                     builder: (context) => Padding(
//                                       padding: EdgeInsets.only(
//                                           bottom: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom),
//                                       child: ResponsiblePersonList(
//                                         'reviewer',
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: blueColor,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(7.r)),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20.w, vertical: 11.2.h),
//                                     child: Text(
//                                       "Reviewer",
//                                       style: TextStyle(
//                                         color: whiteColor,
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       taskController.profilePicPath.value.isEmpty
//                           ? SizedBox()
//                           : InkWell(
//                               onTap: () {
//                                 openFile(
//                                     File(taskController.profilePicPath.value));
//                               },
//                               child: Container(
//                                 height: 40.h,
//                                 width: 60.w,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: lightGreyColor),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(8.r)),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   child: Image.file(
//                                     File(taskController.profilePicPath.value),
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Center(
//                                         child: Text(
//                                           "Invalid Image",
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${startDate} *",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           CustomCalender(
//                             hintText: dateFormate,
//                             controller: startDateController,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${dueDate} *",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           CustomCalender(
//                             hintText: dateFormate,
//                             controller: dueDateController,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${dueTime} *",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           CustomTimer(
//                             hintText: "",
//                             controller: dueTimeController,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 161.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${selectPriority} *",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 3.w,
//                           ),
//                           CustomDropdown<PriorityData>(
//                             items: priorityController.priorityList,
//                             itemLabel: (item) => item.priorityName ?? "",
//                             selectedValue: null,
//                             onChanged: (value) {
//                               priorityController.selectedPriorityData.value =
//                                   value;
//                             },
//                             hintText: selectPriority,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Obx(
//                   () => CustomButton(
//                     onPressed: () {
//                       if (taskController.isTaskAdding.value == false) {
//                         if (taskController.assignedUserId.isNotEmpty) {
//                           if (taskController.reviewerUserId.isNotEmpty) {
//                             if (priorityController.selectedPriorityData.value !=
//                                     null &&
//                                 dueTimeController.text.isNotEmpty &&
//                                 dueDateController.text.isNotEmpty &&
//                                 startDateController.text.isNotEmpty) {
//                               if (profileController
//                                       .selectedDepartMentListData.value !=
//                                   null) {
//                                 if (_formKey.currentState!.validate()) {
//                                   taskController.addTask(
//                                       taskNameController.text,
//                                       remarkController.text,
//                                       selectedProjectId,
//                                       profileController
//                                           .selectedDepartMentListData.value?.id,
//                                       startDateController.text,
//                                       dueDateController.text,
//                                       dueTimeController.text,
//                                       priorityController
//                                           .selectedPriorityData.value?.id,
//                                       'bottom');
//                                 }
//                               } else {
//                                 CustomToast().showCustomToast(
//                                     "Please select department.");
//                               }
//                             } else {
//                               CustomToast()
//                                   .showCustomToast("Please select * value.");
//                             }
//                           } else {
//                             CustomToast().showCustomToast(
//                                 "Please select reviewer person.");
//                           }
//                         } else {
//                           CustomToast()
//                               .showCustomToast("Please select assign person.");
//                         }
//                       }
//                     },
//                     text: taskController.isTaskAdding.value == true
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: whiteColor,
//                               ),
//                               SizedBox(
//                                 width: 8.w,
//                               ),
//                               Text(
//                                 loading,
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: whiteColor),
//                               ),
//                             ],
//                           )
//                         : Text(
//                             create,
//                             style: TextStyle(
//                               color: whiteColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                     width: double.infinity,
//                     color: primaryColor,
//                     height: 45.h,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void openFile(File file) {
//     String fileExtension = file.path.split('.').last.toLowerCase();

//     if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ImageScreen(file: file),
//         ),
//       );
//     } else if (fileExtension == 'pdf') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PDFScreen(file: file),
//         ),
//       );
//     } else if (['xls', 'xlsx'].contains(fileExtension)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Excel file viewing not supported yet.')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Unsupported file type.')),
//       );
//     }
//   }
// }
