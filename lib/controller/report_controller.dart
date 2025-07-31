import 'package:get/get.dart';
import 'package:task_management/model/report_model.dart';
import 'package:task_management/service/report_service.dart';

class ReportController extends GetxController {
  var isReportingLoading = false.obs;
  RxList<String> reportDays = <String>[
    "weekly",
    "monthly",
  ].obs;
  RxString? selectedReport = "weekly".obs;
  var reportModel = [].obs;
  Rx<ReportModel?> reportModelData = Rx<ReportModel?>(null);
  Future<void> reportApi(String fromDate, String toDate) async {
    isReportingLoading.value = true;
    final result = await ReportService().reportApi(fromDate, toDate);
    if (result != null) {
      reportModelData.value = result;
    } else {}
    isReportingLoading.value = false;
  }
}
