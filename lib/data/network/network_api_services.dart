import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task_management/data/app_exception.dart';
import 'package:task_management/data/network/base_api_services.dart';
import 'package:task_management/helper/storage_helper.dart';

class NetworkApiServices extends BaseApiServices {
  Dio dio = Dio();
  @override
  Future<dynamic> getGetApiResponse(String url) async {
    try {
      Response response = await dio.get(url);
      return response.data;
    } on SocketException {
      return InternetException(
        message: 'No Internet Connection',
      );
    } on HttpException {
      return ServerException(
        message: 'Server Error',
      );
    } on RequestTimeoutException {
      return RequestTimeoutException(
        message: 'Request Timeout',
      );
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Future getPostApiResponse(String url, data) {
    throw UnimplementedError();
  }

  @override
  Future getMultipartPostApiResponse(String url, formData) async {
    try {
      dio.options.headers["Authorization"] =
          "Bearer ${StorageHelper.getToken()}";
      dio.options.contentType = 'multipart/form-data';

      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ));

      final response = await dio.post(url, data: formData);
      return returnResponse(response);
    } on SocketException {
      throw InternetException(message: 'No Internet Connection');
    } on TimeoutException {
      throw RequestTimeoutException(message: 'Request Timeout');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server Error');
    } catch (e) {
      throw AppException(message: 'Unexpected error: $e');
    }
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(
          message: 'Bad Request',
          code: response.statusCode,
        );
      case 401:
        throw UnauthorizedException(
          message: 'Unauthorized',
          code: response.statusCode,
        );
      case 404:
        throw NotFoundException(
          message: 'Not Found',
          code: response.statusCode,
        );
      default:
        throw AppException(
          message: 'Something went wrong',
          code: response.statusCode,
        );
    }
  }
}
