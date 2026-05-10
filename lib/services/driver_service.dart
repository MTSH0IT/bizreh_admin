import 'dart:developer';

import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class DriverService {
  final IApiClient _apiClient;

  DriverService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<DriverModel>> getDrivers() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getDrivers);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['drivers'] as List?) ?? <dynamic>[];
        return list
            .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<DriverModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('driver service catch getDrivers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createDriver({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String vehicleNumber,
    required String licenseNumber,
    required int supplierId,
    required int isActive,
  }) async {
    try {
      final body = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'vehicle_number': vehicleNumber,
        'license_number': licenseNumber,
        'supplier_id': supplierId,
        'is_active': isActive,
      };

      final data = await _apiClient.post(
        ApiEndpoint.createDriver,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create driver');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('driver service catch createDriver : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> changeDriverStatus({
    required int id,
    required int isActive,
  }) async {
    try {
      final body = {'is_active': isActive};

      final data = await _apiClient.patch(
        ApiEndpoint.changeDriverStatus(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to change driver status',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('driver service catch changeDriverStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteDriver(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteDriver(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete driver');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('driver service catch deleteDriver : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
