import 'dart:developer';

import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ColorService {
  final DioClient _dioClient = DioClient();

  Future<List<ColorModel>> getColorFamilies() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getColorFamily);

      final apiResponse = ApiResponse.fromJson(response.data, (data) {
        final List list = (data['products'] as List?) ?? <dynamic>[];
        return list
            .map((e) => ColorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ColorModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'color service AppException getColorFamilies : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('color service DioException getColorFamilies : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.createColerFamily,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create color');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'color service AppException createColorFamily : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('color service DioException createColorFamily : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.put(
        ApiEndpoint.updateColorFamily(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update color');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'color service AppException updateColorFamily : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('color service DioException updateColorFamily : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('color service catch updateColorFamily : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteColorFamily(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deleteColerFamily(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete color');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'color service AppException deleteColorFamily : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('color service DioException deleteColorFamily : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('color service catch deleteColorFamily : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
