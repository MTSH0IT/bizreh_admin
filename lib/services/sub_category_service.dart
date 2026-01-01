import 'dart:developer';

import 'package:bizreh_admin/features/subCategory/models/sub_category_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class SubCategoryService {
  final DioClient _dioClient = DioClient();

  Future<List<SubCategoryModel>> getSubCategories(int categoryId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getSubCategories(categoryId),
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'subCategory service AppException getSubCategories : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('subCategory service DioException getSubCategories : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.createSubCategory,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create sub category');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'subCategory service AppException createSubCategory : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('subCategory service DioException createSubCategory : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.put(
        ApiEndpoint.updateSubCategory(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update sub category');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'subCategory service AppException updateSubCategory : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('subCategory service DioException updateSubCategory : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('subCategory service catch updateSubCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSubCategory(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteSubCategory(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete sub category');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'subCategory service AppException deleteSubCategory : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('subCategory service DioException deleteSubCategory : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('subCategory service catch deleteSubCategory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
