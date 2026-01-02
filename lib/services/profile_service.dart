import 'dart:developer';

import 'package:bizreh_admin/features/profile/models/profile_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final DioClient _dioClient = DioClient();

  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getProfile);

      final apiResponse = ApiResponse<ProfileModel>.fromJson(response.data, (
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'profile service AppException getProfile : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('profile service DioException getProfile : ${e.message}');
      throw UnknownException(message: e.message ?? 'Failed to load profile');
    } catch (e) {
      log('profile service catch getProfile : ${e.toString()}');
      throw UnknownException(message: 'Failed to load profile');
    }
  }
}
