import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/project_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/status_model.dart';
import 'package:task_management/model/team_leader_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';

class EditProject extends StatefulWidget {
  final CreatedByMe? allProjectDataList;
  const EditProject(this.allProjectDataList, {super.key});

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  final ProfileController profileController = Get.put(ProfileController());
  final TextEditingController nameTextEditingControlelr =
      TextEditingController();
  final TextEditingController descriptionTextEditingControlelr =
      TextEditingController();
  final TextEditingController priceTextEditingControlelr =
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
  @override
  void initState() {
    projectController.projectListApi();
    projectController.projectCategoryListApi();
    projectController.clientListApi();
    projectController.projectTimingApi();
    taskController.responsiblePersonListApi('', "");
    priorityController.priorityApi();
    statusController.statusApi();
    projectController.teamLeaderApi();
    nameTextEditingControlelr.text =
        widget.allProjectDataList?.name ?? ''.toString();
    descriptionTextEditingControlelr.text =
        widget.allProjectDataList?.description ?? ''.toString();
    // priceTextEditingControlelr.text =
    //     widget.allProjectDataList?. ?? ''.toString();
    // amountTextEditingControlelr.text =
    //     widget.allProjectDataList?.amount ?? "".toString();
    // totalTextEditingControlelr.text =
    //     widget.allProjectDataList?.total ?? "".toString();
    startDateTextEditingControlelr.text =
        widget.allProjectDataList?.startDate ?? "".toString();
    dueDateTextEditingControlelr.text =
        widget.allProjectDataList?.dueDate ?? "".toString();
    dueDateTextEditingControlelr.text =
        widget.allProjectDataList?.dueDate ?? "".toString();
    projectController.projectDetailsApi(widget.allProjectDataList?.id ?? 0);
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          updateProject,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Obx(
        () => projectController.isProjectCalling.value == true &&
                projectController.isProjectCategoryCalling.value == true &&
                projectController.isTeamleadCalling.value == true &&
                projectController.isClientCalling.value == true &&
                projectController.isProjectTimingCalling.value == true &&
                taskController.isResponsiblePersonLoading.value == true &&
                priorityController.isPriorityLoading.value == true &&
                statusController.isStatusLoading.value == true
            ? SizedBox(
                height: 700.h,
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
                          CustomDropdown<TeamLeaderData>(
                            items: projectController.teamLeaderDataList,
                            itemLabel: (item) => item.name ?? '',
                            onChanged: (value) {
                              projectController.selectedTeamLeader = value;
                            },
                            hintText: selectLeader,
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonHideUnderline(
                            child: Obx(
                              () => DropdownButton2<ResponsiblePersonData>(
                                isExpanded: true,
                                hint: Text(
                                  selectPerson,
                                  style: changeTextColor(
                                      rubikRegular, darkGreyColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: taskController.responsiblePersonList
                                    .map(
                                      (ResponsiblePersonData item) =>
                                          DropdownMenuItem<
                                              ResponsiblePersonData>(
                                        value: item,
                                        child: Text(
                                          item.name ?? '',
                                          style: changeTextColor(
                                              rubikRegular, Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: taskController
                                    .selectedResponsiblePersonData.value,
                                onChanged: (ResponsiblePersonData? value) {
                                  taskController.selectedResponsiblePersonData
                                      .value = value;
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
                                    border:
                                        Border.all(color: lightSecondaryColor),
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
                                          color: lightSecondaryColor)),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
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
                                    projectController.editProjectApi(
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
                                      selectPerson: taskController
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
