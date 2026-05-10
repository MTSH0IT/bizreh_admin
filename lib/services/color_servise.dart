import 'dart:developer';

import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ColorService {
  final IApiClient _apiClient;

  ColorService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ColorModel>> getColorFamilies() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getColorFamily);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['products'] as List?) ?? <dynamic>[];
        return list
            .map((e) => ColorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ColorModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('color service catch getColorFamilies : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createColorFamily({
    required String name,
    required String arName,
    required String colorDegree,
  }) async {
    try {
      final body = {
        'name': name,
        'ar_name': arName,
        'color_degree': colorDegree,
      };

      final data = await _apiClient.post(
        ApiEndpoint.createColerFamily,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create color');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('color service catch createColorFamily : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateColorFamily({
    required int id,
    required String name,
    required String arName,
    required String colorDegree,
  }) async {
    try {
      final body = {
        'name': name,
        'ar_name': arName,
        'color_degree': colorDegree,
      };

      final data = await _apiClient.put(
        ApiEndpoint.updateColorFamily(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update color');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('color service catch updateColorFamily : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteColorFamily(int id) async {
    try {
      final data = await _apiClient.delete(
        ApiEndpoint.deleteColerFamily(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete color');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('color service catch deleteColorFamily : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
