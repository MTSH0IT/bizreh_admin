import 'dart:developer';

import 'package:bizreh_admin/features/gifts/models/user_gifts_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class UserGiftsService {
  final IApiClient _apiClient;

  UserGiftsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<UserGiftsModel>> getUserGifts({String? status}) async {
    final trimmed = status?.trim();
    final query = (trimmed == null || trimmed.isEmpty || trimmed == 'all')
        ? null
        : <String, dynamic>{'status': trimmed};

    try {
      final data = await _apiClient.get(
        ApiEndpoint.getUserGifts,
        queryParameters: query,
      );

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => UserGiftsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserGiftsModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('user gifts service catch getUserGifts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> changeUserGiftStatus({
    required int userGiftId,
    required String status,
  }) async {
    try {
      final body = <String, dynamic>{'status': status};

      final responseData = await _apiClient.put(
        ApiEndpoint.changeUserGiftStatus(userGiftId),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        responseData,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to change user gift status',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('user gifts service catch changeUserGiftStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
