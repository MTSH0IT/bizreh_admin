import 'dart:developer';

import 'package:bizreh_admin/features/auth/models/auth_response.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class AuthService {
  final IApiClient _apiClient;

  AuthService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.login,
        data: {"email": email, "password": password},
      );
      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        data,
        (json) => AuthResponse.fromJson(json),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("auth service catch sign in : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.forgetPassword,
        data: {'email': email},
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to send reset email');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("auth service catch forgetPassword : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
