import 'dart:developer';

import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class CitiesService {
  final DioClient _dioClient = DioClient();

  Future<List<CityModel>> getCities() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getCities);

      final apiResponse = ApiResponse.fromJson(response.data, (data) {
        final List list = (data['cities'] as List?) ?? <dynamic>[];
        return list
            .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<CityModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'cities service AppException getCities : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('cities service DioException getCities : ${e.message}');
      throw Exception(e.message);
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
      final response = await _dioClient.post(
        ApiEndpoint.createCity,
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create city');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'cities service AppException createCity : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('cities service DioException createCity : ${e.message}');
      throw Exception(e.message);
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
      final response = await _dioClient.put(
        ApiEndpoint.updateCity(id),
        data: {'title': title, 'ar_title': arTitle},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update city');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'cities service AppException updateCity : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('cities service DioException updateCity : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('cities service catch updateCity : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCity(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteCity(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete city');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'cities service AppException deleteCity : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('cities service DioException deleteCity : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('cities service catch deleteCity : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
