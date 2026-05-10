import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class NotificationService {
  final IApiClient _apiClient;

  NotificationService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<void> sendToUser({
    required int userId,
    required String title,
    required String message,
  }) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.sendNotification,
        data: {'user_id': userId, 'title': title, 'message': message},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to send notification');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('notification service catch sendToUser : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> sendToAllUsers({
    required String title,
    required String message,
  }) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.sendNotificationAll,
        data: {'user_type': 'user', 'title': title, 'message': message},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to send notification to all users',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('notification service catch sendToAllUsers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
