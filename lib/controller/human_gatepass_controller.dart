import 'dart:io';
import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/service/human_gatepass_service.dart';

class EmployeeFormController extends GetxController {
  RxInt currentStep = 0.obs;
  RxBool isFirstStepComplete = false.obs;
  Rx<File> pickedFile = File('').obs;
  RxList<String> transportModeList =
      <String>['HR', 'IT', 'Sales', 'Finance'].obs;
  RxString selectedTransportMode = ''.obs;

  Future<void> nextStep(
      {required String empName,
      required String empId,
      required String contact,
      required String purposeOfVisiting,
      required String description,
      required String destination,
      required String outTime,
      required String returnTime,
      required int deptId,
      required String transportMode}) async {
    if (currentStep.value == 0) {
      isFirstStepComplete.value = true;
    }

    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      if (isGatePassCreating.value == false) {
        await createHumanGatePass(
          empName: empName,
          empId: empId,
          contact: contact,
          purposeOfVisiting: purposeOfVisiting,
          description: description,
          destination: destination,
          outTime: outTime,
          returnTime: returnTime,
          deptId: deptId,
          transportMode: transportMode,
        );
      }
    }
  }

  void backStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  var isGatePassCreating = false.obs;
  Future<void> createHumanGatePass(
      {required String empName,
      required String empId,
      required String contact,
      required String purposeOfVisiting,
      required String description,
      required String destination,
      required String returnTime,
      required String outTime,
      required int deptId,
      required String transportMode}) async {
    isGatePassCreating.value = true;
    final result = await HumanGatepassService().createHumanGatePass(
      pickedFile: pickedFile,
      empName: empName,
      empId: empId,
      contact: contact,
      purposeOfVisiting: purposeOfVisiting,
      description: description,
      destination: destination,
      returnTime: returnTime,
      outTime: outTime,
      deptId: deptId,
      transportMode: transportMode,
    );
    await humanGatePassList();
    Get.back();
    isGatePassCreating.value = false;
      isGatePassCreating.value = false;
  }

  var isStatusUpdating = false.obs;
  Future<void> updateHumanGatePassStatus(
      {required id,
      required String remark,
      required int status,
      required String from}) async {
    isStatusUpdating.value = true;
    final result = await HumanGatepassService()
        .updateHumanGatePassStatus(id: id, remark: remark, status: status);
    await humanGatePassList();
    print('sjdu8 4iu84y87d dtf6e5 ${StorageHelper.getDepartmentId()}');
    if (StorageHelper.getDepartmentId() != 12) {
      Get.back();
    }
    isStatusUpdating.value = false;
      isStatusUpdating.value = false;
  }

  var isGatePassloading = false.obs;
  var humanGatePassListPendingData = [].obs;
  var humanGatePassListApprovedData = [].obs;
  var humanGatePassListRejectData = [].obs;
  Future<void> humanGatePassList() async {
    isGatePassloading.value = true;
    final result = await HumanGatepassService().humanGatePassList();
    if (result != null) {
      final data = result['data'];
      humanGatePassListPendingData.assignAll(data['pending']);
      humanGatePassListApprovedData.assignAll(data['approved']);
      humanGatePassListRejectData.assignAll(data['rejected']);
    }
    isGatePassloading.value = false;
  }

  var isdetailsLoading = false.obs;
  var humanGatepassDetailsData = {}.obs;
  Future<void> humanGatePassDetails({required String id}) async {
    isdetailsLoading.value = true;
    final result = await HumanGatepassService().humanGatePassdetails(id: id);
    if (result != null && result['data'] != null) {
      humanGatepassDetailsData.value = result['data'];
      isdetailsLoading.value = true;
    }
    isdetailsLoading.value = false;
  }
}
