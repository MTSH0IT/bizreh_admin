import 'dart:developer';

import 'package:bizreh_admin/features/gifts/models/gifts_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class GiftsService {
  final IApiClient _apiClient;

  GiftsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<GiftsModel>> getGifts() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getGifts);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? [];
        return list
            .map((e) => GiftsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<GiftsModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("gifts service catch getGifts : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> createGift({
    required int points,
    required String title,
    required String arTitle,
    required String imagePath,
    required int isActive,
  }) async {
    try {
      final formData = FormData.fromMap({
        'points': points,
        'title': title,
        'ar_title': arTitle,
        'image': await MultipartFile.fromFile(imagePath),
        'is_active': isActive,
      });

      final data = await _apiClient.post(
        ApiEndpoint.createGift,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, (j) => j);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create gift');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("gifts service catch createGift : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateGift({
    required int id,
    required int points,
    required String title,
    required String arTitle,
    String? imagePath,
    required int isActive,
  }) async {
    try {
      final formData = FormData.fromMap({
        'points': points,
        'title': title,
        'ar_title': arTitle,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
        'is_active': isActive,
      });

      final data = await _apiClient.put(
        ApiEndpoint.updateGift(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, (j) => j);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update gift');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("gifts service catch updateGift : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteGift(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteGift(id));

      final apiResponse = ApiResponse.fromJson(data, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete gift');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("gifts service catch deleteGift : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
