import 'dart:developer';

import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class ProfileService {
  final DioClient _dioClient = DioClient();

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getProfile);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json["users"][0] as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw UnknownException(
          message: apiResponse.message ?? 'Failed to load profile',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('Error in getProfile: $e');
      throw UnknownException(message: 'Failed to load profile');
    }
  }
}
