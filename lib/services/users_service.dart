import 'dart:developer';

import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class UsersService {
  final DioClient _dioClient = DioClient();

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getUsers);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "users service AppException getUsers : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("users service DioException getUsers : ${e.message}");
      throw Exception(e.message);
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
      final response = await _dioClient.post(
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
        response.data,
        (json) => UserModel.fromJson(json),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to create user');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "users service AppException createUser : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("users service DioException createUser : ${e.message}");
      throw Exception(e.message);
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
      final response = await _dioClient.put(
        ApiEndpoint.updateUser(id),
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update user');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "users service AppException updateUser : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("users service DioException updateUser : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("users service catch updateUser : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteUser(id));

      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete user');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "users service AppException deleteUser : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("users service DioException deleteUser : ${e.message}");
      throw Exception(e.message);
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

      final response = await _dioClient.patch(
        ApiEndpoint.changeUserStatus(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to change user status');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "users service AppException changeUserStatus : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("users service DioException changeUserStatus : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("users service catch changeUserStatus : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
