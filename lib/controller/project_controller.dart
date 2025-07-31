import 'package:get/get.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/client_model.dart';
import 'package:task_management/model/project_category_model.dart';
import 'package:task_management/model/project_details_model.dart';
import 'package:task_management/model/project_list_model.dart';
import 'package:task_management/model/project_timing_model.dart';
import 'package:task_management/model/team_leader_model.dart';
import 'package:task_management/service/project_service.dart';

import '../model/responsible_person_list_model.dart';

class ProjectController extends GetxController {
  var isProjectCalling = false.obs;
  var projectListModel = ProjectListModel().obs;
  AllProjectData? selectedAllProjectData;
  final TaskController taskController = Get.find();

  RxList<AllProjectData> projectDataList = <AllProjectData>[].obs;
  Future<void> projectListApi() async {
    isProjectCalling.value = true;
    final result = await ProjectService().projectListApi();
    if (result != null) {
      projectListModel.value = result;
      projectDataList.clear();
      projectDataList.assignAll(projectListModel.value.data!);
    } else {}
    isProjectCalling.value = false;
  }

  Rx<ProjectDetailsModel?> projectDetails = Rx<ProjectDetailsModel?>(null);
  var isProjectDetailsLoading = false.obs;
  Future<void> projectDetailsApi(int id) async {
    isProjectDetailsLoading.value = true;
    final result = await ProjectService().projectDetailsApi(id);
    if (result != null) {
      projectDetails.value = result;
    } else {}
    isProjectDetailsLoading.value = false;
  }

  var isProjectCategoryCalling = false.obs;
  var projectCategoryListModel = ProjectCategoryListModel().obs;
  ProjectCategoryData? selectedProjectCategory;
  RxList<ProjectCategoryData> projectCategoryDataList =
      <ProjectCategoryData>[].obs;
  Future<void> projectCategoryListApi() async {
    isProjectCategoryCalling.value = true;
    final result = await ProjectService().projectCategoryListApi();
    if (result != null) {
      projectCategoryListModel.value = result;
      projectCategoryDataList.clear();
      projectCategoryDataList.assignAll(projectCategoryListModel.value.data!);
    } else {}
    isProjectCategoryCalling.value = false;
  }

  var isAllProjectCalling = false.obs;
  var allProjectListModel = AllProjectListModel().obs;
  Rx<CreatedByMe?> selectedAllProjectListData = Rx<CreatedByMe?>(null);
  RxList<CreatedByMe> allProjectDataList = <CreatedByMe>[].obs;
  RxList<CreatedByMe> createdProjectList = <CreatedByMe>[].obs;
  RxList<CreatedByMe> assignedProjectList = <CreatedByMe>[].obs;
  Future<void> allProjectListApi() async {
    isAllProjectCalling.value = true;
    final result = await ProjectService().allProjectListApi();
    if (result != null) {
      allProjectListModel.value = result;
      createdProjectList.assignAll(allProjectListModel.value.createdByMe!);
      assignedProjectList.assignAll(allProjectListModel.value.assignedToMe!);
      for (int i = 0;
          i < (allProjectListModel.value.createdByMe?.length ?? 0);
          i++) {
        allProjectDataList.add(allProjectListModel.value.createdByMe![i]);
      }
      for (int i = 0;
          i < (allProjectListModel.value.assignedToMe?.length ?? 0);
          i++) {
        allProjectDataList.add(allProjectListModel.value.assignedToMe![i]);
      }
    } else {}
    isAllProjectCalling.value = false;
  }

  var isClientCalling = false.obs;
  var clientListModel = ClientModel().obs;
  ClientData? selectedClient;
  RxList<ClientData> clientDataList = <ClientData>[].obs;
  Future<void> clientListApi() async {
    isClientCalling.value = true;
    final result = await ProjectService().clientListApi();
    if (result != null) {
      clientListModel.value = result;
      clientDataList.clear();
      clientDataList.assignAll(clientListModel.value.data!);
    } else {}
    isClientCalling.value = false;
  }

  var isProjectTimingCalling = false.obs;
  var projectTimingModel = ProjectTimingModel().obs;
  ProjectTimingData? selectedProjectTiming;
  RxList<ProjectTimingData> projectTimingList = <ProjectTimingData>[].obs;
  Future<void> projectTimingApi() async {
    isProjectTimingCalling.value = true;
    final result = await ProjectService().projecttimingListApi();
    if (result != null) {
      projectTimingModel.value = result;
      projectTimingList.clear();
      projectTimingList.assignAll(projectTimingModel.value.data!);
    } else {}
    isProjectTimingCalling.value = false;
  }

  var isTeamleadCalling = false.obs;
  var teamLeaderData = TeamLeaderModel().obs;
  TeamLeaderData? selectedTeamLeader;
  RxList<TeamLeaderData> teamLeaderDataList = <TeamLeaderData>[].obs;
  Future<void> teamLeaderApi() async {
    isTeamleadCalling.value = true;
    final result = await ProjectService().teamLeaderListApi();
    if (result != null) {
      teamLeaderData.value = result;
      teamLeaderDataList.clear();
      teamLeaderDataList.assignAll(teamLeaderData.value.data!);
    } else {}
    isTeamleadCalling.value = false;
  }

