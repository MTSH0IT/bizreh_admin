import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/user_payment_model/user_payment_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class UserPaymentsController extends GetxController {
  final PaymentService _service = PaymentService();

  final Rx<UserPaymentModel?> userPayment = Rx<UserPaymentModel?>(null);
  final RxBool isLoadingUserPayments = false.obs;
  final RxString userPaymentSearchQuery = ''.obs;

  Future<void> getPaymentsByUserId(int userId) async {
    try {
      isLoadingUserPayments.value = true;
      final data = await _service.getPaymentsByUserId(userId);
      userPayment.value = data;
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getPaymentsByUserId: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch user payments', false);
      log('Error in getPaymentsByUserId: $e');
    } finally {
      isLoadingUserPayments.value = false;
    }
  }

  void setUserPaymentSearchQuery(String q) {
    userPaymentSearchQuery.value = q;
  }

  void clearSearch() {
    userPaymentSearchQuery.value = '';
  }

  @override
  void onClose() {
    clearSearch();
    super.onClose();
  }

  UserPaymentModel? get filteredUserPayment {
    final q = userPaymentSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty || userPayment.value == null) return userPayment.value;

    final data = userPayment.value!;
    final payments = data.payments;
    final filteredPayments = payments?.where((payment) {
      final amount = (payment.amount ?? '').toLowerCase();
      final type = (payment.type ?? '').toLowerCase();
      final notes = (payment.notes ?? '').toLowerCase();
      return amount.contains(q) || type.contains(q) || notes.contains(q);
    }).toList();

    return UserPaymentModel(
      userId: data.userId,
      summary: data.summary,
      payments: filteredPayments ?? [],
    );
  }
}
