import 'dart:developer';

import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class CitiesService {
  final IApiClient _apiClient;

  CitiesService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CityModel>> getCities() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getCities);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['cities'] as List?) ?? <dynamic>[];
        return list
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<CityModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('cities service catch getCities : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createCity({
    required String title,
    required String arTitle,
  }) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.createCity,
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create city');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('cities service catch createCity : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateCity({
    required int id,
    required String title,
    required String arTitle,
  }) async {
    try {
      final data = await _apiClient.put(
        ApiEndpoint.updateCity(id),
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update city');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('cities service catch updateCity : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCity(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteCity(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete city');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('cities service catch deleteCity : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
