import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/user_payment_and_order_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_model/user_payment_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_py_year/user_payment_py_year.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class PaymentService {
  final DioClient _dioClient = DioClient();

  Future<List<PaymentModel>> getPayments() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getPayments);

      final apiResponse = ApiResponse.fromJson(response.data, (data) {
        final List list = (data as List?) ?? <dynamic>[];
        return list
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<PaymentModel>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException getPayments : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException getPayments : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.post(
        ApiEndpoint.createPayment,
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create payment');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException createPayment : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException createPayment : ${e.message}');
      throw Exception(e.message);
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

      final response = await _dioClient.put(
        ApiEndpoint.updatePayment(id),
        data: body,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update payment');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException updatePayment : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException updatePayment : ${e.toString()}');
      throw Exception(e.message);
    } catch (e) {
      log('payment service catch updatePayment : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deletePayment(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete payment');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException deletePayment : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException deletePayment : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('payment service catch deletePayment : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<UserPaymentPyYear>> getUserReportByYear(int year) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getUserReportByYear(year),
      );

      final apiResponse = ApiResponse.fromJson(response.data, (data) {
        final List list = (data as List?) ?? <dynamic>[];
        return list
            .map((e) => UserPaymentPyYear.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<UserPaymentPyYear>;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException getUserReportByYear : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException getUserReportByYear : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('payment service catch getUserReportByYear : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<UserPaymentModel> getPaymentsByUserId(int userId) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getPaymentsByUserId(userId),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) => UserPaymentModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserPaymentModel;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException getPaymentsByUserId : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('payment service DioException getPaymentsByUserId : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('payment service catch getPaymentsByUserId : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<UserPaymentAndOrderModel> getPaymentsAndOrdersByUserId(
    int userId,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoint.getPaymentsAndOrdersByUserId(userId),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (data) =>
            UserPaymentAndOrderModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserPaymentAndOrderModel;
      }
      throw Exception(apiResponse.message ?? 'Something went wrong');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'payment service AppException getPaymentsAndOrdersByUserId : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'payment service DioException getPaymentsAndOrdersByUserId : ${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log(
        'payment service catch getPaymentsAndOrdersByUserId : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }
}
