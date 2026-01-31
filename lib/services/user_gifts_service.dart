import 'dart:developer';

import 'package:bizreh_admin/features/gifts/models/user_gifts_model/user_gifts_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class UserGiftsService {
  final DioClient _dioClient = DioClient();

  Future<List<UserGiftsModel>> getUserGifts({String? status}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getUserGifts,
        queryParameters: status != null && status.isNotEmpty
            ? <String, dynamic>{'status': status}
            : null,
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json['gifts'] as List?) ?? <dynamic>[];
        return list
            .map((e) => UserGiftsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserGiftsModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'user gifts service AppException getUserGifts : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('user gifts service DioException getUserGifts : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.put(
        ApiEndpoint.changeUserGiftStatus(userGiftId),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to change user gift status');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'user gifts service AppException changeUserGiftStatus : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('user gifts service DioException changeUserGiftStatus : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('user gifts service catch changeUserGiftStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
