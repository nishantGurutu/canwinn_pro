// import 'package:dio/dio.dart';
// import 'package:task_management/api/api_constant.dart';
// import 'package:task_management/constant/custom_toast.dart';
// import 'package:task_management/helper/db_helper.dart';
// import 'package:task_management/helper/storage_helper.dart';

// class LocationTrackingService {
//   final Dio _dio = Dio();
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;

//   Future<bool> syncLocationsToApi() async {
//     try {
//       List<Map<String, dynamic>> unsyncedLocations =
//           await _dbHelper.getUnsyncedLocations();

//       if (unsyncedLocations.isEmpty) {
//         print('No unsynced locations to sync.');
//         CustomToast().showCustomToast('No unsynced locations to sync. in api');
//         return true;
//       }

//       print('Unsynced locations to sync: $unsyncedLocations');

//       List<Map<String, dynamic>> locationsToSync =
//           unsyncedLocations.map((location) {
//         return {
//           "latitude": double.tryParse(location['latitude'].toString()) ?? 0.0,
//           "longitude": double.tryParse(location['longitude'].toString()) ?? 0.0,
//           "captured_at": location['timestamp'].toString(),
//         };
//       }).toList();

//       var userId = StorageHelper.getId();

//       final response = await _dio.post(
//         ApiConstant.baseUrl + ApiConstant.save_user_locations_json,
//         data: {
//           "user_id": 98,
//           "locations": locationsToSync,
//         },
//         options: Options(
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//           followRedirects: false,
//           validateStatus: (status) => status! < 500,
//         ),
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response data: ${response.data}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         List<int> locationIds = unsyncedLocations
//             .map((location) => int.parse(location['id'].toString()))
//             .toList();

//         print('Successfully synced ${locationIds.length} locations to API.');
//         // CustomToast().showCustomToast('Locations synced successfully.');
//         return true;
//       } else {
//         // CustomToast().showCustomToast(
//         //   response.data['message'] ?? 'Failed to sync locations.',
//         // );
//         return false;
//       }
//     } catch (e) {
//       print('Error syncing locations to API: $e');
//       // CustomToast().showCustomToast('Failed to sync locations: $e');
//       return false;
//     }
//   }
// }
