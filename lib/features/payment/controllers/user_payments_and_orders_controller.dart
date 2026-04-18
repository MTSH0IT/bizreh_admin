import 'dart:developer';

import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/orders/views/order_details_view.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/order.dart'
    as payment_order_model;
import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/payment.dart'
    as payment_model;
import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/user_payment_and_order_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PaymentTableType { orders, payments }

class UserPaymentsAndOrdersController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  final OrdersService _ordersService = OrdersService();

  final Rx<UserPaymentAndOrderModel?> data = Rx<UserPaymentAndOrderModel?>(
    null,
  );
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<PaymentTableType> selectedTable = PaymentTableType.orders.obs;
  final RxBool isOpeningOrder = false.obs;
  final RxBool isCreatingPayment = false.obs;

  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  final TextEditingController paymentNotesController = TextEditingController();
  int? _selectedUserIdForCreate;

  Future<void> load(int userId) async {
    try {
      isLoading.value = true;
      final result = await _paymentService.getPaymentsAndOrdersByUserId(userId);
      data.value = result;
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in load payments and orders: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch user payments and orders', false);
      log('Error in load payments and orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  void setSelectedTable(PaymentTableType type) {
    selectedTable.value = type;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  List<payment_order_model.Order> get filteredOrders {
    final list = data.value?.orders ?? const <payment_order_model.Order>[];
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return list;

    return list.where((order) {
      final id = (order.id?.toString() ?? '').toLowerCase();
      final orderNumber = (order.orderNumber ?? '').toLowerCase();
      final totalAmount = (order.totalAmount?.toString() ?? '').toLowerCase();
      final createdAt = (order.createdAt?.toIso8601String() ?? '')
          .toLowerCase();

      return id.contains(q) ||
          orderNumber.contains(q) ||
          totalAmount.contains(q) ||
          createdAt.contains(q);
    }).toList();
  }

  List<payment_model.Payment> get filteredPayments {
    final list = data.value?.payments ?? const <payment_model.Payment>[];
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return list;

    return list.where((payment) {
      final id = (payment.id?.toString() ?? '').toLowerCase();
      final amount = (payment.amount ?? '').toLowerCase();
      final type = (payment.type ?? '').toLowerCase();
      final notes = (payment.notes ?? '').toLowerCase();
      final createdAt = (payment.createdAt?.toIso8601String() ?? '')
          .toLowerCase();

      return id.contains(q) ||
          amount.contains(q) ||
          type.contains(q) ||
          notes.contains(q) ||
          createdAt.contains(q);
    }).toList();
  }

  Future<void> openOrderDetails(int orderId) async {
    if (isOpeningOrder.value) return;

    try {
      isOpeningOrder.value = true;
      final order = await _ordersService.getOrder(orderId);

      Get.find<MainNavController>().push(
        MainNavEntry(
          title: 'Order #${order.orderNumber ?? orderId}',
          page: OrderDetailsView(order: order),
        ),
      );
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in openOrderDetails: ${e.message}');
    } catch (e) {
      showMassage('Failed to load order', false);
      log('Error in openOrderDetails: $e');
    } finally {
      isOpeningOrder.value = false;
    }
  }

  void prepareCreatePaymentForUser(int userId) {
    _selectedUserIdForCreate = userId;
    clearPaymentForm();
  }

  Future<void> createPaymentForSelectedUser() async {
    final selectedUserId = _selectedUserIdForCreate;
    if (selectedUserId == null) {
      showMassage('User is not selected', false);
      return;
    }
    if (!_validateCreatePaymentForm()) return;

    try {
      isCreatingPayment.value = true;
      await _paymentService.createPayment(
        userId: selectedUserId,
        amount: double.parse(paymentAmountController.text.trim()),
        type: paymentTypeController.text.trim(),
        notes: paymentNotesController.text.trim(),
      );
      await load(selectedUserId);
      clearPaymentForm();
      Get.back();
      showMassage('Payment created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createPaymentForSelectedUser: ${e.message}');
    } catch (e) {
      showMassage('Failed to create payment', false);
      log('Error in createPaymentForSelectedUser: $e');
    } finally {
      isCreatingPayment.value = false;
    }
  }

  bool _validateCreatePaymentForm() {
    if (paymentAmountController.text.trim().isEmpty) {
      showMassage('Please enter amount', false);
      return false;
    }
    if (paymentTypeController.text.trim().isEmpty) {
      showMassage('Please select payment type', false);
      return false;
    }
    try {
      double.parse(paymentAmountController.text.trim());
    } catch (_) {
      showMassage('Please enter a valid amount', false);
      return false;
    }
    return true;
  }

  void clearPaymentForm() {
    paymentAmountController.clear();
    paymentTypeController.clear();
    paymentNotesController.clear();
  }

  @override
  void onClose() {
    clearSearch();
    clearPaymentForm();
    paymentAmountController.dispose();
    paymentTypeController.dispose();
    paymentNotesController.dispose();
    super.onClose();
  }
}
