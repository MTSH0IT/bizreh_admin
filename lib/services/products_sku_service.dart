import 'dart:developer';

import 'package:bizreh_admin/features/products_sku/model/products_sku/products_sku.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ProductsSkuService {
  final IApiClient _apiClient;

  ProductsSkuService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ProductsSku>> getOptionPackagings() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getOptionPackagings);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        // Based on the provided API response structure:
        // json['data']['option_packagings']['option_packaging']
        final optionPackagingsWrapper =
            json['option_packigings'] as Map<String, dynamic>?;
        final List list =
            (optionPackagingsWrapper?['option_packaging'] as List?) ??
            <dynamic>[];
        return list
            .map((e) => ProductsSku.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ProductsSku>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products sku service catch getOptionPackagings : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
