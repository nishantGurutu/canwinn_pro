import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/add_project.dart';
import 'package:task_management/view/screen/edit_project.dart';
import 'package:task_management/view/screen/project_detail.dart';
import 'package:task_management/view/widgets/assigned_to_me_project.dart';
import 'package:task_management/view/widgets/created_by_me_project.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class Project extends StatefulWidget {
  final String? navigationType;
  const Project(this.navigationType, {super.key});

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ProjectController projectController = Get.put(ProjectController());
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.find();
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    projectController.allProjectListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
          "${project}s",
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
        () =>
            projectController.isAllProjectCalling.value == true
                ? SizedBox(
                  height: 700.h,
                  child: const Center(child: CircularProgressIndicator()),
                )
                : Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.list),
                                SizedBox(width: 5.w),
                                const Text(
                                  'Created by me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.assignment_turned_in),
                                SizedBox(width: 5.w),
                                const Text(
                                  'Assigned to me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            CreatedByMeProject(
                              projectController.createdProjectList,
                              profileController,
                              projectController,
                              taskController,
                              priorityController,
                              homeController,
                            ),
                            AssignedToMeProject(
                              projectController.assignedProjectList,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddProject());
        },
        shape: CircleBorder(),
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: whiteColor, size: 30.h),
      ),
    );
  }

  Widget projectList(RxList<CreatedByMe> allProjectDataList) {
    return Expanded(
      child:
          allProjectDataList.isEmpty
              ? Center(
                child: Text(
                  "No Project available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              )
              : ListView.separated(
                itemCount: allProjectDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  print('date formate ${allProjectDataList[index].createdAt}');
                  DateTime dateTime = DateTime.parse(
                    allProjectDataList[index].createdAt.toString(),
                  );
                  String formattedDate = DateFormat(
                    'dd-MM-yyyy',
                  ).format(dateTime);
                  return Column(
                    children: [
                      SizedBox(height: 5.h),
                      InkWell(
                        onTap: () {
                          Get.to(ProjectDetails(allProjectDataList[index].id));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Project ID ${allProjectDataList[index].id}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        height: 20.h,
                                        width: 30.w,
                                        child: PopupMenuButton<String>(
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (String result) {
                                            switch (result) {
                                              case 'edit':
                                                Get.to(
                                                  EditProject(
                                                    allProjectDataList[index],
                                                  ),
                                                );
                                                break;
                                              case 'delete':
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Delete Project",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: const Text(
                                                        "Are you sure you want to delete this project?",
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        Obx(
                                                          () => ElevatedButton(
                                                            style:
                                                                ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                            onPressed:
                                                                projectController
                                                                        .isProjectDeleting
                                                                        .value
                                                                    ? null
                                                                    : () async {
                                                                      final id =
                                                                          allProjectDataList[index]
                                                                              .id;
                                                                      await projectController
                                                                          .deleteProject(
                                                                            id,
                                                                          );
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop(); // ✅ Dialog close after delete
                                                                    },
                                                            child:
                                                                projectController
                                                                        .isProjectDeleting
                                                                        .value
                                                                    ? const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child: CircularProgressIndicator(
                                                                        color:
                                                                            Colors.white,
                                                                        strokeWidth:
                                                                            2,
                                                                      ),
                                                                    )
                                                                    : const Text(
                                                                      "OK",
                                                                    ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                break;
                                              case 'addTask':
                                                for (var deptId
                                                    in projectController
                                                        .allProjectDataList) {
                                                  if (allProjectDataList[index]
                                                          .id ==
                                                      deptId.id) {
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value = deptId;
                                                    taskController
                                                        .responsiblePersonListApi(
                                                          profileController
                                                              .selectedDepartMentListData
                                                              .value
                                                              ?.id,
                                                          "",
                                                        );
                                                    profileController
                                                        .departmentList(
                                                          projectController
                                                                  .selectedAllProjectListData
                                                                  .value
                                                                  ?.id ??
                                                              0,
                                                        );
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder:
                                                          (context) => Padding(
                                                            padding: EdgeInsets.only(
                                                              bottom:
                                                                  MediaQuery.of(
                                                                        context,
                                                                      )
                                                                      .viewInsets
                                                                      .bottom,
                                                            ),
                                                            child: addTaskBottomSheet(
                                                              context,
                                                              allProjectDataList[index]
                                                                  .id,
                                                            ),
                                                          ),
                                                    );
                                                    return;
                                                  }
                                                }
                                                break;
                                            }
                                          },
                                          itemBuilder:
                                              (
                                                BuildContext context,
                                              ) => <PopupMenuEntry<String>>[
                                                const PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: ListTile(
                                                    leading: Icon(Icons.edit),
                                                    title: Text('Edit'),
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: ListTile(
                                                    leading: Icon(Icons.delete),
                                                    title: Text('Delete'),
                                                  ),
                                                ),
                                                const PopupMenuItem<String>(
                                                  value: 'addTask',
                                                  child: ListTile(
                                                    leading: Icon(Icons.task),
                                                    title: Text('Add Task'),
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${allProjectDataList[index].name}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    '${allProjectDataList[index].description}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    children: [
                                      Text(
                                        '${allProjectDataList[index].priorityName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: blueColor,
                                        ),
                                      ),
                                      Spacer(),
                                      Text('$formattedDate'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.h);
                },
              ),
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: source,
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
      print('Error picking image: $e');
    } finally {
      taskController.isProfilePicUploading.value = false;
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  int selectedProjectId = 0;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();
  Widget addTaskBottomSheet(BuildContext context, int? projectId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 580.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      createNewTask,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                TaskCustomTextField(
                  controller: taskNameController,
                  textCapitalization: TextCapitalization.sentences,
                  data: taskName,
                  hintText: taskName,
                  labelText: taskName,
                  index: 0,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                SizedBox(height: 10.h),
                TaskCustomTextField(
                  controller: remarkController,
                  textCapitalization: TextCapitalization.sentences,
                  data: enterRemark,
                  hintText: enterRemark,
                  labelText: enterRemark,
                  index: 1,
                  maxLine: 3,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectProject,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton2<CreatedByMe>(
                                isExpanded: true,
                                hint: Text(
                                  "Select Project",
                                  style: changeTextColor(
                                    rubikRegular,
                                    darkGreyColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items:
                                    projectController.allProjectDataList
                                        .map(
                                          (CreatedByMe item) =>
                                              DropdownMenuItem<CreatedByMe>(
                                                value: item,
                                                child: Text(
                                                  item.name ?? '',
                                                  style: changeTextColor(
                                                    rubikRegular,
                                                    Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                        )
                                        .toList(),
                                value:
                                    projectController
                                        .selectedAllProjectListData
                                        .value,
                                onChanged: (CreatedByMe? value) {
                                  projectController
                                      .selectedAllProjectListData
                                      .value = value!;
                                  profileController.departmentList(
                                    selectedProjectId,
                                  );
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 45.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(
                                      color: lightSecondaryColor,
                                    ),
                                    color: lightSecondaryColor,
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: secondaryColor,
                                    height: 8.h,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: lightGreyColor,
                                  iconDisabledColor: lightGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200.h,
                                  width: 312.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: lightSecondaryColor,
                                    border: Border.all(
                                      color: lightSecondaryColor,
                                    ),
                                  ),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: WidgetStateProperty.all<double>(
                                      6,
                                    ),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectDepartment,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          CustomDropdown<DepartmentListData>(
                            items: profileController.departmentDataList,
                            itemLabel: (item) => item.name ?? '',
                            onChanged: (value) {
                              profileController
                                  .selectedDepartMentListData
                                  .value = value!;
                              taskController.responsiblePersonListApi(
                                profileController
                                    .selectedDepartMentListData
                                    .value
                                    ?.id,
                                "",
                              );
                            },
                            hintText: selectDepartment,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        takePhoto(ImageSource.gallery);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Attachment",
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Image.asset(
                                'assets/images/png/attachment_rounded.png',
                                color: whiteColor,
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List<String> name = StorageHelper.getName()
                            .toString()
                            .split(' ');
                        String initials = name.map((word) => word[0]).join();
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => Obx(
                                () => assignedTask(
                                  context,
                                  taskController.responsiblePersonList,
                                  initials,
                                ),
                              ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.w,
                            vertical: 11.2.h,
                          ),
                          child: Text(
                            "Assigned To",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        taskController.reviewerCheckBox.addAll(
                          List<bool>.filled(
                            taskController.responsiblePersonList.length,
                            false,
                          ),
                        );
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => reviewerList(
                                context,
                                taskController.responsiblePersonList,
                              ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.all(Radius.circular(7.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 11.2.h,
                          ),
                          child: Text(
                            "Reviewer",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            startDate,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          CustomCalender(
                            hintText: dateFormate,
                            controller: startDateController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dueDate,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          CustomCalender(
                            hintText: dateFormate,
                            controller: dueDateController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dueTime,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          CustomTimer(
                            hintText: "",
                            controller: dueTimeController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectPriority,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.w),
                          CustomDropdown<PriorityData>(
                            items: priorityController.priorityList,
                            itemLabel: (item) => item.priorityName ?? "",
                            onChanged: (value) {
                              priorityController.selectedPriorityData.value =
                                  value;
                            },
                            hintText: selectPriority,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: CustomTextField(
                        controller: timeTextEditingController,
                        textCapitalization: TextCapitalization.none,
                        hintText: alarmReminder,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.lock_clock),
                        data: alarmReminder,
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items:
                                homeController.timeList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Roboto',
                                        color: darkGreyColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                            value:
                                homeController.selectedTime!.value.isEmpty
                                    ? null
                                    : homeController.selectedTime?.value,
                            onChanged: (String? value) {
                              homeController.selectedTime?.value = value ?? '';
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: lightSecondaryColor),
                                color: lightSecondaryColor,
                              ),
                            ),
                            hint: Text(
                              'Select type',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Image.asset(
                                'assets/images/png/Vector 3.png',
                                color: secondaryColor,
                                height: 8.h,
                              ),
                              iconSize: 14,
                              iconEnabledColor: lightGreyColor,
                              iconDisabledColor: lightGreyColor,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 330,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: lightSecondaryColor,
                                border: Border.all(color: lightSecondaryColor),
                              ),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility: WidgetStateProperty.all<bool>(
                                  true,
                                ),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      if (taskController.isTaskAdding.value == false) {
                        if (_formKey.currentState!.validate()) {
                          taskController.addTask(
                            taskNameController.text,
                            remarkController.text,
                            selectedProjectId,
                            startDateController.text,
                            dueDateController.text,
                            dueTimeController.text,
                            priorityController.selectedPriorityData.value?.id,
                            'project',
                            timeTextEditingController.text,
                            homeController.selectedTime?.value ?? '',
                            homeController.selectedDepartMentListData2,
                            '',
                          );
                        }
                      }
                    },
                    text:
                        taskController.isTaskAdding.value == true
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: whiteColor),
                                SizedBox(width: 8.w),
                                Text(
                                  loading,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              create,
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
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reviewerList(
    BuildContext context,
    RxList<ResponsiblePersonData> responsiblePersonList,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 450.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  assignedTaskText2,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                itemCount: responsiblePersonList.length,
                reverse: false,
                itemBuilder: (context, index) {
                  String initialsName = '';
                  if (index < responsiblePersonList.length) {
                    List<String> nameList = responsiblePersonList[index].name
                        .toString()
                        .split(' ');
                    initialsName = nameList.map((word) => word[0]).join();
                  }
                  return index == 0
                      ? SizedBox()
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              color: thirdPrimryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(22.5.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initialsName,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${responsiblePersonList[index].name}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Obx(
                              () => SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Checkbox(
                                  value: taskController.reviewerCheckBox[index],
                                  onChanged: (value) {
                                    taskController.reviewerCheckBox[index] =
                                        value!;
                                    if (taskController.reviewerUserId.contains(
                                      responsiblePersonList[index].id
                                          .toString(),
                                    )) {
                                      taskController.reviewerUserId.remove(
                                        responsiblePersonList[index].id
                                            .toString(),
                                      );
                                    } else {
                                      taskController.reviewerUserId.add(
                                        responsiblePersonList[index].id
                                            .toString(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 12.h);
                },
              ),
            ),
            SizedBox(height: 15.h),
            CustomButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                //   if (registerController.isLoginLoading.value != true) {
                //     registerController.userLogin(
                //         emailTextEditingController.text,
                //         passwordTextEditingController.text,
                //         deviceTokenToSendPushNotification);
                //   }
                // }
                Get.back();
              },
              text: Text(done, style: changeTextColor(rubikBlack, whiteColor)),
              color: primaryColor,
              height: 45.h,
              width: double.infinity,
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget assignedTask(
    BuildContext context,
    RxList<ResponsiblePersonData> responsiblePersonList,
    String initials,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 600.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  assignedTaskText2,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                itemCount: responsiblePersonList.length,
                reverse: false,
                itemBuilder: (context, index) {
                  String initialsName = '';
                  if (index < responsiblePersonList.length) {
                    List<String> nameList = responsiblePersonList[index].name
                        .toString()
                        .split(' ');
                    initialsName = nameList.map((word) => word[0]).join();
                  }
                  return index == 0
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: thirdPrimryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                self,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "${StorageHelper.getName()}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Obx(
                              () => SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Checkbox(
                                  value:
                                      taskController
                                          .responsiblePersonSelectedCheckBox[index],
                                  onChanged: (value) {
                                    taskController
                                            .responsiblePersonSelectedCheckBox[index] =
                                        value!;
                                    if (taskController.assignedUserId.contains(
                                      StorageHelper.getId().toString(),
                                    )) {
                                      taskController.assignedUserId.remove(
                                        StorageHelper.getId().toString(),
                                      );
                                    } else {
                                      taskController.assignedUserId.add(
                                        StorageHelper.getId().toString(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: thirdPrimryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initialsName,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${responsiblePersonList[index].name}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Obx(
                              () => SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Checkbox(
                                  value:
                                      taskController
                                          .responsiblePersonSelectedCheckBox[index],
                                  onChanged: (value) {
                                    taskController
                                            .responsiblePersonSelectedCheckBox[index] =
                                        value!;
                                    if (taskController.assignedUserId.contains(
                                      responsiblePersonList[index].id
                                          .toString(),
                                    )) {
                                      taskController.assignedUserId.remove(
                                        responsiblePersonList[index].id
                                            .toString(),
                                      );
                                    } else {
                                      taskController.assignedUserId.add(
                                        responsiblePersonList[index].id
                                            .toString(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10.h);
                },
              ),
            ),
            SizedBox(height: 15.h),
            CustomButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                //   if (registerController.isLoginLoading.value != true) {
                //     registerController.userLogin(
                //         emailTextEditingController.text,
                //         passwordTextEditingController.text,
                //         deviceTokenToSendPushNotification);
                //   }
                // }
                Get.back();
              },
              text: Text(done, style: changeTextColor(rubikBlack, whiteColor)),
              color: primaryColor,
              height: 45.h,
              width: double.infinity,
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
