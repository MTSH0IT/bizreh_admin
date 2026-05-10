import 'dart:developer';

import 'package:bizreh_admin/features/orders/models/order_model/order_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class OrdersService {
  final IApiClient _apiClient;

  OrdersService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<OrderModel>> getOrders({String? status}) async {
    try {
      final trimmed = status?.trim();
      final query = (trimmed == null || trimmed.isEmpty || trimmed == 'all')
          ? null
          : <String, dynamic>{'status': trimmed};

      final data = await _apiClient.get(
        ApiEndpoint.getOrders,
        queryParameters: query,
      );

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json['orders'] as List?) ?? <dynamic>[];
        return list
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<OrderModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('orders service catch getOrders : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> assignDriver({
    required int orderId,
    required int driverId,
  }) async {
    try {
      final body = {'driver_id': driverId};

      final data = await _apiClient.post(
        ApiEndpoint.assignOrderDriver(orderId),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to assign driver');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('orders service catch assignDriver : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> changeOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final body = {'status': status};

      final data = await _apiClient.put(
        ApiEndpoint.changeOrderStatus(orderId),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to change order status');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('orders service catch changeOrderStatus : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<OrderModel> getOrder(int orderId) async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getOrder(orderId));

      final apiResponse = ApiResponse.fromJson(data, (json) {
        if (json is Map<String, dynamic>) {
          final orderJson = json['order'] as Map<String, dynamic>;
          return OrderModel.fromJson(orderJson);
        }
        throw Exception('Invalid response');
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as OrderModel;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('orders service catch getOrder : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
