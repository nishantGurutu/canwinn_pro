import 'package:task_management/api/api_constant.dart';
import 'package:task_management/data/model/visit_type_model.dart';
import 'package:task_management/data/network/base_api_services.dart';
import 'package:task_management/data/network/network_api_services.dart';

class VisitTypeRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<List<VisitType>> fetchVisitTypes() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        ApiConstant.baseUrl + ApiConstant.visit_type_list,
      );

      if (response['status'] == true && response['data'] != null) {
        List data = response['data'];
        return data.map((e) => VisitType.fromJson(e)).toList();
      } else {
        throw Exception("Invalid data format");
      }
    } catch (e) {
      throw Exception("Visit type fetch failed: $e");
    }
  }
}
