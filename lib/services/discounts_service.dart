import 'dart:developer';

import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class DiscountsService {
  final DioClient _dioClient = DioClient();

  Future<List<DiscountModel>> getDiscounts() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getDiscounts);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => DiscountModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<DiscountModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'discounts service AppException getDiscounts : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('discounts service DioException getDiscounts : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('discounts service catch getDiscounts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createDiscount({required Map<String, dynamic> body}) async {
    log('discounts service createDiscount : $body');
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createDiscount,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create discount');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'discounts service AppException createDiscount : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('discounts service DioException createDiscount : ${e.message}');
      throw Exception(e.message);
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
      final response = await _dioClient.put(
        ApiEndpoint.updateDiscount(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update discount');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'discounts service AppException updateDiscount : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('discounts service DioException updateDiscount : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('discounts service catch updateDiscount : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteDiscount(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteDiscount(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete discount');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'discounts service AppException deleteDiscount : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('discounts service DioException deleteDiscount : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('discounts service catch deleteDiscount : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
