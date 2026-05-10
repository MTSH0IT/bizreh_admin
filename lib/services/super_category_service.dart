import 'dart:developer';

import 'package:bizreh_admin/features/super_category/models/super_category_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class SuperCategoryService {
  final IApiClient _apiClient;

  SuperCategoryService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<SuperCategoryModel>> getSuperCategories() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getSuperCategories);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['super_categories'] as List?) ?? [];
        return list
            .map((e) => SuperCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<SuperCategoryModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("super category service catch getSuperCategories : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> createSuperCategory({
    required String title,
    required String arTitle,
    required String position,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.post(
        ApiEndpoint.createSuperCategory,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (apiResponse.success) {
        log("${apiResponse.message}");
      } else {
        throw Exception(
          apiResponse.message ?? 'Failed to create super category',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("super category service catch createSuperCategory : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateSuperCategory({
    required int id,
    required String title,
    required String arTitle,
    required String position,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.put(
        ApiEndpoint.updateSuperCategory(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update super category',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("super category service catch updateSuperCategory : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSuperCategory(int id) async {
    try {
      final data = await _apiClient.delete(
        ApiEndpoint.deleteSuperCategory(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete super category',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("super category service catch deleteSuperCategory : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
