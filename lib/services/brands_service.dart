import 'dart:developer';

import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class BrandsService {
  final IApiClient _apiClient;

  BrandsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<BrandsModel>> getBrands() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getBrands);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['brands'] as List?) ?? [];
        return list
            .map((e) => BrandsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<BrandsModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("brands service catch featured brands : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> createBrand({
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
        ApiEndpoint.createBrand,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (apiResponse.success) {
        log("${apiResponse.message}");
      } else {
        throw Exception(apiResponse.message ?? 'Failed to create brand');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("brands service catch createBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateBrand({
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
        ApiEndpoint.updateBrand(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update brand');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("brands service catch updateBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBrand(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteBrand(id));

      final apiResponse = ApiResponse.fromJson(data, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete brand');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("brands service catch deleteBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
