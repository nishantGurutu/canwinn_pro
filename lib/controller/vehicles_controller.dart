import 'package:get/get.dart';
import 'package:task_management/service/vehical_service.dart';

class VehiclesController extends GetxController {
  var allVehiclesTypeSelected = 0.obs;
  var isVehicleLoading = false.obs;

  var vehiclesTypeList = [].obs;

  var isApiCalling = false.obs;
  Future<void> apiCall() async {
    isApiCalling.value = true;
    await listVehicleTypeApi();
    await listVehicleApi(0);

    isApiCalling.value = false;
  }

  Future<void> listVehicleTypeApi() async {
    isVehicleLoading.value = true;
    final result = await VehiclesService().listVehicleTypeApi();
    if (result != null) {
      vehiclesTypeList.assignAll(result["data"]);
      isVehicleLoading.value = false;
    }
    isVehicleLoading.value = false;
  }

  var isVehicleListLoading = false.obs;
  var vehicleList = [].obs;
  Future<void> listVehicleApi(int id) async {
    isVehicleListLoading.value = true;
    final result = await VehiclesService().listVehicleApi(id);
    if (result != null) {
      vehicleList.assignAll(result["data"]);
      isVehicleListLoading.value = false;
    }
    isVehicleListLoading.value = false;
  }

  var isVehicleDetailsLoading = false.obs;
  var vehicleDetails = {}.obs;
  Future<void> vehicleDetailsApi(int? id) async {
    isVehicleDetailsLoading.value = true;
    final result = await VehiclesService().listVehicleDetailsApi(id ?? 0);
    if (result != null) {
      vehicleDetails.assignAll(result['data']);
      isVehicleDetailsLoading.value = false;
    }
    isVehicleDetailsLoading.value = false;
  }

  var isLoanDueDateLoading = false.obs;
  var loanDueDateList = [].obs;
  Future<void> isLoanDueDateLoadingApi() async {
    isLoanDueDateLoading.value = true;
    final result = await VehiclesService().loanDuedateVehiclesApi();
    if (result != null) {
      loanDueDateList.assignAll(result['data']);
      isLoanDueDateLoading.value = false;
    }
    isLoanDueDateLoading.value = false;
  }

  var isexpiringDocumentsLoading = false.obs;
  var expiringDocumentsList = [].obs;
  Future<void> expiringDocumentsApi() async {
    isexpiringDocumentsLoading.value = true;
    final result = await VehiclesService().expiringDocumentsApi();
    if (result != null) {
      expiringDocumentsList.assignAll(result['data']);
      isexpiringDocumentsLoading.value = false;
    }
    isexpiringDocumentsLoading.value = false;
  }
}
