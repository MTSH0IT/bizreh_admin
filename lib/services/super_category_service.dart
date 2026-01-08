import 'dart:developer';
import 'package:bizreh_admin/features/super_category/models/super_category_model.dart';
import 'package:dio/dio.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class SuperCategoryService {
  final DioClient _dioClient = DioClient();

  Future<List<SuperCategoryModel>> getSuperCategories() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getSuperCategories);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "super category service AppException getSuperCategories : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "super category service DioException getSuperCategories : ${e.message}",
      );
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.createSuperCategory,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (apiResponse.success) {
        log("${apiResponse.message}");
      } else {
        throw Exception(
          apiResponse.message ?? 'Failed to create super category',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "super category service AppException createSuperCategory : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "super category service DioException createSuperCategory : ${e.message}",
      );
      throw Exception(e.message);
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

      final response = await _dioClient.put(
        ApiEndpoint.updateSuperCategory(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to update super category',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "super category service AppException updateSuperCategory : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "super category service DioException updateSuperCategory : ${e.message}",
      );
      throw Exception(e.message);
    } catch (e) {
      log("super category service catch updateSuperCategory : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSuperCategory(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteSuperCategory(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to delete super category',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "super category service AppException deleteSuperCategory : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log(
        "super category service DioException deleteSuperCategory : ${e.message}",
      );
      throw Exception(e.message);
    } catch (e) {
      log("super category service catch deleteSuperCategory : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
