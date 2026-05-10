import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ProductTopSellingService {
  final IApiClient _apiClient;

  ProductTopSellingService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ProductModel>> getTopSellingProducts() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getTopSellingProducts);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['products'] as List?) ?? <dynamic>[];
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ProductModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to load top selling');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('top selling service catch getTopSellingProducts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> addTopSellingProduct({required int productId}) async {
    try {
      final responseData = await _apiClient.post(
        ApiEndpoint.createTopSellingProduct,
        data: {'product_id': productId},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to add top selling');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('top selling service catch addTopSellingProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTopSellingProduct(int productId) async {
    try {
      final responseData = await _apiClient.delete(
        ApiEndpoint.deleteTopSellingProduct(productId),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete top selling');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'top selling service catch deleteTopSellingProduct : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
