import 'dart:developer';

import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/features/sub_category/models/sub_category_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class SubCategoryService {
  final IApiClient _apiClient;

  SubCategoryService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<SubCategoryModel>> getSubCategories(int categoryId) async {
    try {
      final data = await _apiClient.get(
        ApiEndpoint.getSubCategories(categoryId),
      );

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['sub_categories'] as List?) ?? <dynamic>[];
        return list
            .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<SubCategoryModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('subCategory service catch getSubCategories : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createSubCategory({
    required String title,
    required String arTitle,
    required String position,
    required int categoryId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'category_id': categoryId,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.post(
        ApiEndpoint.createSubCategory,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create sub category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('subCategory service catch createSubCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateSubCategory({
    required int id,
    required String title,
    required String arTitle,
    required String position,
    required int categoryId,
    String? imagePath,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'category_id': categoryId,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final data = await _apiClient.put(
        ApiEndpoint.updateSubCategory(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update sub category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('subCategory service catch updateSubCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSubCategory(int id) async {
    try {
      final data = await _apiClient.delete(
        ApiEndpoint.deleteSubCategory(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete sub category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('subCategory service catch deleteSubCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<AllSubCategoryModel>> getAllSubCategories() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getAllSubCategory);
      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['sub_categories'] as List?) ?? <dynamic>[];
        return list
            .map((e) => AllSubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<AllSubCategoryModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('subCategory service catch getSubCategories : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
