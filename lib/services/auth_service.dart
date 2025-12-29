import 'dart:developer';

import 'package:bizreh_admin/features/auth/models/auth_response.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final DioClient _dioClient = DioClient();
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.login,
        data: {"email": email, "password": password},
      );
      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        response.data,
        (json) => AuthResponse.fromJson(json),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "auth service AppException sign in : ${err.message}"
          "${err.statusCode}",
        );
        throw err;
      }
      log("auth service DioException sign in : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("auth service catch sign in : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
