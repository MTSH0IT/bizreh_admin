import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/user_payment_and_order_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_py_year/user_payment_py_year.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';

class PaymentService {
  final IApiClient _apiClient;

  PaymentService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<PaymentModel>> getPayments() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getPayments);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PaymentModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('payment service catch getPayments : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createPayment({
    required int userId,
    required double amount,
    required String type,
    String notes = '',
  }) async {
    try {
      final body = {
        'user_id': userId,
        'amount': amount,
        'type': type,
        'notes': notes,
      };

      final responseData = await _apiClient.post(
        ApiEndpoint.createPayment,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create payment');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('payment service catch createPayment : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updatePayment({
    required int id,
    required double amount,
    required String type,
    String notes = '',
  }) async {
    try {
      final body = {'amount': amount, 'type': type, 'notes': notes};

      final responseData = await _apiClient.put(
        ApiEndpoint.updatePayment(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update payment');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('payment service catch updatePayment : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      final responseData = await _apiClient.delete(ApiEndpoint.deletePayment(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(responseData, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete payment');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('payment service catch deletePayment : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<UserPaymentPyYear>> getUserReportByYear(int year) async {
    try {
      final data = await _apiClient.get(
        ApiEndpoint.getUserReportByYear(year),
      );

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => UserPaymentPyYear.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserPaymentPyYear>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log('payment service catch getUserReportByYear : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<UserPaymentAndOrderModel> getPaymentsAndOrdersByUserId(
    int userId,
  ) async {
    try {
      final data = await _apiClient.get(
        ApiEndpoint.getPaymentsAndOrdersByUserId(userId),
      );

      final apiResponse = ApiResponse.fromJson(
        data,
        (json) =>
            UserPaymentAndOrderModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserPaymentAndOrderModel;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'payment service catch getPaymentsAndOrdersByUserId : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
