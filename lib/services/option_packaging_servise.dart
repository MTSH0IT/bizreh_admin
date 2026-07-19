import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class OptionPackagingService {
  final IApiClient _apiClient;

  OptionPackagingService({required IApiClient apiClient})
    : _apiClient = apiClient;

  Future<void> createOptionPackaging({
    required int productOptionId,
    required int packagingId,
    required num pricePerUnit,
    required int stockQuantity,
    required String optionSku,
    int? colorId,
  }) async {
    try {
      final data = <String, dynamic>{
        'product_option_id': productOptionId,
        'packaging_id': packagingId,
        'price_per_unit': pricePerUnit,
        'stock_quantity': stockQuantity,
        'option_sku': optionSku,
      };
      if (colorId != null) {
        data['color_id'] = colorId;
      }

      final responseData = await _apiClient.post(
        ApiEndpoint.createOptionPackaging,
        data: data,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create option packaging',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'option packaging service catch createOptionPackaging : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }

  Future<void> updateOptionPackaging({
    required int id,
    required int productOptionId,
    required int packagingId,
    required num pricePerUnit,
    required int stockQuantity,
    required String optionSku,
    int? colorId,
  }) async {
    try {
      final data = <String, dynamic>{
        'product_option_id': productOptionId,
        'packaging_id': packagingId,
        'price_per_unit': pricePerUnit,
        'stock_quantity': stockQuantity,
        'option_sku': optionSku,
      };
      if (colorId != null) {
        data['color_id'] = colorId;
      }

      final responseData = await _apiClient.put(
        ApiEndpoint.updateOptionPackaging(id),
        data: data,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update option packaging',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'option packaging service catch updateOptionPackaging : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }

  Future<void> deleteOptionPackaging(int id) async {
    try {
      final responseData = await _apiClient.delete(
        ApiEndpoint.deleteOptionPackaging(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete option packaging',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'option packaging service catch deleteOptionPackaging : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
