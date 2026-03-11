import 'dart:developer';

import 'package:bizreh_admin/features/points/models/point_model.dart';
import 'package:bizreh_admin/features/points/models/user_point_histoy_model.dart';
import 'package:bizreh_admin/features/points/models/user_points_balance_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class PointsService {
  final DioClient _dioClient = DioClient();

  Future<List<PointModel>> getPointsOffers() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getPointsOffers);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => PointModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PointModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException getPointsOffers : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException getPointsOffers : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch getPointsOffers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createPointsOffer({required Map<String, dynamic> body}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createPointsOffer,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create points offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException createPointsOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException createPointsOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch createPointsOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updatePointsOffer({
    required int id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoint.updatePointsOffer(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update points offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException updatePointsOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException updatePointsOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch updatePointsOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePointsOffer(int id) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoint.deletePointsOffer(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete points offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException deletePointsOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException deletePointsOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch deletePointsOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<UserPointsBalanceModel> getUserPointsBalance(int userId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getUserPointsBalance(userId),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => UserPointsBalanceModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserPointsBalanceModel;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException getUserPointsBalance : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException getUserPointsBalance : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch getUserPointsBalance : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<UserPointHistoyModel>> getUserPointsHistory(int userId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getUserPointsHistory(userId),
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map(
              (e) => UserPointHistoyModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserPointHistoyModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'points service AppException getUserPointsHistory : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('points service DioException getUserPointsHistory : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('points service catch getUserPointsHistory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
