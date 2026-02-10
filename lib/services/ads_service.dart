import 'dart:developer';

import 'package:bizreh_admin/features/ads/models/ads_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class AdsService {
  final DioClient _dioClient = DioClient();

  Future<List<AdsModel>> getAds() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getAds);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<AdsModel>;
      }
      throw Exception(apiResponse.message ?? 'Failed to load ads');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'ads service AppException getAds : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('ads service DioException getAds : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('ads service catch getAds : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createAd({
    required String imagePath,
    //required int productId,
    required String title,
    required String arTitle,
    required String description,
    required String arDescription,
    required int isActive,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
        //'product_id': productId,
        'title': title,
        'ar_title': arTitle,
        'description': description,
        'ar_description': arDescription,
        'is_active': isActive,
      });

      final response = await _dioClient.post(
        ApiEndpoint.createAd,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create ad');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'ads service AppException createAd : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('ads service DioException createAd : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('ads service catch createAd : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateAd({
    required int id,
    String? imagePath,
    // required int productId,
    required String title,
    required String arTitle,
    required String description,
    required String arDescription,
    required int isActive,
  }) async {
    try {
      final map = <String, dynamic>{
        //'product_id': productId,
        'title': title,
        'ar_title': arTitle,
        'description': description,
        'ar_description': arDescription,
        'is_active': isActive,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final response = await _dioClient.put(
        ApiEndpoint.updateAd(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update ad');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'ads service AppException updateAd : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('ads service DioException updateAd : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('ads service catch updateAd : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteAd(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete ad');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'ads service AppException deleteAd : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('ads service DioException deleteAd : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('ads service catch deleteAd : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> changeAdStatus({required int id, required int isActive}) async {
    try {
      final body = {'is_active': isActive};

      final response = await _dioClient.patch(
        ApiEndpoint.changeAdStatus(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to change ad status');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'ads service AppException changeAdStatus : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('ads service DioException changeAdStatus : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('ads service catch changeAdStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
