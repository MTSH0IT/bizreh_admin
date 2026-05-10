import 'dart:developer';

import 'package:bizreh_admin/features/profile/models/profile_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ProfileService {
  final IApiClient _apiClient;

  ProfileService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<ProfileModel> getProfile() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getProfile);

      final apiResponse = ApiResponse<ProfileModel>.fromJson(data, (
        json,
      ) {
        final data = (json as Map<String, dynamic>);
        final user =
            (data['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        return ProfileModel.fromJson(user);
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      }

      throw UnknownException(
        message: apiResponse.message ?? 'Failed to load profile',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      log('profile service catch getProfile : ${e.toString()}');
      throw UnknownException(message: 'Failed to load profile');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final responseData = await _apiClient.patch(
        ApiEndpoint.changePassword,
        data: {
          "current_password": currentPassword,
          "new_password": newPassword,
        },
      );
      final apiResponse = ApiResponse.fromJson(responseData, null);
      if (apiResponse.success) {
        log("user service change password : ${apiResponse.message}");
        return;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
