import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/home_lead_model.dart';
import 'package:task_management/model/home_secreen_data_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/user_report_model.dart';
import 'package:task_management/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:task_management/service/lead_service.dart';

class HomeController extends GetxController {
  var isGeneralSelected = true.obs;
  var isTabIndexSelected = 0.obs;
  RxInt totalTask = 0.obs;
  var isTaskCommentSelected = false.obs;
  RxList<String> timeList = <String>["Minutes", "Hours", "Daily"].obs;
  RxList<String> alarmTypeList = <String>["Repeated", "Not Repeated"].obs;
  RxString? selectedAlarmTypeTime = "".obs;
  RxString? selectedTime = "".obs;
  RxBool isButtonVisible = true.obs;
  var isHomeDataLoading = false.obs;
  String cacheKey = 'home_data_cache';
  Rx<HomeScreenData?> homeDataModel = Rx<HomeScreenData?>(null);
  Future<void> homeDataApi(id) async {
    Future.microtask(() {
      isHomeDataLoading.value = true;
    });
    try {
      final result = await HomeService().homeDataApi(id);
      if (result != null) {
        homeDataModel.value = result.data;
        totalTask.value =
            (homeDataModel.value?.totalTaskAssigned ?? 0) +
            (homeDataModel.value?.taskCreatedByMe ?? 0);
        refresh();
        print('API response: $result');
      }
      print('API response: $result');
    } catch (e) {
      print('Error fetching or caching data: $e');
    } finally {
      Future.microtask(() {
        isHomeDataLoading.value = false;
      });
    }
  }

  var isUserDataLoading = false.obs;
  Rx<HomeScreenData?> userHomeDataModel = Rx<HomeScreenData?>(null);
  Future<void> userhomeDataApi(id) async {
    final cacheManager = DefaultCacheManager();

    Future.microtask(() {
      isUserDataLoading.value = true;
    });

    try {
      final result = await HomeService().userhomeDataApi(id);
      if (result != null) {
        userHomeDataModel.value = result.data!;
        refresh();
      }
      print('API response: $result');
    } catch (e) {
      print('Error fetching or caching data: $e');
    } finally {
      Future.microtask(() {
        isUserDataLoading.value = false;
      });
    }
  }

  Rx<HomeLeadData?> homeLeadData = Rx<HomeLeadData?>(null);
  var isLeadDetailsLoading = false.obs;
  Future<void> leadHomeApi() async {
    isLeadDetailsLoading.value = true;
    final result = await LeadService().leadHomeApi();
    if (result != null) {
      homeLeadData.value = result.data;
      isLeadDetailsLoading.value = false;
      isLeadDetailsLoading.refresh();
      homeLeadData.refresh();

      print("ksiudyiue eidueoi");
    } else {}
    isLeadDetailsLoading.value = false;
  }

  Rx<HomeLeadData?> userhomeLeadData = Rx<HomeLeadData?>(null);
  var isuserLeadDetailsLoading = false.obs;
  Future<void> userleadHomeApi(homeAdminUserId) async {
    isLeadDetailsLoading.value = true;
    final result = await LeadService().userleadHomeApi(homeAdminUserId);
    if (result != null) {
      userhomeLeadData.value = result.data;
      isLeadDetailsLoading.value = false;
      userhomeLeadData.refresh();
      print("ksiudyiue eidueoi");
    } else {}
    isLeadDetailsLoading.value = false;
  }

  RxList<UserReportData?> userReportDataList = <UserReportData>[].obs;
  var isUserReportLoading = false.obs;
  Future<void> userReportApi(homeAdminUserId) async {
    isUserReportLoading.value = true;
    final result = await LeadService().userReportApi(homeAdminUserId);
    if (result != null) {
      userReportDataList.assignAll(result.data!);
      isUserReportLoading.value = false;
      refresh();
    } else {}
    isUserReportLoading.value = false;
  }

