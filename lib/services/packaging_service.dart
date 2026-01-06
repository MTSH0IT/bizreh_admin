import 'dart:developer';

import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class PackagingService {
  final DioClient _dioClient = DioClient();

  Future<List<PackageModel>> getPackagings() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getPackagings);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PackageModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'packaging service AppException getPackagings : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('packaging service DioException getPackagings : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('packaging service catch getPackagings : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createPackaging({
    required String title,
    required String arTitle,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createPackaging,
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create packaging');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'packaging service AppException createPackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('packaging service DioException createPackaging : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('packaging service catch createPackaging : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updatePackaging({
    required int id,
    required String title,
    required String arTitle,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoint.updatePackaging(id),
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update packaging');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'packaging service AppException updatePackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('packaging service DioException updatePackaging : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('packaging service catch updatePackaging : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePackaging(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deletePackaging(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete packaging');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'packaging service AppException deletePackaging : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('packaging service DioException deletePackaging : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('packaging service catch deletePackaging : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
