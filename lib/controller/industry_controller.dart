import 'package:get/get.dart';
import 'package:task_management/model/industry_model.dart';
import 'package:task_management/service/industry_service.dart';

class IndustryController extends GetxController {
  var isIndustryLoading = false.obs;
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var industryModel = IndustryModel().obs;
  RxList<IndustryData> industryList = <IndustryData>[].obs;
  Future<void> industryApi() async {
    isIndustryLoading.value = true;
    final result = await IndustryService().industryServiceApi();
    if (result != null) {
      industryModel.value = result;
      industryList.clear();
      industryList.assignAll(industryModel.value.data!);
    } else {}
    isIndustryLoading.value = false;
  }

  var isIndustryAdding = false.obs;
  Future<void> addIndustry(String sourceName, String status) async {
    isIndustryAdding.value = true;
    final result = await IndustryService().addIndustryApi(sourceName, status);
    if (result) {
      await industryApi();
    } else {}
    isIndustryAdding.value = false;
  }

  var isIndustryEditing = false.obs;
  Future<void> editIndustry(String sourceName, int? sourceId) async {
    isIndustryEditing.value = true;
    final result =
        await IndustryService().editIndustryApi(sourceName, sourceId);
    if (result) {
      await industryApi();
    } else {}
    isIndustryEditing.value = false;
  }

  var isIndustryDeleting = false.obs;
  Future<void> deleteIndustry(int? id) async {
    isIndustryDeleting.value = true;
    final result = await IndustryService().deleteIndustryApi(id);
    if (result) {
      print('Source deleted successfully');
      await industryApi();
    } else {
      print('Failed to delete source');
    }
    isIndustryDeleting.value = false;
  }
}
