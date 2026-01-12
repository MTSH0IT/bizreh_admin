import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class OptionPackagingService {
  final DioClient _dioClient = DioClient();

  Future<void> createOptionPackaging({
    required int productOptionId,
    required int packagingId,
    required num pricePerUnit,
    required int stockQuantity,
    required int colorId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createOptionPackaging,
        data: {
          'product_option_id': productOptionId,
          'packaging_id': packagingId,
          'price_per_unit': pricePerUnit,
          'stock_quantity': stockQuantity,
          'color_id': colorId,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create option packaging',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'option packaging service AppException createOptionPackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'option packaging service DioException createOptionPackaging : ${e.message}',
      );
      throw Exception(e.message);
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
    required int colorId,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoint.updateOptionPackaging(id),
        data: {
          'product_option_id': productOptionId,
          'packaging_id': packagingId,
          'price_per_unit': pricePerUnit,
          'stock_quantity': stockQuantity,
          'color_id': colorId,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update option packaging',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'option packaging service AppException updateOptionPackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'option packaging service DioException updateOptionPackaging : ${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log(
        'option packaging service catch updateOptionPackaging : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }

  Future<void> deleteOptionPackaging(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteOptionPackaging(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete option packaging',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'option packaging service AppException deleteOptionPackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'option packaging service DioException deleteOptionPackaging : ${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log(
        'option packaging service catch deleteOptionPackaging : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
