import 'package:get/get.dart';
import 'package:task_management/model/source_model.dart';
import 'package:task_management/service/source_service.dart';

class SourceController extends GetxController {
  var selectedStatus = "".obs;
  var selectedStatus2 = "".obs;
  var sourceModel = SourceModel().obs;
  RxList<SourceData> sourceDataList = <SourceData>[].obs;
  var isSourceLoading = false.obs;
  Future<void> sourceApi() async {
    isSourceLoading.value = true;
    final result = await SourceService().sourceServiceApi();
    if (result != null) {
      sourceModel.value = result;
      sourceDataList.clear();
      sourceDataList.assignAll(sourceModel.value.data!);
      print("source data list length ${sourceDataList.length}");
    } else {}
    isSourceLoading.value = false;
  }

  var isSourceAdding = false.obs;
  Future<void> addSource(String sourceName, String status) async {
    isSourceAdding.value = true;
    final result = await SourceService().addSourceApi(sourceName, status);
    if (result) {
      print('Source added successfully');
      await sourceApi();
    } else {
      print('Failed to add source');
    }
    isSourceAdding.value = false;
  }

  var isSourceEditing = false.obs;
  Future<void> editSource(String sourceName, int? sourceId) async {
    isSourceEditing.value = true;
    final result = await SourceService().editSourceApi(sourceName, sourceId);
    if (result) {
      print('Source added successfully');
      await sourceApi();
    } else {
      print('Failed to add source');
    }
    isSourceEditing.value = false;
  }

  var isSourceDeleting = false.obs;
  Future<void> deleteSource(int? id) async {
    isSourceDeleting.value = true;
    final result = await SourceService().deleteSourceApi(id);
    if (result) {
      print('Source deleted successfully');
      await sourceApi();
    } else {
      print('Failed to delete source');
    }
    isSourceDeleting.value = false;
  }
}
