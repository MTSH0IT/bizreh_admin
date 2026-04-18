import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final PaymentService _service = PaymentService();

  final RxList<PaymentModel> payments = <PaymentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final Rx<PaymentModel?> selectedPayment = Rx<PaymentModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPayments();
  }

  @override
  void onClose() {
    userIdController.dispose();
    amountController.dispose();
    typeController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> getPayments() async {
    try {
      isLoading.value = true;
      final data = await _service.getPayments();
      payments.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getPayments: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch payments', false);
      log('Error in getPayments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPayment() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _service.createPayment(
        userId: int.parse(userIdController.text.trim()),
        amount: double.parse(amountController.text.trim()),
        type: typeController.text.trim(),
        notes: notesController.text.trim(),
      );
      await getPayments();
      clearForm();
      Get.back();
      showMassage('Payment created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createPayment: ${e.message}');
    } catch (e) {
      showMassage('Failed to create payment', false);
      log('Error in createPayment: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updatePayment() async {
    final current = selectedPayment.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _service.updatePayment(
        id: current!.id!,
        amount: double.parse(amountController.text.trim()),
        type: typeController.text.trim(),
        notes: notesController.text.trim(),
      );
      await getPayments();
      clearForm();
      Get.back();
      showMassage('Payment updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updatePayment: ${e.message}');
    } catch (e) {
      showMassage('Failed to update payment', false);
      log('Error in updatePayment: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      isDeleting.value = true;
      await _service.deletePayment(id);
      await getPayments();
      showMassage('Payment deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deletePayment: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete payment', false);
      log('Error in deletePayment: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm() {
    if (userIdController.text.trim().isEmpty) {
      showMassage('Please enter user ID', false);
      return false;
    }
    if (amountController.text.trim().isEmpty) {
      showMassage('Please enter amount', false);
      return false;
    }
    if (typeController.text.trim().isEmpty) {
      showMassage('Please enter type', false);
      return false;
    }
    try {
      int.parse(userIdController.text.trim());
    } catch (e) {
      showMassage('Please enter a valid user ID', false);
      return false;
    }
    try {
      double.parse(amountController.text.trim());
    } catch (e) {
      showMassage('Please enter a valid amount', false);
      return false;
    }
    return true;
  }

  void clearForm() {
    userIdController.clear();
    amountController.clear();
    typeController.clear();
    notesController.clear();
    selectedPayment.value = null;
  }

  void setPaymentForEdit(PaymentModel model) {
    selectedPayment.value = model;
    userIdController.text = model.userId?.toString() ?? '';
    amountController.text = model.amount ?? '';
    typeController.text = model.type ?? '';
    notesController.text = model.notes ?? '';
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<PaymentModel> get filteredPayments {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return payments.toList();

    return payments.where((p) {
      final id = (p.id?.toString() ?? '').toLowerCase();
      final userId = (p.userId?.toString() ?? '').toLowerCase();
      final fn = (p.firstName ?? '').toLowerCase();
      final ln = (p.lastName ?? '').toLowerCase();
      final email = (p.email ?? '').toLowerCase();
      final type = (p.type ?? '').toLowerCase();
      final notes = (p.notes ?? '').toLowerCase();
      final amount = (p.amount ?? '').toLowerCase();
      return id.contains(q) ||
          userId.contains(q) ||
          fn.contains(q) ||
          ln.contains(q) ||
          email.contains(q) ||
          type.contains(q) ||
          notes.contains(q) ||
          amount.contains(q);
    }).toList();
  }

  bool get isEditing => selectedPayment.value != null;
}
