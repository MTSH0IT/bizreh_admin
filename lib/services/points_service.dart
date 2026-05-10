import 'dart:developer';

import 'package:bizreh_admin/features/points/models/point_model.dart';
import 'package:bizreh_admin/features/points/models/user_point_history/user_point_history.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class PointsService {
  final IApiClient _apiClient;

  PointsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<PointModel>> getPointsOffers() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getPointsOffers);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => PointModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PointModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('points service catch getPointsOffers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createPointsOffer({required Map<String, dynamic> body}) async {
    try {
      final responseData = await _apiClient.post(
        ApiEndpoint.createPointsOffer,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create points offer');
      }
    } on AppException {
      rethrow;
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
      final responseData = await _apiClient.put(
        ApiEndpoint.updatePointsOffer(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update points offer');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('points service catch updatePointsOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePointsOffer(int id) async {
    try {
      final responseData = await _apiClient.delete(
        ApiEndpoint.deletePointsOffer(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete points offer');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('points service catch deletePointsOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<UserPointHistory> getUserPointsHistory(int userId) async {
    try {
      final data = await _apiClient.get(
        ApiEndpoint.getUserPointsHistory(userId),
      );

      final apiResponse = ApiResponse.fromJson(
        data,
        (json) => UserPointHistory.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserPointHistory;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('points service catch getUserPointsHistory : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
