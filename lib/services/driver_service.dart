import 'dart:developer';

import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class DriverService {
  final DioClient _dioClient = DioClient();

  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getDrivers);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'driver service AppException getDrivers : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('driver service DioException getDrivers : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.createDriver,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create driver');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'driver service AppException createDriver : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('driver service DioException createDriver : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.patch(
        ApiEndpoint.changeDriverStatus(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to change driver status',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'driver service AppException changeDriverStatus : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('driver service DioException changeDriverStatus : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('driver service catch changeDriverStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteDriver(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteDriver(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete driver');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'driver service AppException deleteDriver : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('driver service DioException deleteDriver : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('driver service catch deleteDriver : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
