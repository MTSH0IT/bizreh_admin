import 'dart:developer';

import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/category/models/category_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart'; // Still needed for MultipartFile/FormData for now, unless we abstract it further

class CategoryService {
  final IApiClient _apiClient;

  CategoryService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<AllCategoryModel>> getAllCategories() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getAllCategories);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['sub_categories'] as List?) ?? <dynamic>[];
        return list
            .map((e) => AllCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<AllCategoryModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('category service catch getAllCategories : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<CategoryModel>> getCategories(int superCategoryId) async {
    try {
      final data = await _apiClient.get(
        ApiEndpoint.getCategories(superCategoryId),
      );

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final categoriesWrapper = json['categories'];
        final List list =
            (categoriesWrapper?['categories'] as List?) ?? <dynamic>[];
        return list
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<CategoryModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('category service catch getCategories : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createCategory({
    required String title,
    required String arTitle,
    required String position,
    required int superCategoryId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'super_category_id': superCategoryId,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.post(
        ApiEndpoint.createCategory,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('category service catch createCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateCategory({
    required int id,
    required String title,
    required String arTitle,
    required String position,
    required int superCategoryId,
    String? imagePath,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'super_category_id': superCategoryId,
      };

      if (imagePath != null) {
        map['image'] = await MultipartFile.fromFile(imagePath);
      }

      final formData = FormData.fromMap(map);

      final data = await _apiClient.put(
        ApiEndpoint.updateCategory(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('category service catch updateCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteCategory(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete category');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('category service catch deleteCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
