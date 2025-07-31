import 'package:get/get.dart';
import 'package:task_management/controller/activity_controller.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/calender_controller.dart';
import 'package:task_management/controller/companyControlelr.dart';
import 'package:task_management/controller/contact_controller.dart';
import 'package:task_management/controller/document_controller.dart';
import 'package:task_management/controller/industry_controller.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/controller/source_controller.dart';
import 'package:task_management/controller/task_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomBarController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => ActivityController(), fenix: true);
    Get.lazyPut(() => BottomBarController(), fenix: true);
    Get.lazyPut(() => CalenderController(), fenix: true);
    Get.lazyPut(() => CompanyController(), fenix: true);
    Get.lazyPut(() => ContactController(), fenix: true);
    Get.lazyPut(() => DocumentController(), fenix: true);
    Get.lazyPut(() => ProjectController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => SourceController(), fenix: true);
    Get.lazyPut(() => IndustryController(), fenix: true);
    Get.lazyPut(() => LeadController(), fenix: true);
  }
}
