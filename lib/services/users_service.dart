import 'dart:developer';

import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class UsersService {
  final IApiClient _apiClient;

  UsersService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<UserModel>> getUsers() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getUsers);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['users'] as List?) ?? [];
        return list
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("users service catch getUsers : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<UserModel> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final responseData = await _apiClient.post(
        ApiEndpoint.createUser,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<UserModel>.fromJson(
        responseData,
        (json) => UserModel.fromJson(json),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to create user');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("users service catch createUser : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final responseData = await _apiClient.put(
        ApiEndpoint.updateUser(id),
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        responseData,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update user');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("users service catch updateUser : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final responseData = await _apiClient.delete(ApiEndpoint.deleteUser(id));

      final apiResponse = ApiResponse.fromJson(responseData, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete user');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("users service catch deleteUser : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> changeUserStatus({
    required int id,
    required int isActive,
  }) async {
    try {
      final body = {'is_active': isActive};

      final responseData = await _apiClient.patch(
        ApiEndpoint.changeUserStatus(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to change user status');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log("users service catch changeUserStatus : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
