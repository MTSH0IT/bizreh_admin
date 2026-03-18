import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ProductsOptionService {
  final DioClient _dioClient = DioClient();

  Future<void> createProductOption({
    required String optionName,
    required String arOptionName,
    required int productId,
    String? mainImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'option_name': optionName,
        'ar_option_name': arOptionName,
        'product_id': productId,
        if (mainImagePath != null)
          'main_image': await MultipartFile.fromFile(mainImagePath),
      });

      final response = await _dioClient.post(
        ApiEndpoint.createProductOption,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create product option',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "product option service AppException createProductOption : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "product option service DioException createProductOption : ${e.message}",
      );
      throw Exception(e.message);
    } catch (e) {
      log("product option service catch createProductOption : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateProductOption({
    required int id,
    required String optionName,
    required String arOptionName,
    required int productId,
    String? mainImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'option_name': optionName,
        'ar_option_name': arOptionName,
        'product_id': productId,
        if (mainImagePath != null)
          'main_image': await MultipartFile.fromFile(mainImagePath),
      });

      final response = await _dioClient.put(
        ApiEndpoint.updateProductOption(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update product option',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "product option service AppException updateProductOption : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "product option service DioException updateProductOption : ${e.message}",
      );
      throw Exception(e.message);
    } catch (e) {
      log("product option service catch updateProductOption : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteProductOption(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteProductOption(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete product option',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "product option service AppException deleteProductOption : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "product option service DioException deleteProductOption : ${e.message}",
      );
      throw Exception(e.message);
    } catch (e) {
      log("product option service catch deleteProductOption : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
