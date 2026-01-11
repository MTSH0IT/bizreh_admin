import 'dart:developer';

import 'package:bizreh_admin/features/orders/models/order_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class OrdersService {
  final DioClient _dioClient = DioClient();

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getOrders);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final wrapper = json['orders'];
        final List list = (wrapper?['orders'] as List?) ?? <dynamic>[];
        return list
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<OrderModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'orders service AppException getOrders : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('orders service DioException getOrders : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.assignOrderDriver(orderId),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to assign driver');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'orders service AppException assignDriver : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('orders service DioException assignDriver : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('orders service catch assignDriver : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
