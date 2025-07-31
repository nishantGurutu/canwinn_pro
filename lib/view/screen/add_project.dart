import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/status_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/project_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/status_model.dart';
import 'package:task_management/model/team_leader_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final TextEditingController nameTextEditingControlelr =
      TextEditingController();
  final TextEditingController descriptionTextEditingControlelr =
      TextEditingController();
  final TextEditingController priceTextEditingControlelr =
      TextEditingController();
  final TextEditingController dateTextEditingControlelr =
      TextEditingController();
  final TextEditingController clientTextEditingControlelr =
      TextEditingController();
  final TextEditingController collaboratorTextEditingControlelr =
      TextEditingController();
  final TextEditingController assignedTeamGroupTextEditingControlelr =
      TextEditingController();
  final TextEditingController projectManagerTextEditingControlelr =
      TextEditingController();
  final TextEditingController amountTextEditingControlelr =
      TextEditingController();
  final TextEditingController totalTextEditingControlelr =
      TextEditingController();
  final TextEditingController startDateTextEditingControlelr =
      TextEditingController();
  final TextEditingController dueDateTextEditingControlelr =
      TextEditingController();
  final TextEditingController dueTimeTextEditingControlelr =
      TextEditingController();
  final ProjectController projectController = Get.put(ProjectController());
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final StatusController statusController = Get.put(StatusController());
  final ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    projectController.projectListApi();
    projectController.projectCategoryListApi();
    projectController.clientListApi();
    projectController.projectTimingApi();
    projectController.responsiblePersonListApi(
        StorageHelper.getDepartmentId(), "");
    priorityController.priorityApi();
    statusController.statusApi();
    projectController.teamLeaderApi();
    profileController.departmentList('');
    super.initState();
  }

  final TextEditingController menuController = TextEditingController();
  final TextEditingController menuController2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
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
          createProject,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => projectController.isProjectCalling.value == true &&
                projectController.isProjectCategoryCalling.value == true &&
                projectController.isTeamleadCalling.value == true &&
                projectController.isClientCalling.value == true &&
                projectController.isProjectTimingCalling.value == true &&
                taskController.isResponsiblePersonLoading.value == true &&
                priorityController.isPriorityLoading.value == true &&
                statusController.isStatusLoading.value == true &&
                profileController.isdepartmentListLoading.value == true
            ? Container(
                height: 700.h,
                color: whiteColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomTextField(
                            hintText: projectName,
                            keyboardType: TextInputType.emailAddress,
                            controller: nameTextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(height: 10.h),
                          CustomDropdown<AllProjectData>(
                            items: projectController.projectDataList,
                            itemLabel: (item) => item.projectTypeName ?? '',
                            onChanged: (value) {
                              projectController.selectedAllProjectData = value;
                            },
                            hintText: selectProjectType,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Select Department',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          departmentGrid(profileController.departmentDataList),
                          SizedBox(height: 10.h),
                          Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: lightBorderColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14.r),
                              ),
                            ),
                            child: Obx(
                              () => DropdownMenu<TeamLeaderData>(
                                controller: menuController,
                                width: double.infinity,
                                trailingIcon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                selectedTrailingIcon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                menuHeight: 350.h,
                                hintText: "Search Team Lead",
                                requestFocusOnTap: true,
                                enableSearch: true,
                                enableFilter: true,
                                inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.r),
                                    ),
                                  ),
                                ),
                                menuStyle: MenuStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          whiteColor),
                                ),
                                initialSelection:
                                    projectController.selectedTeamLeader,
                                onSelected: (TeamLeaderData? menu) {
                                  if (menu != null) {
                                    projectController.selectedTeamLeader = menu;
                                  }
                                },
                                dropdownMenuEntries: projectController
                                    .teamLeaderDataList
                                    .map<DropdownMenuEntry<TeamLeaderData>>(
                                        (TeamLeaderData menu) {
                                  return DropdownMenuEntry<TeamLeaderData>(
                                    value: menu,
                                    label: menu.name ?? '',
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: lightBorderColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14.r),
                              ),
                            ),
                            child: Obx(
                              () => DropdownMenu<ResponsiblePersonData>(
                                controller: menuController2,
                                width: double.infinity,
                                trailingIcon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                selectedTrailingIcon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                menuHeight: 350.h,
                                hintText: "Search Person",
                                requestFocusOnTap: true,
                                enableSearch: true,
                                enableFilter: true,
                                inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.r),
                                    ),
                                  ),
                                ),
                                menuStyle: MenuStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          whiteColor),
                                ),
                                initialSelection: projectController
                                    .selectedResponsiblePersonData.value,
                                onSelected: (ResponsiblePersonData? menu) {
                                  if (menu != null) {
                                    projectController
                                        .selectedResponsiblePersonData
                                        .value = menu;
                                  }
                                },
                                dropdownMenuEntries:
                                    projectController.responsiblePersonList.map<
                                            DropdownMenuEntry<
                                                ResponsiblePersonData>>(
                                        (ResponsiblePersonData menu) {
                                  return DropdownMenuEntry<
                                      ResponsiblePersonData>(
                                    value: menu,
                                    label: menu.name ?? '',
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomCalender(
                            hintText: startDate,
                            controller: startDateTextEditingControlelr,
                          ),
                          SizedBox(height: 10.h),
                          CustomCalender(
                            hintText: dueDate,
                            controller: dueDateTextEditingControlelr,
                          ),
                          SizedBox(height: 10.h),
                          CustomTimer(
                            hintText: "Due Time",
                            controller: dueTimeTextEditingControlelr,
                          ),
                          SizedBox(height: 10.h),
                          CustomDropdown<PriorityData>(
                            items: priorityController.priorityList,
                            itemLabel: (item) => item.priorityName ?? "",
                            onChanged: (value) {
                              priorityController.selectedPriorityData.value =
                                  value;
                            },
                            hintText: selectPriority,
                          ),
                          SizedBox(height: 10.h),
                          CustomDropdown<StatusData>(
                            items: statusController.statusList,
                            itemLabel: (item) => item.statusName ?? "",
                            onChanged: (value) {
                              statusController.selectedStatusData = value;
                            },
                            hintText: status,
                          ),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            hintText: description,
                            keyboardType: TextInputType.emailAddress,
                            controller: descriptionTextEditingControlelr,
                            textCapitalization: TextCapitalization.sentences,
                            maxLine: 5,
                          ),
                          SizedBox(height: 20.h),
                          Obx(
                            () => CustomButton(
                              onPressed: () {
                                if (projectController.isProjectAdding.value ==
                                    false) {
                                  if (_formKey.currentState!.validate()) {
                                    projectController.addProjectApi(
                                      projectName:
                                          nameTextEditingControlelr.text,
                                      projectType: projectController
                                          .selectedAllProjectData?.id,
                                      client:
                                          projectController.selectedClient?.id,
                                      category: projectController
                                          .selectedProjectCategory?.id,
                                      projectTiming: projectController
                                          .selectedProjectTiming?.id,
                                      price: priceTextEditingControlelr.text,
                                      amount: amountTextEditingControlelr.text,
                                      total: totalTextEditingControlelr.text,
                                      selectPerson: projectController
                                          .selectedResponsiblePersonData
                                          .value
                                          ?.id,
                                      selectedLeader: projectController
                                          .selectedTeamLeader?.id,
                                      startDate:
                                          startDateTextEditingControlelr.text,
                                      dueDate:
                                          dueDateTextEditingControlelr.text,
                                      selectedPriority: priorityController
                                          .selectedPriorityData.value?.id,
                                      selectedStatus: statusController
                                          .selectedStatusData?.id,
                                      description:
                                          descriptionTextEditingControlelr.text,
                                      departmentId: profileController
                                          .selectedDepartmentListId,
                                      dueTime:
                                          dueTimeTextEditingControlelr.text,
                                    );
                                  }
                                }
                              },
                              text: projectController.isProjectAdding.value ==
                                      true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30.h,
                                          child: CircularProgressIndicator(
                                            color: whiteColor,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          loading,
                                          style: changeTextColor(
                                              rubikBlack, whiteColor),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      add,
                                      style: changeTextColor(
                                          rubikBlack, whiteColor),
                                    ),
                              width: double.infinity,
                              color: primaryColor,
                              height: 45.h,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget departmentGrid(RxList<DepartmentListData> departmentDataList) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: List.generate(
        departmentDataList.length,
        (index2) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                if (profileController.selectedDepartmentListId[index2] !=
                    departmentDataList[index2].id.toString()) {
                  profileController.selectedDepartmentListId[index2] =
                      departmentDataList[index2].id.toString();
                } else {
                  profileController.selectedDepartmentListId[index2] = '';
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                      color:
                          profileController.selectedDepartmentListId[index2] ==
                                  departmentDataList[index2].id.toString()
                              ? whiteColor
                              : darkGreyColor),
                  color: profileController.selectedDepartmentListId[index2] ==
                          departmentDataList[index2].id.toString()
                      ? secondaryColor
                      : whiteColor,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Text(
                    '${departmentDataList[index2].name}',
                    style: changeTextColor(
                        rubikRegular,
                        profileController.selectedDepartmentListId[index2] ==
                                departmentDataList[index2].id.toString()
                            ? whiteColor
                            : darkGreyColor),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
