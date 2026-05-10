import 'dart:developer';

import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model/offers_cart_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class OffersCartService {
  final IApiClient _apiClient;

  OffersCartService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<OffersCartModel>> getOffersCart() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getOffersCart);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => OffersCartModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<OffersCartModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('offers cart service catch getOffersCart : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createOffer({required Map<String, dynamic> body}) async {
    try {
      final data = await _apiClient.post(
        ApiEndpoint.createOffersCart,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create offer');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('offers cart service catch createOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateOffer({
    required int id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final data = await _apiClient.put(
        ApiEndpoint.updateOffersCart(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update offer');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('offers cart service catch updateOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteOffer(int id) async {
    try {
      final data = await _apiClient.delete(
        ApiEndpoint.deleteOffersCart(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete offer');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('offers cart service catch deleteOffer : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> toggleOfferStatus({
    required int id,
    required int isActive,
  }) async {
    try {
      final body = {'is_active': isActive};

      final data = await _apiClient.patch(
        ApiEndpoint.toggleOffersCart(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to toggle offer status');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('offers cart service catch toggleOfferStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
