import 'dart:developer';

import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class OffersCartService {
  final DioClient _dioClient = DioClient();

  Future<List<OffersCartModel>> getOffersCart() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getOffersCart);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => OffersCartModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<OffersCartModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'offers cart service AppException getOffersCart : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('offers cart service DioException getOffersCart : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('offers cart service catch getOffersCart : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createOffer({required Map<String, dynamic> body}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoint.createOffersCart,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'offers cart service AppException createOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('offers cart service DioException createOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('offers cart service catch createOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateOffer({required int id, required Map<String, dynamic> body}) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoint.updateOffersCart(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'offers cart service AppException updateOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('offers cart service DioException updateOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('offers cart service catch updateOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteOffer(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteOffersCart(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete offer');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'offers cart service AppException deleteOffer : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('offers cart service DioException deleteOffer : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('offers cart service catch deleteOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> toggleOfferStatus(int id) async {
    try {
      final response = await _dioClient.patch(ApiEndpoint.toggleOffersCart(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to toggle offer status');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'offers cart service AppException toggleOfferStatus : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('offers cart service DioException toggleOfferStatus : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('offers cart service catch toggleOfferStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
