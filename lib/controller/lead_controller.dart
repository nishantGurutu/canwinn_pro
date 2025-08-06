import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/data/model/visit_type_list.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/LeadNoteModel.dart';
import 'package:task_management/model/added_document_lead_list_model.dart';
import 'package:task_management/model/document_type_list_model.dart';
import 'package:task_management/model/follow_ups_list_model.dart';
import 'package:task_management/model/followups_type_list_model.dart';
import 'package:task_management/model/get_list_modules.dart';
import 'package:task_management/model/lead_contact_list_model.dart';
import 'package:task_management/model/lead_details_model.dart';
import 'package:task_management/model/lead_discussion_list.dart';
import 'package:task_management/model/lead_list_model.dart';
import 'package:task_management/model/lead_status_lead.dart';
import 'package:task_management/model/lead_visit_list_model.dart';
import 'package:task_management/model/product_list_model.dart';
import 'package:task_management/model/quotation_item.dart';
import 'package:task_management/model/quotation_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/session_list_model.dart';
import 'package:task_management/model/source_list_model.dart';
import 'package:task_management/model/uploaded_document_list_model.dart'
    show UploadedDocumentData;
import 'package:task_management/service/lead_service.dart';
import 'package:task_management/view/screen/meeting/meeting_form.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class LeadController extends GetxController {
  var isImageLoading = false.obs;
  var isAllLeadSelected = true.obs;
  var isUploadedDocumentLeadSelected = false.obs;
  RxList<bool> isDocumentCheckBoxSelected = <bool>[].obs;
  var selectedUserType = ''.obs;
  RxList<String> addressTypeList =
      ["Site Address", "Office Address", "Other"].obs;
  RxList<String> leadTypeList =
      ["Created by me", "Assigned to me", "Added to me"].obs;
  RxString selectedLeadType = "".obs;
  RxList<String> leadfilterType = ["Male", "Female"].obs;
  RxList<String> quotationType = ["Rental", "Sales"].obs;
  RxList<String> genderList = ["Male", "Female"].obs;
  RxString selectedGender = "".obs;
  RxString selectedQuotation = "".obs;
  RxString selectedAddressType = "".obs;

  var countryList = <String>[
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Brazzaville)',
    'Congo (Kinshasa)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ].obs;
  RxString selectedCountry = ''.obs;
  var pickedImage = ''.obs;
  var pickedFile = File('').obs;
  var pickedVisitingCard = ''.obs;
  var pickedVisitingFile = File('').obs;

  var isLeadAdding = false.obs;
  Future<void> addLeads({
    required String leadName,
    required String companyName,
    required String phone,
    required String email,
    required String source,
    required String status,
    required String description,
    required File audio,
  }) async {
    isLeadAdding.value = true;
    final result = await LeadService().addLeadsApi(
      leadName: leadName,
      companyName: companyName,
      phone: phone,
      email: email,
      source: source,
      status: status,
      description: description,
      pickedFile: pickedFile.value,
      audio: audio,
    );
    if (result != null) {
      Get.back();
      await leadsList(selectedLeadStatusData.value?.id, selectedLeadType.value);
    } else {}
    isLeadAdding.value = false;
  }

  var isLeadUpdating = false.obs;
  Future<void> updateLeads(
      {required String leadName,
      required String companyName,
      required String phone,
      required String email,
      required String source,
      required String industry,
      required String status,
      required String tag,
      required String description,
      required String address,
      required id}) async {
    isLeadUpdating.value = true;
    final result = await LeadService().updateLeadsApi(
        leadName: leadName,
        companyName: companyName,
        phone: phone,
        email: email,
        source: source,
        industry: industry,
        status: status,
        tag: tag,
        description: description,
        address: address,
        pickedFile: pickedFile,
        id: id);
    if (result) {
      Get.back();
      await leadsList(selectedLeadStatusData.value?.id, selectedLeadType.value);
    } else {}
    isLeadUpdating.value = false;
  }

  var isFollowUp = false.obs;
  Future<void> assignFollowup(
      {required RxList<ResponsiblePersonData> personid,
      int? followupId}) async {
    isLeadUpdating.value = true;
    final result = await LeadService().assignFollowup(personid, followupId);
    if (result) {
      Get.back();
      await leadsList(selectedLeadStatusData.value?.id, selectedLeadType.value);
    } else {}
    isLeadUpdating.value = false;
  }

  var isLeadLoading = false.obs;
  RxList<LeadListData> leadsListData = <LeadListData>[].obs;
  RxList<LeadStatusData> selectedStatusPerLead = <LeadStatusData>[].obs;

  Future<void> leadsList(int? id, String leadTypeValue) async {
    isLeadLoading.value = true;
    try {
      final result = await LeadService().leadsListApi(id, leadTypeValue);
      final offlineLeads = await DatabaseHelper.instance.getLeads();
      final db = await DatabaseHelper.instance.database;

      if (result != null && result.data != null) {
        isLeadLoading.value = false;
        isLeadLoading.refresh();
        for (var onlineLead in result.data!) {
          if (onlineLead.phone != null &&
              onlineLead.phone!.isNotEmpty &&
              onlineLead.leadName != null &&
              onlineLead.leadName!.isNotEmpty) {
            final matchingLeads = await db.query(
              'leads',
              where: 'phone = ? AND lead_name = ?',
              whereArgs: [
                onlineLead.phone!.trim(),
                onlineLead.leadName!.trim(),
              ],
            );
            for (var matchingLead in matchingLeads) {
              final leadId = matchingLead['id'] as int;
              final deleteResult =
                  await DatabaseHelper.instance.deleteLead(leadId);
              if (deleteResult > 0) {
                CustomToast().showCustomToast(
                  'Offline lead with phone ${onlineLead.phone} removed.',
                );
                debugPrint(
                  'Offline lead with phone ${onlineLead.phone} removed.',
                );
              } else {
                CustomToast().showCustomToast(
                  'Failed to delete offline lead with phone ${onlineLead.phone} and name ${onlineLead.leadName}.',
                );
                debugPrint(
                    "Failed to delete offline lead with phone ${onlineLead.phone} and name ${onlineLead.leadName}.");
              }
            }
          }
        }
      }

      final updatedOfflineLeads = await DatabaseHelper.instance.getLeads();

      leadsListData.clear();
      leadsListData.addAll(
        updatedOfflineLeads.map((e) => LeadListData.fromJson(e)).toList(),
      );
      if (result != null && result.data != null) {
        leadsListData.addAll(result.data!.reversed.toList());
      }
      leadsListData.refresh();

      selectedStatusPerLead.clear();
      selectedStatusPerLead.addAll(
        List<LeadStatusData>.filled(leadsListData.length, LeadStatusData()),
      );

      for (int i = 0; i < leadsListData.length; i++) {
        for (int j = 0; j < leadStatusData.length; j++) {
          if (leadsListData[i].status == leadStatusData[j].id) {
            selectedStatusPerLead[i] = leadStatusData[j];
            break;
          }
        }
      }
      for (int i = 0; i < leadsListData.length; i++) {
        for (int j = 0; j < leadStatusData.length; j++) {
          if (leadsListData[i].status == leadStatusData[j].id) {
            selectedStatusPerLead[i] = leadStatusData[j];
            break;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching leads: $e");
      Get.snackbar(
        'Error',
        'Failed to fetch leads: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLeadLoading.value = false;
    }
  }

  RxList<AddedDocumentLeadData> addedDocumentLeadDataList =
      <AddedDocumentLeadData>[].obs;
  var isAddedDocumentLeadLoading = false.obs;
  Future<void> addedDocumentLeadList() async {
    isAddedDocumentLeadLoading.value = true;
    try {
      final result = await LeadService().addedDocumentLeadList();

      if (result != null && result.data != null) {
        isAddedDocumentLeadLoading.value = false;
        isAddedDocumentLeadLoading.refresh();
        addedDocumentLeadDataList.assignAll(result.data!);
      }
    } catch (e) {
      debugPrint("Error fetching leads: $e");
      Get.snackbar(
        'Error',
        'Failed to fetch leads: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddedDocumentLeadLoading.value = false;
    }
  }

  var isSourceLoading = false.obs;
  RxList<SourceListData> sourceListData = <SourceListData>[].obs;
  Rx<SourceListData?> selectedSourceListData = Rx<SourceListData?>(null);
  Future<void> sourceList({required source}) async {
    isSourceLoading.value = true;
    final result = await LeadService().sourseList();
    if (result != null) {
      sourceListData.assignAll(result.data!);

      for (var val in result.data!) {
        await DatabaseHelper.instance.insertLeadSource(val);
      }
      if (source != null) {
        for (var val in sourceListData) {
          if (val.id.toString() == source.toString())
            selectedSourceListData.value = val;
        }
      }
    } else {}
    isSourceLoading.value = false;
  }

  Future<void> offLineSourcedata() async {
    final result = await DatabaseHelper.instance.getLeadSources();
    sourceListData.assignAll(result);
    refresh();
  }

  Future<void> offLineStatusdata({String? status}) async {
    final result = await DatabaseHelper.instance.getLeadStatus();
    leadStatusData.assignAll(result);
    refresh();
    if (status != null) {
      for (var val in leadStatusData) {
        if (val.id.toString() == status.toString() ||
            val.name.toString().toLowerCase() == status.toString()) {
          selectedLeadStatusData.value = val;
          break;
        }
      }
      print('lead selected id from home ${selectedLeadStatusData.value?.id}');
      await leadsList(selectedLeadStatusData.value?.id, selectedLeadType.value);
    }
  }

  Future<void> getOflineLeadList() async {
    final offlineLeads = await DatabaseHelper.instance.getLeads();
    leadsListData.clear();
    leadsListData.addAll(
      offlineLeads.map((e) => LeadListData.fromJson(e)).toList(),
    );
    leadsListData.refresh();

    selectedStatusPerLead.addAll(
        List<LeadStatusData>.filled(leadsListData.length, LeadStatusData()));
    for (int i = 0; i < leadsListData.length; i++) {
      for (int j = 0; j < leadStatusData.length; j++) {
        if (leadsListData[i].status == leadStatusData[j].id) {
          selectedStatusPerLead[i] = leadStatusData[j];
          break;
        }
      }
    }
  }

  var isStatusListLoading = false.obs;

  RxList<LeadStatusData> leadStatusData = <LeadStatusData>[].obs;
  Rx<LeadStatusData?> selectedLeadStatusData = Rx<LeadStatusData?>(null);
  Rx<LeadStatusData?> selectedLeadStatusDropdawnData =
      Rx<LeadStatusData?>(null);
  Rx<LeadStatusData?> addselectedLeadStatusData = Rx<LeadStatusData?>(null);
  Rx<LeadStatusData?> selectedLeadStatusUpdateData = Rx<LeadStatusData?>(null);
  Future<void> statusListApi({required status}) async {
    Future.microtask(() {
      isStatusListLoading.value = true;
    });
    final result = await LeadService().statusListApi();
    if (result != null) {
      leadStatusData.assignAll(result.data!);

      for (var val in result.data!) {
        await DatabaseHelper.instance.insertLeadStatus(val);
      }
      if (status != null) {
        for (var val in leadStatusData) {
          if (val.id.toString() == status.toString() ||
              val.name.toString().toLowerCase() == status.toString()) {
            selectedLeadStatusData.value = val;
            break;
          }
        }
        print('lead selected id from home ${selectedLeadStatusData.value?.id}');
        await leadsList(
            selectedLeadStatusData.value?.id, selectedLeadType.value);
      }
      isStatusListLoading.value = false;
    } else {}
    isStatusListLoading.value = false;
  }

  var isLeadDetailsLoading = false.obs;
  Rx<LeadDetailsData?> leadDetails = Rx<LeadDetailsData?>(null);
  Future<void> leadDetailsApi({required leadId}) async {
    isLeadDetailsLoading.value = true;
    final result = await LeadService().leadDetailsApi(leadId);
    if (result != null) {
      leadDetails.value = result.data;
      await sourceList(source: leadDetails.value?.source);
      await offLineStatusdata(status: leadDetails.value?.status.toString());
      selectedGender.value = leadDetails.value?.gender ?? "";
    }
    isLeadDetailsLoading.value = false;
  }

  var isStatusListDeleting = false.obs;
  Future<void> deleteLeadApi() async {
    isStatusListDeleting.value = true;
    final result = await LeadService().statusListApi();
    if (result != null) {
      leadStatusData.assignAll(result.data!);
    } else {}
    isStatusListDeleting.value = false;
  }

  var followupStatusList = ["Done", "Not Done", "Reshedule"].obs;
  RxList<String> selectedStatusTypeList = <String>[].obs;
  RxList<FollowUpsListData> followUpsListData = <FollowUpsListData>[].obs;
  Rx<FollowUpsListData?> selectedFollowUpsListData =
      Rx<FollowUpsListData?>(null);
  var isFollowupsListLoading = false.obs;
  Future<void> followUpsListApi({required dynamic leadId}) async {
    isFollowupsListLoading.value = true;
    final result = await LeadService().followUpsListApi(leadId);
    if (result != null) {
      followUpsListData.assignAll(result.data!);
      selectedStatusTypeList.clear();
      selectedStatusTypeList
          .addAll(List<String>.filled(followUpsListData.length, ''));
      refresh();
      for (var dt in followUpsListData) {
        if (dt.followUpDate != null && dt.followUpTime != null) {
          try {
            String dateInput = "${dt.followUpDate} ${dt.followUpTime}";
            DateTime? dateTime;
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
              dateTime = inputFormat.parse(dateInput.toLowerCase());
            } catch (e) {
              print("Error parsing with lowercase AM/PM: $e");
            }
            if (dateTime == null) {
              try {
                DateFormat inputFormat =
                    DateFormat("dd-MM-yyyy h:mm a", 'en_US');
                dateTime = inputFormat.parse(dateInput.toUpperCase());
              } catch (e) {
                print("Error parsing with uppercase AM/PM: $e");
              }
            }
            if (dateTime != null) {
              DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm", 'en_US');
              print('Formatted Date Input: 65ew54 $dateTime');
              String dateOutput = outputFormat.format(dateTime);
              List<String> splitDt = dateOutput.split(" ");
              List<String> splitDt2 = splitDt.first.split('-');
              List<String> splitDt3 = splitDt[1].split(':');

              String strReminder = "${dt.reminder}";
              int minute = int.parse(splitDt3.last);
              int hour = int.parse(splitDt3.first);

              if (strReminder != "null") {
                List<String> splitReminder = strReminder.split(" ");
                int reminderTime = int.parse(splitReminder.first);
                String reminderTimeType = splitReminder.last.toLowerCase();

                if (reminderTimeType == 'minutes') {
                  minute -= reminderTime;
                } else if (reminderTimeType == 'hours') {
                  hour -= reminderTime;
                }
              }

              DateTime dtNow = DateTime.now();
              DateTime targetDate = DateTime(
                int.parse(splitDt2.last),
                int.parse(splitDt2[1]),
                int.parse(splitDt2.first),
                hour,
                minute,
                0,
              );

              print("task alarm date in controller $targetDate");
              if (targetDate.isAfter(dtNow)) {
                LocalNotificationService().scheduleNotification(
                  targetDate,
                  leadId,
                  dt.leadsName ?? '',
                  'followup',
                );
              }
            } else {
              print("Failed to parse date for task: ${dt.leadsName}");
            }
          } catch (e) {}
        }
      }
    }
    isFollowupsListLoading.value = false;
  }

  RxList<FollowUpsTypeData> followUpsTypeListData = <FollowUpsTypeData>[].obs;
  Rx<FollowUpsTypeData?> selectedFollowUpsTypeListData =
      Rx<FollowUpsTypeData?>(null);
  var isFollowupsTypeListLoading = false.obs;
  Future<void> followUpsTypeListApi({required leadId}) async {
    isFollowupsTypeListLoading.value = true;
    final result = await LeadService().followUpsTypeListApi(leadId: leadId);
    if (result != null) {
      followUpsTypeListData.assignAll(result.data!);
    }
    isFollowupsTypeListLoading.value = false;
  }

  Rx<VisitTypeData?> selectedVisitTypeListData = Rx<VisitTypeData?>(null);
  RxList<ListVisitData> leadVisitListData = <ListVisitData>[].obs;
  var isListVisitLoading = false.obs;
  Future<void> listVisitApi({required leadId}) async {
    isListVisitLoading.value = true;
    final result = await LeadService().leadVisitApi(leadId);
    if (result != null) {
      leadVisitListData.assignAll(result.data!);
    }
    isListVisitLoading.value = false;
  }

  RxList<VisitTypeData> leadVisitTypeListData = <VisitTypeData>[].obs;
  var isListVisitTypeLoading = false.obs;
  Future<void> listVisitTypeApi() async {
    isListVisitTypeLoading.value = true;
    final result = await LeadService().leadVisitTypeApi();
    if (result != null) {
      leadVisitTypeListData.assignAll(result.data!);
    }
    isListVisitTypeLoading.value = false;
  }

  var isFollowUpsAdding = false.obs;
  Future<void> addFollowUps(
      {required followupsType,
      required String followupsDate,
      required String followupsTime,
      required String note,
      int? status,
      int? leadId}) async {
    isFollowUpsAdding.value = true;
    final result = await LeadService().addFollowUpsApi(
      followupsType,
      followupsDate,
      followupsTime,
      note,
      status,
      leadId,
    );
    if (result != null) {
      Get.back();
      await followUpsListApi(leadId: leadId ?? 0);
    } else {}
    isFollowUpsAdding.value = false;
  }

  var isDetailsUpdating = false.obs;
  Future<void> updateDetails(
      {required String name,
      required String companyName,
      required String phone,
      required String email,
      required String designation,
      SourceListData? source,
      required String noofProject,
      required String regionalOffice,
      LeadStatusData? status,
      required String refDetails,
      required String type,
      required String descriptin,
      required String siteAddress,
      required String officeAddress,
      required String city,
      required leadId,
      int? followupType,
      required String followupDate,
      required String followupTime,
      required String reminder}) async {
    isDetailsUpdating.value = true;
    final result = await LeadService().updateLeadDetails(
      name,
      companyName,
      phone,
      email,
      designation,
      source,
      noofProject,
      regionalOffice,
      status,
      refDetails,
      type,
      descriptin,
      siteAddress,
      officeAddress,
      city,
      pickedVisitingFile.value,
      pickedFile.value,
      leadId,
      followupType,
      followupDate,
      followupTime,
      reminder,
    );
    if (result != null) {
      Get.back();
    } else {}
    isDetailsUpdating.value = false;
  }

  var isVisitAdding = false.obs;
  Future<void> addVisit(
      {required String nameController,
      required String phoneController,
      required String emailController,
      required String descriptionController,
      required String addressController,
      VisitTypeData? visitType,
      required leadId}) async {
    isVisitAdding.value = true;
    final result = await LeadService().addVisitApi(
        nameController,
        phoneController,
        emailController,
        descriptionController,
        addressController,
        visitType?.id,
        leadId);
    if (result != null) {
      Get.back();
      await listVisitApi(leadId: leadId);
    } else {}
    isVisitAdding.value = false;
  }

  Rx<ProductListData?> selectedProductData = Rx<ProductListData?>(null);
  RxList<ProductListData> productListData = <ProductListData>[].obs;
  final RxList<ProductListData> cart = <ProductListData>[].obs;
  var isProductLoading = false.obs;
  Future<void> productListApi() async {
    isProductLoading.value = true;
    final result = await LeadService().productListApi();
    if (result != null) {
      productListData.assignAll(result.data!);
      refresh();
    }
    isProductLoading.value = false;
  }

  var isQuotationAdding = false.obs;
  Future<void> addQuotationApi({
    required leadId,
    required dynamic lead,
    required dynamic transaction,
    required dynamic valid,
    required dynamic type,
    required dynamic rate,
    required dynamic advance,
    required dynamic security,
    int? revisedId,
  }) async {
    isQuotationAdding.value = true;
    final result = await LeadService().addQuotationApi(leadId, transaction,
        valid, type, rate, advance, security, items, revisedId);
    if (result != null) {
      Get.back();
      await quotationListApi(leadId: leadId);
    } else {}
    isQuotationAdding.value = false;
  }

  var isStatusUpdating = false.obs;
  Future<void> statusUpdate({
    required leadId,
    int? status,
    required String widgetStatus,
  }) async {
    isStatusUpdating.value = true;
    final result = await LeadService().statusUpdate(leadId, status);
    if (result != null) {
      Get.back();
      selectedLeadStatusUpdateData.value = null;
      await leadsList(selectedLeadStatusData.value?.id, selectedLeadType.value);
    } else {}
    isStatusUpdating.value = false;
  }

  var isContactAdding = false.obs;
  Future<void> addContact({
    required leadId,
    required String name,
    required String phone,
    required String email,
    required String designation,
  }) async {
    isStatusUpdating.value = true;
    final result =
        await LeadService().addContact(leadId, name, phone, email, designation);
    if (result != null) {
      Get.back();
      selectedLeadStatusUpdateData.value = null;
      await leadContactList(leadId: leadId);
    } else {}
    isStatusUpdating.value = false;
  }

  RxList<int> documentIdList = <int>[].obs;
  RxList<File> documentUplodedList = <File>[].obs;
  var isDocumentUploading = false.obs;
  Future<void> documentUploading(
      {required RxList<int> documentId,
      required RxList<File> ducument,
      required leadId,
      required quotationId}) async {
    isDocumentUploading.value = true;
    final result = await LeadService().documentUploading(
      documentId,
      ducument,
      leadId,
      quotationId,
    );
    if (result != null) {
      Get.back();
      selectedLeadStatusUpdateData.value = null;
    } else {}
    isDocumentUploading.value = false;
  }

  var isSingleDocumentUploading = false.obs;
  Future<void> approveDocument({int? documentId, required leadId}) async {
    isSingleDocumentUploading.value = true;
    final result = await LeadService().approveDocument(documentId);
    if (result != null) {
      await leadDocumentList(leadId: leadId, from: "approve");
      isSingleDocumentUploading.value = false;
    } else {}
    isSingleDocumentUploading.value = false;
  }

  RxList<QuotationListData> quotationListData = <QuotationListData>[].obs;
  var isQuotationLoading = false.obs;
  Future<void> quotationListApi({required leadId, String? leadNumber}) async {
    isQuotationLoading.value = true;
    final result = await LeadService().quotationListApi(leadId);
    if (result != null) {
      quotationListData.assignAll(result.data!);
    } else {}
    isQuotationLoading.value = false;
  }

  RxList<SessionListData> sessionListData = <SessionListData>[].obs;
  var issessionLoading = false.obs;
  Future<void> sessionListApi({required leadId}) async {
    issessionLoading.value = true;
    final result = await LeadService().sessionListApi(leadId);
    if (result != null) {
      if (result.data!.isNotEmpty) {
        sessionListData.assignAll(result.data!);
      }
    } else {}
    issessionLoading.value = false;
  }

  RxList<DocumentTypeListData> documentTypeListData =
      <DocumentTypeListData>[].obs;
  var isDocumentTypeLoading = false.obs;
  Future<void> documentType() async {
    isDocumentTypeLoading.value = true;
    final result = await LeadService().documentTypeList();
    if (result != null) {
      isDocumentCheckBoxSelected.clear();
      if (result.data!.isNotEmpty) {
        documentTypeListData.assignAll(result.data!);
        isDocumentTypeLoading.value = false;
        isDocumentTypeLoading.refresh();
        documentIdList.addAll(List.filled(documentTypeListData.length, 0));
        documentUplodedList
            .addAll(List.filled(documentTypeListData.length, File('')));
        isDocumentCheckBoxSelected
            .addAll(List.filled(documentTypeListData.length, false));
      }
    } else {}
    isDocumentTypeLoading.value = false;
  }

  RxList<UploadedDocumentData> leadDocumentListData =
      <UploadedDocumentData>[].obs;
  var isDocumentListLoading = false.obs;
  Future<void> leadDocumentList(
      {required int leadId, required String from}) async {
    if (from == 'initstate') {
      isDocumentListLoading.value = true;
    }
    final result = await LeadService().leadDocumentList(leadId);
    if (result != null) {
      if (result.status == true) {
        isDocumentCheckBoxSelected.clear();
        leadDocumentListData.assignAll(result.data!);
        isDocumentListLoading.value = false;
        isDocumentListLoading.refresh();
        isDocumentCheckBoxSelected
            .addAll(List.filled(leadDocumentListData.length, false));
        for (int i = 0; i < leadDocumentListData.length; i++) {
          if (leadDocumentListData[i].status == 1) {
            isDocumentCheckBoxSelected[i] = true;
          } else {
            isDocumentCheckBoxSelected[i] = false;
          }
        }
        isDocumentListLoading.value = false;
        documentTypeListData.refresh();
      }
    } else {}
    isDocumentListLoading.value = false;
  }

  RxList<LeadContactData> leadContactData = <LeadContactData>[].obs;
  RxList<LeadContactData> selectedLeadContactData = <LeadContactData>[].obs;
  RxList<AssignedToUsers> selectedMergeContactData = <AssignedToUsers>[].obs;
  var isLeadContactLoading = false.obs;
  Future<void> leadContactList({required leadId}) async {
    isLeadContactLoading.value = true;
    final result = await LeadService().leadContactList(leadId);
    if (result != null) {
      leadContactData.assignAll(result.data!);
    }
    isLeadContactLoading.value = false;
  }

  Future<void> uploadOfflineLead(LeadListData lead) async {
    try {
      File audioFile = File(lead.audio ?? '');

      final result = await LeadService().addLeadsApi(
        leadName: lead.leadName.toString(),
        companyName: lead.company.toString(),
        phone: lead.phone.toString(),
        email: lead.email.toString(),
        source: lead.source.toString(),
        status: lead.status.toString(),
        description: lead.description.toString(),
        pickedFile: File(lead.image),
        audio: audioFile,
      );

      if (result != null) {
        await leadsList(
            selectedLeadStatusData.value?.id, selectedLeadType.value);
        debugPrint("Offline lead ${lead.leadName} synced successfully.");
      } else {
        debugPrint("Failed to sync offline lead: ${lead.leadName}");
      }
    } catch (e) {
      debugPrint("Exception during lead sync: $e");
    }
  }

  var profilePicPath = "".obs;
  Rx<File> leadpickedFile = File('').obs;
  var isLeadNoteAdding = false.obs;
  Future<void> addLeadNote(
      String text, String jsonEncode, String value, int leadId) async {
    isLeadNoteAdding.value = true;
    final result = await LeadService()
        .addLeadNote(text, jsonEncode, value, leadId, leadpickedFile);
    if (result != null) {
      Get.back();
      await leadNoteList(leadId: leadId);
      selectedLeadStatusUpdateData.value = null;
    } else {}
    isLeadNoteAdding.value = false;
  }

  var isGridViewVisible = false.obs;
  RxList<LeadNoteData> leadNotesData = <LeadNoteData>[].obs;
  var isLeadNotesLoading = false.obs;
  Future<void> leadNoteList({required leadId}) async {
    isLeadNotesLoading.value = true;
    final result = await LeadService().leadNotesList(leadId);
    if (result != null) {
      leadNotesData.assignAll(result.data!);
    }
    isLeadNotesLoading.value = false;
  }

  var isPinnLoading = false.obs;
  Future<void> pinNote(int? id) async {
    isPinnLoading.value = true;
    final result = await LeadService().pinNotesApi(id);
    if (result != null) {
      selectedLeadStatusUpdateData.value = null;
    } else {}
    isPinnLoading.value = false;
  }

  var isDiscussionSending = false.obs;
  var messagePicPath = ''.obs;
  Future<void> leadDiscussionSend(String text, leadId, File attachment) async {
    isDiscussionSending.value = true;
    final result =
        await LeadService().sendLeadDiscussion(text, leadId, attachment);
    if (result != null) {}
    isDiscussionSending.value = false;
  }

  TextEditingController messageTextEditingController = TextEditingController();

  Future<void> updateLeadDiscussionChat({
    required String message,
    required File attachment,
    required leadId,
  }) async {
    String formattedDateTime =
        DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    print('iuws83 dateTime $formattedDateTime');

    final newMessage = LeadDiscussionData(
      id: 0,
      senderId: StorageHelper.getId(),
      message: message,
      attachment: attachment.path,
      timestamp: formattedDateTime,
      senderName: StorageHelper.getName(),
    );

    leadDiscussionListData.add(newMessage);
    refresh();
    await leadDiscussionSend(message, leadId, attachment);
  }

  var isDiscussionLoading = false.obs;
  RxList<LeadDiscussionData> leadDiscussionListData =
      <LeadDiscussionData>[].obs;
  Future<void> leadDiscussionList(int? id) async {
    isDiscussionLoading.value = true;
    final result = await LeadService().leadDiscussionList(id);
    if (result != null) {
      leadDiscussionListData.assignAll(result.data!);
      print(
          "lead discussion list data length ${leadDiscussionListData.length}");
    } else {}
    isDiscussionLoading.value = false;
  }

  final TextEditingController itemControlelr = TextEditingController();
  final TextEditingController qtyControlelr = TextEditingController();
  final TextEditingController rateControlelr = TextEditingController();
  RxList<QuotationItem> items = <QuotationItem>[].obs;
  Future<void> addItemToList({int? productId, String? productName}) async {
    String qty = qtyControlelr.text;
    String rate = rateControlelr.text;

    if (productId.toString().isNotEmpty && qty.isNotEmpty && rate.isNotEmpty) {
      items.add(QuotationItem(
          productName: productName.toString(),
          productId: productId ?? 0,
          quantity: qty,
          rate: rate));
      Get.back();
      clearFormFields();
    }
  }

  void clearFormFields() {
    itemControlelr.clear();
    qtyControlelr.clear();
    rateControlelr.clear();
  }

  var pdfFile = ''.obs;
  var isQuotationDownloading = false.obs;

  Future<void> downloadQuotation(int? id, String? quotationNumber) async {
    isQuotationDownloading.value = true;

    final Uint8List? pdfData = await LeadService().downloadQuotationApi(id!);
    if (pdfData != null) {
      final directory = await getApplicationDocumentsDirectory();

      String replaceSlac = '';
      if ((quotationNumber ?? "").contains("/")) {
        replaceSlac = (quotationNumber ?? "").replaceAll("/", "_");
      } else {
        replaceSlac = quotationNumber ?? "";
      }

      final folderPath = '${directory.path}/quotation_$replaceSlac';
      final folder = Directory(folderPath);

      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final filePath = '$folderPath/quotation.pdf';

      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      CustomToast().showCustomToast("Quotation downloaded successfully.");
      Get.to(() => PDFScreen(file: file));

      print('✅ PDF saved to $filePath');
    }
    isQuotationDownloading.value = false;
  }

  var isPeopleAdding = false.obs;
  Future<void> addPeople(
      {required personid, int? leadId, required String from}) async {
    isPeopleAdding.value = true;
    final result = await LeadService()
        .addPeople(personid, leadId, from, selectdePersonIds);
    if (result != null) {
      Get.back();
    } else {}
    isPeopleAdding.value = false;
  }

  RxList<ResponsiblePersonData> selectdePersonIds =
      <ResponsiblePersonData>[].obs;

  var isResponsiblePersonLoading = false.obs;
  Rx<ResponsiblePersonData?> selectedResponsiblePersonData =
      Rx<ResponsiblePersonData?>(null);
  RxList<ResponsiblePersonData> responsiblePersonList =
      <ResponsiblePersonData>[].obs;
  Future<void> taskResponsiblePersonListApi() async {
    Future.microtask(() {
      isResponsiblePersonLoading.value = true;
    });
    final result = await LeadService().responsiblePersonListApi();
    if (result != null) {
      responsiblePersonList.assignAll(result.data!);
    }
    Future.microtask(() {
      isResponsiblePersonLoading.value = false;
    });
  }

  RxList<String> visitStatustype = <String>['Start', "Done", "Reshedule"].obs;
  RxString selectedVisitStatus = "".obs;
  var isLeadVisitStatusChanging = false.obs;
  Future<void> changeVisitStatus(
      {required File image,
      required String latitude,
      required String longitude,
      int? id,
      required int status,
      required String remark,
      required leadid,
      required String selectedValue,
      required List<AssignedToUsers> mergedPeopleList}) async {
    isLeadVisitStatusChanging.value = true;
    final result = await LeadService()
        .changeVisitStatusApi(image, latitude, longitude, id, status, remark);
    if (result != null) {
      Get.back();
      await leadContactList(
        leadId: leadid ?? 0,
      );
      await fetchLeadMeetings(leadId: leadid ?? 0, visitid: id);
      if (selectedValue == "Reshedule") {
        Get.to(() =>
            MeetingScreens(leadId: leadid, mergedPeopleList: mergedPeopleList));
      }
    } else {}
    isLeadVisitStatusChanging.value = false;
  }

  RxBool isLoading = false.obs;
  RxList<GetListLeadMetting> meetingList = <GetListLeadMetting>[].obs;

  var meetingTimers = <RxString>[].obs;

  void startTimerForIndex(int index) {
    while (meetingTimers.length <= index) {
      meetingTimers.add('00:00:00'.obs);
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (meetingList[index].status.toString() != "1") {
        timer.cancel();
      } else {
        final currentTime = DateTime.now();

        final startTimeString = meetingList[index].startMeetingTime;
        if (startTimeString == null || startTimeString.isEmpty) {
          timer.cancel();
          return;
        }

        final startTime = DateTime.tryParse(startTimeString);
        if (startTime == null) {
          timer.cancel();
          return;
        }

        final diff = currentTime.difference(startTime);
        meetingTimers[index].value = _formatDuration(diff);
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  final Dio _dio = Dio();

  Future<void> fetchLeadMeetings(
      {required dynamic leadId, int? visitid}) async {
    isLoading.value = true;

    try {
      final token = await StorageHelper.getToken();
      print("lead id in lead meeting list ${leadId}");
      _dio.options.headers["Authorization"] = "Bearer $token";
      var url = ApiConstant.baseUrl + ApiConstant.lead_meetings_list;
      final response = await _dio.get(
        leadId != null ? '$url?lead_id=$leadId' : url,
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        final parsed = GetLeadListModule.fromJson(response.data);
        meetingList.assignAll(parsed.data!.reversed.toList());

        selectedStatusTypeList.clear();
        selectedStatusTypeList
            .addAll(List<String>.filled(meetingList.length, ''));

        for (var dt in meetingList) {
          if (dt.meetingDate != null && dt.meetingTime != null) {
            print('shedule meeting date ${dt.meetingDate} ${dt.meetingTime}');
            try {
              String dateInput = "${dt.meetingDate} ${dt.meetingTime}";

              DateTime? dateTime;
              try {
                DateFormat inputFormat =
                    DateFormat("dd-MM-yyyy h:mm a", 'en_US');
                dateTime = inputFormat.parse(dateInput.toLowerCase());
              } catch (e) {
                print("Error parsing with lowercase AM/PM: $e");
              }

              if (dateTime == null) {
                try {
                  DateFormat inputFormat =
                      DateFormat("dd-MM-yyyy h:mm a", 'en_US');
                  dateTime = inputFormat.parse(dateInput.toUpperCase());
                } catch (e) {
                  print("Error parsing with uppercase AM/PM: $e");
                }
              }
              if (dateTime != null) {
                DateFormat outputFormat =
                    DateFormat("dd-MM-yyyy HH:mm", 'en_US');
                print('Formatted Date Input: 65ew54 meeting $dateTime');
                String dateOutput = outputFormat.format(dateTime);
                List<String> splitDt = dateOutput.split(" ");
                List<String> splitDt2 = splitDt.first.split('-');
                List<String> splitDt3 = splitDt[1].split(':');

                String strReminder = "${dt.reminder}";
                int minute = int.parse(splitDt3.last);
                int hour = int.parse(splitDt3.first);

                if (strReminder != "null") {
                  List<String> splitReminder = strReminder.split(" ");
                  int reminderTime = int.parse(splitReminder.first);
                  String reminderTimeType = splitReminder.last.toLowerCase();

                  if (reminderTimeType == 'minutes') {
                    minute -= reminderTime;
                  } else if (reminderTimeType == 'hours') {
                    hour -= reminderTime;
                  }
                }

                DateTime dtNow = DateTime.now();
                DateTime targetDate = DateTime(
                  int.parse(splitDt2.last),
                  int.parse(splitDt2[1]),
                  int.parse(splitDt2.first),
                  hour,
                  minute,
                  0,
                );

                if (targetDate.isAfter(dtNow)) {
                  print("task alarm date in controller $targetDate");
                  LocalNotificationService().scheduleNotification(
                    targetDate,
                    leadId,
                    dt.meetingTitle ?? '',
                    'lead_meeting',
                  );
                }
              } else {
                print("Failed to parse date for task: ${dt.meetingMom}");
              }
            } catch (e) {}
          }
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.statusCode} ${e.response?.data}");
      Get.snackbar('Dio Error', e.message.toString());
    } catch (e) {
      print("Other Exception: $e");
      Get.snackbar('Error', 'Unexpected error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMeetingMom({
    required dynamic id,
    required dynamic meetingMom,
    required dynamic status,
  }) async {
    final Dio dio = Dio();

    try {
      final token = await StorageHelper.getToken();

      final response = await dio.post(
        ApiConstant.baseUrl + ApiConstant.change_lead_meeting_status,
        data: {
          "id": id.toString(),
          "meeting_mom": meetingMom,
          "status": status.toString(),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Meeting updated successfully");
      } else {
        Get.snackbar("Failed", "Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");
      Get.snackbar("Dio Error", e.message.toString());
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }

  var isFollowupAdding = false.obs;
  Future<void> addFollowup({
    required dynamic followupsType,
    required dynamic followupsDate,
    required dynamic followupsTime,
    required dynamic note,
    int? status,
    dynamic? leadId,
    required String reminder,
  }) async {
    isPeopleAdding.value = true;
    final result = await LeadService().addFollowup(followupsType, followupsDate,
        followupsTime, note, status, leadId, reminder);
    if (result != null) {
      Get.back();
      Get.back();
      await followUpsListApi(leadId: leadId);
    } else {}
    isPeopleAdding.value = false;
  }

  var isMarketingManagerApproving = false.obs;
  Future<void> approveMarketingManager(
      {required leadId, required String remark, required int status}) async {
    isMarketingManagerApproving.value = true;
    final result =
        await LeadService().markitingManagerApproving(leadId, remark, status);
    if (result != null) {
      Get.back();
      // Get.back();
      // await followUpsListApi(leadId: leadId);
    } else {}
    isMarketingManagerApproving.value = false;
  }

  var isBranchHeadManagerApproving = false.obs;
  Future<void> branchheadManagerApproving(
      {required leadId,
      required String remark,
      required int status,
      required File attachment}) async {
    isBranchHeadManagerApproving.value = true;
    final result = await LeadService()
        .branchHeadManagerApproving(leadId, remark, status, attachment);
    if (result != null) {
      Get.back();
      // Get.back();
      // await followUpsListApi(leadId: leadId);
    } else {}
    isBranchHeadManagerApproving.value = false;
  }

  RxList<String> timeList = <String>[
    "Minutes",
    "Hours",
  ].obs;
  RxString? selectedTime = "".obs;
}
