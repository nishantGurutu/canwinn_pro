import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/data/model/visit_type_list.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:dio/dio.dart';
import 'package:task_management/model/LeadNoteModel.dart';
import 'package:task_management/model/added_document_lead_list_model.dart';
import 'package:task_management/model/document_type_list_model.dart';
import 'package:task_management/model/follow_ups_list_model.dart';
import 'package:task_management/model/followups_type_list_model.dart';
import 'package:task_management/model/home_lead_model.dart';
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
import 'package:task_management/model/uploaded_document_list_model.dart';
import 'package:task_management/model/user_report_model.dart';

class LeadService {
  final Dio _dio = Dio();
  Future<bool> addLeadsApi({
    required dynamic leadName,
    required dynamic companyName,
    required dynamic phone,
    required dynamic email,
    required dynamic source,
    required dynamic status,
    required dynamic description,
    required File pickedFile,
    required File audio,
  }) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
        logPrint: (object) {
          print('Add lead log print data value ${object}');
        },
      ));

      final Map<String, dynamic> formDataMap = {
        'name': leadName.toString(),
        'lead_type': industry.toString(),
        'company_name': companyName.toString(),
        'phone': phone.toString(),
        'email': email.toString(),
        'source': source.toString(),
        'status': status.toString(),
        'description': description.toString(),
        'latitude': '${LocationHandler.currentPosition?.latitude}',
        'longitude': '${LocationHandler.currentPosition?.longitude}',
      };

      if (pickedFile.path.isNotEmpty) {
        final fileName = pickedFile.path.split('/').last;
        formDataMap['image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: fileName,
        );
      }
      if (audio.path.isNotEmpty) {
        final filePath = audio.path;
        final fileName = filePath.split('/').last;

        final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

        formDataMap['audio'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_leads,
        data: formData,
        options: Options(
          validateStatus: (s) => s != null && s < 500,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await DatabaseHelper.instance.insertStatus(status: "online");

        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else if (response.statusCode == 400) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> updateLeadsApi({
    required String leadName,
    required String companyName,
    required String phone,
    required String email,
    required String source,
    required String industry,
    required String status,
    required String tag,
    required String description,
    required String address,
    required Rx<File> pickedFile,
    required id,
  }) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      final Map<String, dynamic> formDataMap = {
        'name': leadName.toString(),
        'lead_type': industry.toString(),
        'company_name': companyName.toString(),
        'phone': phone.toString(),
        'email': email.toString(),
        'source': source.toString(),
        'status': status.toString(),
        'description': description.toString(),
        'latitude': '${LocationHandler.currentPosition?.latitude}'.toString(),
        'longitude': '${LocationHandler.currentPosition?.longitude}'.toString(),
        'id': id.toString(),
      };

      if (pickedFile.value.path.isNotEmpty) {
        final fileName = pickedFile.value.path.split('/').last;
        formDataMap['image'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.update_leads,
        data: formData,
        options: Options(
          validateStatus: (s) => s != null && s < 500,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return true;
      }
    } catch (e) {
      print("Add lead error: $e");
      return false;
    }
  }

  Future<bool> assignFollowup(
      RxList<ResponsiblePersonData> personid, int? followupId) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      String ids = personid
          .map((e) => e.id.toString())
          .toList()
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll(' ', '');

      final Map<String, dynamic> formDataMap = {
        'follow_up_id': followupId.toString(),
        'assigned_to': ids.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        '${ApiConstant.baseUrl + ApiConstant.assign_followup}',
        data: formData,
        options: Options(
          validateStatus: (s) => s != null && s < 500,
          receiveDataWhenStatusError: true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return true;
      }
    } catch (e) {
      print("Add lead error: $e");
      return false;
    }
  }

  Future<LeedListModel?> leadsListApi(int? id, String leadTypeValue) async {
    try {
      final token = StorageHelper.getToken();
      print("Token wiuye873 38798e3s79j9used: $id");
      var userId = StorageHelper.getId();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));
      var leadSelectedtype = "";
      if (leadTypeValue == "Created by me") {
        leadSelectedtype = 'created_by_me';
      } else if (leadTypeValue == "Assigned to me") {
        leadSelectedtype = 'assigned_to_me';
      } else if (leadTypeValue == "Added to me") {
        leadSelectedtype = 'added_to_me';
      }

      print("kjdh8743 3iu843 ${leadSelectedtype}");
      var url =
          "${ApiConstant.baseUrl + ApiConstant.leads_list}?user_id=$userId";
      final response = await _dio.get(
        ((id == null || id == "null") &&
                (leadSelectedtype.isEmpty || leadSelectedtype == ""))
            ? '${ApiConstant.baseUrl + ApiConstant.leads_list}?user_id=$userId'
            : ((id != null || id != "null") &&
                    (leadSelectedtype.isEmpty || leadSelectedtype == ""))
                ? "$url&status=$id"
                : ((id == null || id == "null") &&
                        (leadSelectedtype.isNotEmpty || leadSelectedtype != ""))
                    ? "$url&type=$leadSelectedtype"
                    : "$url&status=$id&type=$leadSelectedtype",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeedListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<AddedDocumentLeadModel?> addedDocumentLeadList() async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.added_document_lead_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddedDocumentLeadModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<SourseListModel?> sourseList() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.source_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SourseListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<SourseListModel?> addedLeadList() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.source_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SourseListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadStatusListModel?> statusListApi() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.lead_status_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadStatusListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadDetailsModel?> leadDetailsApi(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'lead_id': leadId.toString(),
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.lead_details,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadDetailsModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<HomeLeadsModel?> leadHomeApi() async {
    try {
      final userId = StorageHelper.getId();
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'user_id': userId.toString(),
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio
          .post(ApiConstant.baseUrl + ApiConstant.home_lead, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeLeadsModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<HomeLeadsModel?> userleadHomeApi(homeAdminUserId) async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'user_id': homeAdminUserId.toString(),
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio
          .post(ApiConstant.baseUrl + ApiConstant.home_lead, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeLeadsModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<UserReportModel?> userReportApi(homeAdminUserId) async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'user_id': homeAdminUserId.toString(),
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
          ApiConstant.baseUrl + ApiConstant.get_user_report,
          data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserReportModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadStatusListModel?> deleteLeadApi() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.delete(
        ApiConstant.baseUrl + ApiConstant.delete_lead,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadStatusListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<FollowUpsListModel?> followUpsListApi(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {};
      if (leadId != 0) {
        formDataMap['lead_id'] = leadId.toString();
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.lead_followup_list,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FollowUpsListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<FollowUpsTypeListModel?> followUpsTypeListApi(
      {required leadId}) async {
    try {
      final token = StorageHelper.getToken();
      print("Token 6twfs66w7 used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.followup_type_list}?lead_id=$leadId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FollowUpsTypeListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadVisitListModel?> leadVisitApi(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Token 8273y8ey9832 used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.followup_type_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadVisitListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadVisitTypeListModel?> leadVisitTypeApi() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.visit_type_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadVisitTypeListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<bool> addFollowUpsApi(followupsType, String followupsDate,
      String followupsTime, String note, int? status, int? leadId) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'follow_up_type': followupsType.toString(),
        'follow_up_date': followupsDate.toString(),
        'follow_up_time': followupsTime.toString(),
        'note': note.toString(),
        'status': status.toString(),
      };

      if (leadId.toString().isNotEmpty) {
        formDataMap['lead_id'] = leadId;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_follow_ups,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else if (response.statusCode == 400) {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> updateLeadDetails(
      String name,
      String companyName,
      String phone,
      String email,
      String designation,
      SourceListData? source,
      String noofProject,
      String regionalOffice,
      LeadStatusData? status,
      String refDetails,
      String type,
      String descriptin,
      String siteAddress,
      String officeAddress,
      String city,
      File visitFile,
      File pickedFile,
      leadId,
      int? followupType,
      String followupDate,
      String followupTime,
      String reminder) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'name': name.toString(),
        'lead_type': 'organigation'.toString(),
        'company_name': companyName.toString(),
        'phone': phone.toString(),
        'email': email.toString(),
        'source': source?.id.toString(),
        'status': status?.id.toString(),
        'description': description.toString(),
        'latitude': '${LocationHandler.currentPosition?.latitude}'.toString(),
        'longitude': '${LocationHandler.currentPosition?.longitude}'.toString(),
        'designation': designation.toString(),
        'no_of_project': noofProject.toString(),
        'regional_ofc': regionalOffice.toString(),
        'reference_details': refDetails.toString(),
        'type': type.toString(),
        'address_line1': siteAddress.toString(),
        'address_line2': officeAddress.toString(),
        'city_town': city.toString(),
        'id': leadId.toString(),
        'reminder': reminder,
      };

      print("data value in form data 87y9822 ${formDataMap}");
      if (followupDate.isNotEmpty) {
        formDataMap['follow_up_date'] = followupDate;
      }
      if (followupTime.isNotEmpty) {
        formDataMap['follow_up_time'] = followupTime;
      }
      if (reminder.isNotEmpty) {
        formDataMap['reminder'] = reminder;
      }
      if (followupType != null) {
        formDataMap['follow_up_type'] = followupType;
      }
      if (pickedFile.path.isNotEmpty) {
        final fileName = pickedFile.path.split('/').last;
        formDataMap['image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: fileName,
        );
      }
      if (visitFile.path.isNotEmpty) {
        final fileName = visitFile.path.split('/').last;
        formDataMap['visiting_card'] = await MultipartFile.fromFile(
          visitFile.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.update_lead_details,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else if (response.statusCode == 400) {
        CustomToast().showCustomToast(response.data['message']);
        return false;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> addVisitApi(
      String nameController,
      String phoneController,
      String emailController,
      String descriptionController,
      String addressController,
      int? id,
      leadId) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'visit_type': id.toString(),
        'visitor_name': nameController.toString(),
        'visitor_phone': phoneController.toString(),
        'visitor_email': emailController.toString(),
        'address': addressController.toString(),
        'latitude': '${LocationHandler.currentPosition?.latitude}'.toString(),
        'longitude': '${LocationHandler.currentPosition?.longitude}'.toString(),
        'description': descriptionController.toString(),
        "lead_id": leadId.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_visit,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<ProductListModel?> productListApi() async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $token");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.products_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<bool> addQuotationApi(
    int leadId,
    dynamic transaction,
    dynamic valid,
    dynamic type,
    dynamic rate,
    dynamic advance,
    dynamic security,
    RxList<QuotationItem> items,
    dynamic revisedId,
  ) async {
    try {
      final token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = Headers.jsonContentType;

      _dio.interceptors.clear();
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));

      final List<Map<String, dynamic>> itemList =
          items.map((item) => item.toJson()).toList();

      final Map<String, dynamic> data = {
        "lead_id": leadId,
        "transaction_date": transaction,
        "valid_till": valid,
        "quotation_type": type,
        "rate": rate,
        "advance_month": advance,
        "security_price": security,
        "items": itemList,
      };

      if (revisedId != null && revisedId > 0) {
        data["revised_from_id"] = revisedId;
      }

      print("Payload: $data");

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_quotation,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast("Failed to submit quotation");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      CustomToast().showCustomToast("Error: ${e.message}");
      return false;
    }
  }

  Future<bool> statusUpdate(
    leadId,
    int? status,
  ) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = Headers.jsonContentType;

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.change_lead_status,
        data: {
          "status": status,
          "id": leadId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast("Failed to submit quotation");
        return false;
      }
    } on DioException catch (e) {
      print("Error: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> addContact(leadId, String name, String phone, String email,
      String designation) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        "lead_id": leadId,
        "name": name,
        "phone": phone,
        "email": email,
        "designation": designation,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_lead_contacts,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> documentUploading(
    RxList<int> documentId,
    RxList<File> ducument,
    leadId,
    quotationId,
  ) async {
    try {
      final token = StorageHelper.getToken();
      final userId = StorageHelper.getId();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        "lead_id": leadId,
        "user_id": userId,
        "quotation_id": quotationId,
      };
      print('ir4u8r4 498ur84 ${formDataMap}');
      for (int i = 0; i < ducument.length; i++) {
        final file = ducument[i];
        final fileName = file.path.split('/').last;

        formDataMap['documents[$i][document_type]'] = documentId[i].toString();
        formDataMap['documents[$i][file]'] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.upload_lead_document,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to upload documents");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> approveDocument(int? documentId) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';
      print('j9e38e 3ue83 ${documentId}');
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        "document_id": documentId,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.approve_lead_document,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to upload documents");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<QuotationListModel?> quotationListApi(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Tokenasf6 quotation skdo used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.list_quotation}?lead_id=$leadId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return QuotationListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<SessionListModel?> sessionListApi(leadId) async {
    try {
      final token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        "lead_id": leadId,
        // "quotation_id": quotationid,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
          ApiConstant.baseUrl + ApiConstant.get_lead_document,
          data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SessionListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<DocumentTypeListModel?> documentTypeList() async {
    try {
      final token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.get_document_types,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DocumentTypeListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<UploadedDocumentListModel?> leadDocumentList(int leadId) async {
    try {
      final token = StorageHelper.getToken();

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      print("iu4r84 4r948ur98 49849 ${leadId}");
      final Map<String, dynamic> formMapData = {
        "lead_id": leadId,
      };
      final formData = FormData.fromMap(formMapData);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.get_lead_document,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadedDocumentListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<LeadContactListModel?> leadContactList(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Tokenasf6 used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.lead_contacts_list}?lead_id=$leadId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadContactListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  // Notes api
  Future<bool> addLeadNote(String text, String jsonEncode, String value,
      int leadId, Rx<File> leadpickedFile) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        "lead_id": leadId,
        "title": text,
        "description": jsonEncode,
      };
      if (leadpickedFile.value.path.isNotEmpty) {
        final fileName = leadpickedFile.value.path.split('/').last;
        formDataMap['attachments'] = await MultipartFile.fromFile(
          leadpickedFile.value.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_lead_notes,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<LeadNotesListModel?> leadNotesList(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Tokenasf6 used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.lead_notes_list}?lead_id=$leadId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadNotesListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<bool> pinNotesApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final formData = FormData.fromMap(
        {
          'notes_id': id,
        },
      );

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.lead_notes_important,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendLeadDiscussion(String text, leadId, File pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();
      print('attachment in lead overview attachment ${pickedFile.path}');
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'lead_id': leadId,
        "sender_id": userId,
      };
      if (text.isNotEmpty) {
        formDataMap['message'] = text;
      }
      if (pickedFile.path.isNotEmpty) {
        final filePath = pickedFile.path;
        final fileName = filePath.split('/').last;

        final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

        formDataMap['attachment'] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.send_lead_discussion,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<LeadDiscussionListModel?> leadDiscussionList(leadId) async {
    try {
      final token = StorageHelper.getToken();
      print("Tokenasf6 used: $leadId");

      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.lead_discussion_list}?lead_id=$leadId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadDiscussionListModel.fromJson(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<Uint8List?> downloadQuotationApi(int id) async {
    try {
      final token = StorageHelper.getToken();
      print("Token used: $id");

      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.download_quotation}/$id",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Uint8List.fromList(response.data);
      } else {
        print("Unexpected response: ${response.data}");
        CustomToast().showCustomToast(response.data['message']);
        return null;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return null;
    }
  }

  Future<bool> addPeople(personid, int? leadId, String from,
      RxList<ResponsiblePersonData> selectdePersonIds) async {
    String ids = selectdePersonIds
        .map((e) => e.id.toString())
        .toList()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '');
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'id': leadId.toString(),
      };

      if (from == "add-people") {
        formDataMap['people_added'] = ids;
      } else {
        formDataMap['assigned_to'] = ids;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.update_lead_people,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<ResponsiblePersonListModel?> responsiblePersonListApi() async {
    try {
      var token = StorageHelper.getToken();
      var url = "${ApiConstant.baseUrl + ApiConstant.responsiblePersonList}";

      print('Responsible person API URL: $url');

      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponsiblePersonListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch responsible person list');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> changeVisitStatusApi(File image, String latitude,
      String longitude, int? id, int status, String remark) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';
      DateTime dt = DateTime.now();
      String formattedTime =
          DateFormat('hh:mm a').format(dt).toString().toUpperCase();
      String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
      print(formattedDate);
      print(formattedTime);
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'id': id.toString(),
        'status': status.toString(),
      };

      if (image.path.isNotEmpty) {
        final fileName = image.path.split('/').last;
        formDataMap['image'] = await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        );
      }
      if (status.toString() == "2") {
        formDataMap['end_meeting_time'] = formattedTime;
      }
      if (status.toString() == "2") {
        formDataMap['out_latitude'] =
            "${LocationHandler.currentPosition?.latitude ?? ""}";
      }
      if (status.toString() == "2") {
        formDataMap['out_longitude'] =
            "${LocationHandler.currentPosition?.longitude ?? ""}";
      }
      if (status.toString() == "1") {
        formDataMap['start_meeting_time'] = formattedTime;
      }
      if (status.toString() == "1") {
        formDataMap['latitude'] =
            "${LocationHandler.currentPosition?.latitude ?? ""}";
      }
      if (status.toString() == "1") {
        formDataMap['longitude'] =
            "${LocationHandler.currentPosition?.longitude ?? ""}";
      }
      if (status.toString() == "2") {
        formDataMap['end_meeting_date'] = formattedTime;
      }
      if (status.toString() == "2" || status.toString() == "3") {
        formDataMap['meeting_mom'] = remark;
      }
      if (status.toString() == "1") {
        formDataMap['start_meeting_date'] = formattedDate;
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.change_lead_meeting_status,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> addFollowup(
      String followupsType,
      String followupsDate,
      String followupsTime,
      String note,
      int? status,
      dynamic leadId,
      String reminder) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'follow_up_type': followupsType,
        'follow_up_date': followupsDate,
        'follow_up_time': followupsTime,
        'note': note,
        'status': status.toString(),
        'reminder': reminder,
      };

      if (leadId.toString() == "null" || leadId.toString().isNotEmpty) {
        formDataMap['lead_id'] = leadId;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_follow_ups,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> markitingManagerApproving(
      leadId, String remark, int status) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      print("euh8 398ue93 e983ue93 ${leadId}");
      print("euh8 398ue93 e983ue93 ${remark}");
      print("euh8 398ue93 e983ue93 ${status}");

      final Map<String, dynamic> formDataMap = {
        'lead_id': leadId,
        'manager_remarks': remark,
        'status': status,
      };
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.manager_approve_lead_document,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }

  Future<bool> branchHeadManagerApproving(
      leadId, String remark, int status, File attachment) async {
    try {
      final token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.contentType = 'multipart/form-data';

      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final Map<String, dynamic> formDataMap = {
        'lead_id': leadId,
        'branchhead_remarks': remark,
        'status': status,
      };

      if (attachment.path.isNotEmpty) {
        final fileName = attachment.path.split('/').last;
        formDataMap['branchhead_agreement'] = await MultipartFile.fromFile(
          attachment.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.branchhead_approve_lead_document,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        print("Error: ${response.data}");
        CustomToast().showCustomToast("Failed to add lead");
        return false;
      }
    } on DioException catch (e) {
      print("Dio error: ${e.response?.statusCode}");
      print("Error response: ${e.response?.data}");
      print("Message: ${e.message}");
      return false;
    }
  }
}
