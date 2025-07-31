import 'package:get/get.dart';

class ContactController extends GetxController {
  final RxList<String> person = [
    'Sharon Roy',
    'Vaughan',
    'Jessica',
    'Carol Thomas',
  ].obs;
  String? selectedPerson;
  final RxList<String> category = [
    'Calls',
    'Email',
    'Meeting',
  ].obs;
  String? selectedCategory;
  final RxList<String> priority = [
    'High',
    'Low',
    'Medium',
  ].obs;
  String? selectedPeriority;
  final RxList<String> status = [
    'Active',
    'Inactive',
  ].obs;
  String? selectedStatus;
}
