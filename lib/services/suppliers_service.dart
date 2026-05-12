import 'dart:developer';

import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class SuppliersService {
  final IApiClient _apiClient;

  SuppliersService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getSuppliers);

      final apiResponse = ApiResponse.fromJson(data, (data) {
        final List list = (data['suppliers'] as List?) ?? <dynamic>[];
        return list
            .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<SupplierModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
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
    required int isActive,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'email': email,
        'phone': phone,
        'city_id': cityId,
        'is_active': isActive,
      };

      final responseData = await _apiClient.post(
        ApiEndpoint.createSupplier,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create supplier');
      }
    } on AppException {
      rethrow;
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
    required int cityId,
    required int isActive,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'city_id': cityId,
        'is_active': isActive,
      };

      final responseData = await _apiClient.put(
        ApiEndpoint.updateSupplier(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update supplier');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('suppliers service catch updateSupplier : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      final responseData = await _apiClient.delete(
        ApiEndpoint.deleteSupplier(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete supplier');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('suppliers service catch deleteSupplier : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
