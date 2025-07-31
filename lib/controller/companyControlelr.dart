import 'package:get/get.dart';

class CompanyController extends GetxController {
  final RxList<String> owner = [
    'Jerald',
    'Guillory',
    'Jami',
    'Theresa',
  ].obs;
  String? selectedOwner;
  final RxList<String> deals = [
    'Collins',
    'Konopelski',
    'Adams',
    'Schumm',
    'Wisozk',
  ].obs;
  String? selectedDeals;
  final RxList<String> source = [
    'Phone Calls',
    'Social Media',
    'Referral Sites',
    'Web Analytics',
    'Previous Purchases',
  ].obs;
  String? selectedSource;
  final RxList<String> industry = [
    'Retail Industry',
    'Banking',
    'Hotels',
    'Financial Services',
    'Insurance',
  ].obs;
  String? selectedIndustry;
  final RxList<String> language = [
    'English',
    'Arabic',
    'Chinese',
    'Hindi',
    'Wisozk',
  ].obs;
  String? selectedLanguage;
  final RxList<String> country = [
    'India',
    'USA',
    'France',
    'UK',
    'UAE',
  ].obs;
  String? selectedCountry;
  final RxList<String> contact = [
    'Collins',
    'Konopelski',
    'Adams',
    'Schumm',
    'Wisozk',
  ].obs;
  String? selectedContact;

  RxString isPublic = "".obs;
  RxString isActive = "".obs;
}
