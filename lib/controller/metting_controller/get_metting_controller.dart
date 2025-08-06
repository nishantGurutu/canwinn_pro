// import 'dart:async';

// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:task_management/model/lead_contact_list_model.dart';
// import 'package:task_management/service/lead_service.dart';
// import 'package:task_management/view/screen/meeting/meeting_form.dart';
// import '../../helper/storage_helper.dart';
// import '../../model/get_list_modules.dart';

// class LeadMeetingListController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxList<GetListLeadMetting> meetingList = <GetListLeadMetting>[].obs;

//   var meetingTimers = <RxString>[].obs;

//   void startTimerForIndex(int index) {
//     while (meetingTimers.length <= index) {
//       meetingTimers.add('00:00:00'.obs);
//     }

//     Timer.periodic(Duration(seconds: 1), (timer) {
//       if (meetingList[index].status.toString() != "1") {
//         timer.cancel();
//       } else {
//         final currentTime = DateTime.now();

//         final startTimeString = meetingList[index].startMeetingTime;
//         if (startTimeString == null || startTimeString.isEmpty) {
//           timer.cancel();
//           return;
//         }

//         final startTime = DateTime.tryParse(startTimeString);
//         if (startTime == null) {
//           timer.cancel();
//           return;
//         }

//         final diff = currentTime.difference(startTime);
//         meetingTimers[index].value = _formatDuration(diff);
//       }
//     });
//   }

//   String _formatDuration(Duration d) {
//     final hours = d.inHours.toString().padLeft(2, '0');
//     final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "$hours:$minutes:$seconds";
//   }

//   final Dio _dio = Dio();

//   Future<void> fetchLeadMeetings({required int leadId, int? visitid}) async {
//     isLoading.value = true;

//     try {
//       final token = await StorageHelper.getToken();

//       final response = await _dio.get(ApiConstant.baseUrl + ApiConstant.lead_meetings_list
//         'https://taskmaster.electionmaster.in/public/api/lead-meetings-list',
//         queryParameters: {
//           'lead_id': leadId.toString(),
//         },
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//           },
//         ),
//       );

//       print("Response status: ${response.statusCode}");
//       print("Response data: ${response.data}");

//       if (response.statusCode == 200) {
//         final parsed = GetLeadListModule.fromJson(response.data);
//         meetingList.assignAll(parsed.data!);
//         for (int i = 0; i < meetingList.length; i++) {
//           if (visitid == meetingList[i].id) {
//             if (meetingList[i].status.toString() == "3") {
//               Get.to(() =>
//                   MeetingScreens(leadId: leadId, contactList: leadContactData));
//             }
//           }
//         }
//       } else {
//         Get.snackbar('Error', 'Server error: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       print("Dio Error: ${e.response?.statusCode} ${e.response?.data}");
//       Get.snackbar('Dio Error', e.message.toString());
//     } catch (e) {
//       print("Other Exception: $e");
//       Get.snackbar('Error', 'Unexpected error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateMeetingMom({
//     required int id,
//     required String meetingMom,
//     required int status,
//   }) async {
//     final Dio dio = Dio();

//     try {
//       final token = await StorageHelper.getToken();

//       final response = await dio.post(ApiConstant.baseUrl + ApiConstant.lead_meetings_list
//         'https://taskmaster.electionmaster.in/public/api/change-lead-meetings-status',
//         data: {
//           "id": id.toString(),
//           "meeting_mom": meetingMom,
//           "status": status.toString(),
//         },
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Meeting updated successfully");
//       } else {
//         Get.snackbar("Failed", "Status: ${response.statusCode}");
//       }
//     } on DioException catch (e) {
//       print("Dio Error: ${e.response?.data}");
//       Get.snackbar("Dio Error", e.message.toString());
//     } catch (e) {
//       Get.snackbar("Error", "Unexpected error: $e");
//     }
//   }
// }
