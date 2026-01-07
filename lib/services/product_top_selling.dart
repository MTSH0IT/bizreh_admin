import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ProductTopSellingService {
  final DioClient _dioClient = DioClient();

  Future<List<ProductModel>> getTopSellingProducts() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getTopSellingProducts);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        // "data" في الـApiResponse تحتوي على كائن به "products": [...]
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'top selling service AppException getTopSellingProducts : '
          '${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'top selling service DioException getTopSellingProducts : '
        '${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log('top selling service catch getTopSellingProducts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> addTopSellingProduct({required int productId}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createTopSellingProduct,
        data: {'product_id': productId},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to add top selling');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'top selling service AppException addTopSellingProduct : '
          '${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'top selling service DioException addTopSellingProduct : '
        '${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log('top selling service catch addTopSellingProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTopSellingProduct(int productId) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteTopSellingProduct(productId),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete top selling');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'top selling service AppException deleteTopSellingProduct : '
          '${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'top selling service DioException deleteTopSellingProduct : '
        '${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log(
        'top selling service catch deleteTopSellingProduct : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
