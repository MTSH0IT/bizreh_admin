import 'dart:developer';

import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class PackagingService {
  final IApiClient _apiClient;

  PackagingService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<PackageModel>> getPackagings() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getPackagings);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PackageModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
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
      final data = await _apiClient.post(
        ApiEndpoint.createPackaging,
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create packaging');
      }
    } on AppException {
      rethrow;
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
      final data = await _apiClient.put(
        ApiEndpoint.updatePackaging(id),
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update packaging');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('packaging service catch updatePackaging : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePackaging(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deletePackaging(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete packaging');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('packaging service catch deletePackaging : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
