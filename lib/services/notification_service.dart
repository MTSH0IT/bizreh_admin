import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final DioClient _dioClient = DioClient();

  Future<void> sendToUser({
    required int userId,
    required String title,
    required String message,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.sendNotification,
        data: {'user_id': userId, 'title': title, 'message': message},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to send notification');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'notification service AppException sendToUser : '
          '${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('notification service DioException sendToUser : ${e.message}');
      throw Exception(e.message);
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
      final response = await _dioClient.post(
        ApiEndpoint.sendNotificationAll,
        data: {'user_type': 'user', 'title': title, 'message': message},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to send notification to all users',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'notification service AppException sendToAllUsers : '
          '${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('notification service DioException sendToAllUsers : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('notification service catch sendToAllUsers : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
