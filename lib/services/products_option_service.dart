import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ProductsOptionService {
  final IApiClient _apiClient;

  ProductsOptionService({required IApiClient apiClient}) : _apiClient = apiClient;

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

      final responseData = await _apiClient.post(
        ApiEndpoint.createProductOption,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create product option',
        );
      }
    } on AppException {
      rethrow;
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

      final responseData = await _apiClient.put(
        ApiEndpoint.updateProductOption(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update product option',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("product option service catch updateProductOption : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteProductOption(int id) async {
    try {
      final responseData = await _apiClient.delete(
        ApiEndpoint.deleteProductOption(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete product option',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("product option service catch deleteProductOption : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
