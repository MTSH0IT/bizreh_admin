import 'dart:developer';

import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class SuppliersService {
  final DioClient _dioClient = DioClient();

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getSuppliers);

      final apiResponse = ApiResponse.fromJson(response.data, (data) {
        final List list = (data['suppliers'] as List?) ?? <dynamic>[];
        return list
            .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<SupplierModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'suppliers service AppException getSuppliers : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('suppliers service DioException getSuppliers : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('suppliers service catch getSuppliers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createSupplier({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required int cityId,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'email': email,
        'phone': phone,
        'city_id': cityId,
      };

      final response = await _dioClient.post(
        ApiEndpoint.createSupplier,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create supplier');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'suppliers service AppException createSupplier : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('suppliers service DioException createSupplier : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('suppliers service catch createSupplier : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateSupplier({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
      };

      final response = await _dioClient.put(
        ApiEndpoint.updateSupplier(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update supplier');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'suppliers service AppException updateSupplier : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('suppliers service DioException updateSupplier : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('suppliers service catch updateSupplier : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteSupplier(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete supplier');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'suppliers service AppException deleteSupplier : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('suppliers service DioException deleteSupplier : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('suppliers service catch deleteSupplier : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
