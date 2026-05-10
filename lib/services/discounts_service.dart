import 'dart:developer';

import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class DiscountsService {
  final IApiClient _apiClient;

  DiscountsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<DiscountModel>> getDiscounts() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getDiscounts);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => DiscountModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<DiscountModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('discounts service catch getDiscounts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createDiscount({required Map<String, dynamic> body}) async {
    log('discounts service createDiscount : $body');
    try {
      final data = await _apiClient.post(
        ApiEndpoint.createDiscount,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create discount');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('discounts service catch createDiscount : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateDiscount({
    required int id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final data = await _apiClient.put(
        ApiEndpoint.updateDiscount(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update discount');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('discounts service catch updateDiscount : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteDiscount(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteDiscount(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete discount');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('discounts service catch deleteDiscount : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