  RxString onTimemsg = ''.obs;
  RxString onTimemsgUrl = ''.obs;
  var isOneTimeMsgLoading = false.obs;
  Future<void> onetimeMsglist() async {
    isOneTimeMsgLoading.value = true;
    final result = await HomeService().onetimeMsglist();
    if (result != null) {
      if (result['data'] != null) {
        onTimemsg.value = result['data']['message'];
        onTimemsgUrl.value = result['data']['link'];
      }
      onTimemsgUrl.refresh();

      if (StorageHelper.getOnetimeMsg().toString().toLowerCase() !=
          onTimemsg.value.toString().toLowerCase()) {
        StorageHelper.setOnetimeMsg(onTimemsg.value);
        StorageHelper.setIsSnackbarShown(true);
      }
    } else {}
    isOneTimeMsgLoading.value = false;
  }

  var isAnniversaryLoading = false.obs;
  var anniversaryListData = [].obs;
  Future<void> anniversarylist(BuildContext context) async {
    isAnniversaryLoading.value = true;
    final result = await HomeService().anniversarylist();
    if (result != null) {
      anniversaryListData.clear();
      anniversaryListData.assignAll(result['data']);
      if (anniversaryListData.isNotEmpty) {
        if (StorageHelper.getAnniversaryVisible() == false) {}
      }
    } else {}
    isAnniversaryLoading.value = false;
  }

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
  Future<void> taskResponsiblePersonListApi(dynamic id, String fromPage) async {
    Future.microtask(() {
      isResponsiblePersonLoading.value = true;
    });
    final result = await HomeService().responsiblePersonListApi(id);
    if (result != null) {
      selectedResponsiblePersonData.value = null;
      responsiblePersonListModel.value = result;
      isResponsiblePersonLoading.value = false;
      isResponsiblePersonLoading.refresh();
      responsiblePersonList.clear();
      if (fromPage.toString() == "add_meeting") {
        responsiblePersonList.add(
          ResponsiblePersonData(id: 0, name: "All user", status: 1),
        );
      }
      for (var person in responsiblePersonListModel.value.data!) {
        responsiblePersonList.add(person);
      }
      responsiblePersonList.refresh();
      selectedSharedListPerson.addAll(
        List<bool>.filled(responsiblePersonList.length, false),
      );
      responsiblePersonSelectedCheckBox.addAll(
        List<bool>.filled(responsiblePersonList.length, false),
      );
      selectedResponsiblePersonId.addAll(
        List<int>.filled(responsiblePersonList.length, 0),
      );
      selectedResponsiblePersonId.addAll(
        List<int>.filled(responsiblePersonList.length, 0),
      );
      selectedLongPress.addAll(
        List<bool>.filled(responsiblePersonList.length, false),
      );
      reviewerCheckBox.addAll(
        List<bool>.filled(responsiblePersonList.length, false),
      );
      responsiblePersonSelectedCheckBox2.clear();
      toAssignedPersonCheckBox.clear();
      for (var person in responsiblePersonList) {
        toAssignedPersonCheckBox[person.id] = false;
      }
      for (var person in responsiblePersonList) {
        responsiblePersonSelectedCheckBox2[person.id] = false;
      }
    }
    Future.microtask(() {
      isResponsiblePersonLoading.value = false;
    });
  }

  RxList<DepartmentListData> selectedDepartMentListData2 =
      <DepartmentListData>[].obs;
  Future<void> responsiblePersonListApi2(
    RxList<DepartmentListData> selectedDepartMentListData2,
  ) async {
    Future.microtask(() {
      isResponsiblePersonLoading.value = true;
    });
    final result = await HomeService().responsiblePersonListApi2(
      selectedDepartMentListData2,
    );
    if (result != null) {
      responsiblePersonList.assignAll(result.data!);
      isResponsiblePersonLoading.value = false;
    }
    Future.microtask(() {
      isResponsiblePersonLoading.value = false;
    });
  }
}
