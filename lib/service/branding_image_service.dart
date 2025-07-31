import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/brand_image_model.dart';

class BrandingImageService {
  final Dio _dio = Dio();
  Future<BrandImagemodel?> overlayImageList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.overlay_images,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BrandImagemodel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }
}