  var isProjectAdding = false.obs;
  Future<void> addProjectApi({
    required String projectName,
    int? projectType,
    int? client,
    int? category,
    int? projectTiming,
    required String price,
    required String amount,
    required String total,
    int? selectPerson,
    int? selectedLeader,
    required String startDate,
    required String dueDate,
    int? selectedPriority,
    int? selectedStatus,
    required String description,
    required RxList<String> departmentId,
    required String dueTime,
  }) async {
    isProjectAdding.value = true;
    final result = await ProjectService().addProjectApi(
        projectName,
        projectType,
        client,
        category,
        projectTiming,
        price,
        amount,
        total,
        selectPerson,
        selectedLeader,
        startDate,
        dueDate,
        selectedPriority,
        selectedStatus,
        description,
        departmentId,
        dueTime);
    Get.back();
      await allProjectListApi();
    isProjectAdding.value = false;
  }

  var isProjectEditing = false.obs;
  Future<void> editProjectApi(
      {required String projectName,
      int? projectType,
      int? client,
      int? category,
      int? projectTiming,
      required String price,
      required String amount,
      required String total,
      int? selectPerson,
      int? selectedLeader,
      required String startDate,
      required String dueDate,
      int? selectedPriority,
      int? selectedStatus,
      required String description}) async {
    isProjectEditing.value = true;
    final result = await ProjectService().editProjectApi(
        projectName,
        projectType,
        client,
        category,
        projectTiming,
        price,
        amount,
        total,
        selectPerson,
        selectedLeader,
        startDate,
        dueDate,
        selectedPriority,
        selectedStatus,
        description);
    Get.back();
    await allProjectListApi();
    isProjectEditing.value = false;
  }

  var isProjectDeleting = false.obs;
  Future<void> deleteProject(int? id) async {
    isProjectDeleting.value = true;
    final result = await ProjectService().deleteProject(id);
    if (result) {
      await allProjectListApi();
    } else {}
    isProjectDeleting.value = false;
  }



  // Project Responsible person list data

  RxMap<int, bool> responsiblePersonSelectedCheckBox2 = <int, bool>{}.obs;
  RxMap<int, bool> toAssignedPersonCheckBox = <int, bool>{}.obs;
  RxMap<int, bool> reviewerCheckBox2 = <int, bool>{}.obs;
  var isResponsiblePersonLoading = false.obs;
  RxBool selectAll = false.obs;
  RxList<ResponsiblePersonData> responsiblePersonList =
      <ResponsiblePersonData>[].obs;
  RxList<bool> selectedLongPress = <bool>[].obs;
  RxList<int> selectedMemberId = <int>[].obs;
  RxList<bool> responsiblePersonSelectedCheckBox = <bool>[].obs;
  RxList<bool> reviewerCheckBox = <bool>[].obs;
  Rx<ResponsiblePersonData?> selectedResponsiblePersonData =
  Rx<ResponsiblePersonData?>(null);
  RxList<int> selectedResponsiblePersonId = <int>[].obs;
  RxList<bool> selectedSharedListPerson = <bool>[].obs;
  var fromPage = ''.obs;
  RxList<bool> isLongPressed = <bool>[].obs;
  var makeSelectedPersonValue = ''.obs;
  var responsiblePersonListModel = ResponsiblePersonListModel().obs;
  Future<void> responsiblePersonListApi(dynamic id, String fromPage) async {
    Future.microtask(() {
      isResponsiblePersonLoading.value = true;
    });
    final result = await ProjectService().responsiblePersonListApi(id);
    if (result != null) {
      selectedResponsiblePersonData.value = null;
      responsiblePersonListModel.value = result;
      isResponsiblePersonLoading.value = false;
      responsiblePersonList.clear();
      if (fromPage.toString() == "add_meeting") {
        responsiblePersonList.add(
          ResponsiblePersonData(
            id: 0,
            name: "All user",
            status: 1,
          ),
        );
      }
      for (var person in responsiblePersonListModel.value.data!) {
        responsiblePersonList.add(person);
      }
      selectedSharedListPerson
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      responsiblePersonSelectedCheckBox
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      selectedResponsiblePersonId
          .addAll(List<int>.filled(responsiblePersonList.length, 0));
      selectedResponsiblePersonId
          .addAll(List<int>.filled(responsiblePersonList.length, 0));
      selectedLongPress
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      reviewerCheckBox
          .addAll(List<bool>.filled(responsiblePersonList.length, false));
      responsiblePersonSelectedCheckBox2.clear();
      toAssignedPersonCheckBox.clear();
      for (var person in responsiblePersonList) {
        toAssignedPersonCheckBox[person.id] = false;
      }
      for (var person in responsiblePersonList) {
        responsiblePersonSelectedCheckBox2[person.id] = false;
      }
      // await userLogActivity(responsiblePersonList.first.id);
    }
    Future.microtask(() {
      isResponsiblePersonLoading.value = false;
    });
  }
}
