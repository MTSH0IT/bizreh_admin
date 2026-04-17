import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_py_year/user_payment_py_year.dart';
import 'package:bizreh_admin/features/payment/models/user_payment_model/user_payment_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final PaymentService _service = PaymentService();

  final RxList<PaymentModel> payments = <PaymentModel>[].obs;
  final RxList<UserPaymentPyYear> userReports = <UserPaymentPyYear>[].obs;
  final Rx<UserPaymentModel?> userPayment = Rx<UserPaymentModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isLoadingUserReports = false.obs;
  final RxBool isLoadingUserPayments = false.obs;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController searchUserIdController = TextEditingController();

  final Rx<PaymentModel?> selectedPayment = Rx<PaymentModel?>(null);
  final RxString searchQuery = ''.obs;
  final RxString userReportSearchQuery = ''.obs;
  final RxString userPaymentSearchQuery = ''.obs;

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
    yearController.dispose();
    searchUserIdController.dispose();
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
      final fn = (p.firstName ?? '').toLowerCase();
      final ln = (p.lastName ?? '').toLowerCase();
      final email = (p.email ?? '').toLowerCase();
      final type = (p.type ?? '').toLowerCase();
      final notes = (p.notes ?? '').toLowerCase();
      final amount = (p.amount ?? '').toLowerCase();
      return fn.contains(q) ||
          ln.contains(q) ||
          email.contains(q) ||
          type.contains(q) ||
          notes.contains(q) ||
          amount.contains(q);
    }).toList();
  }

  bool get isEditing => selectedPayment.value != null;

  Future<void> getUserReportsByYear() async {
    if (yearController.text.trim().isEmpty) {
      showMassage('Please enter year', false);
      return;
    }

    try {
      isLoadingUserReports.value = true;
      final year = int.parse(yearController.text.trim());
      final data = await _service.getUserReportByYear(year);
      userReports.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getUserReportsByYear: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch user reports', false);
      log('Error in getUserReportsByYear: $e');
    } finally {
      isLoadingUserReports.value = false;
    }
  }

  void setUserReportSearchQuery(String q) {
    userReportSearchQuery.value = q;
  }

  List<UserPaymentPyYear> get filteredUserReports {
    final q = userReportSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return userReports.toList();

    return userReports.where((report) {
      final userName = (report.user?.name ?? '').toLowerCase();
      final userEmail = (report.user?.email ?? '').toLowerCase();
      final userPhone = (report.user?.phone ?? '').toLowerCase();
      final year = (report.summary?.year?.toString() ?? '').toLowerCase();
      final totalPayments = (report.summary?.totalPayments?.toString() ?? '')
          .toLowerCase();
      final totalBonus = (report.summary?.totalBonus?.toString() ?? '')
          .toLowerCase();
      final ordersCount = (report.summary?.ordersCount?.toString() ?? '')
          .toLowerCase();
      final ordersTotal = (report.summary?.ordersTotal?.toString() ?? '')
          .toLowerCase();

      return userName.contains(q) ||
          userEmail.contains(q) ||
          userPhone.contains(q) ||
          year.contains(q) ||
          totalPayments.contains(q) ||
          totalBonus.contains(q) ||
          ordersCount.contains(q) ||
          ordersTotal.contains(q);
    }).toList();
  }

  Future<void> getPaymentsByUserId() async {
    if (searchUserIdController.text.trim().isEmpty) {
      showMassage('Please enter user ID', false);
      return;
    }

    try {
      isLoadingUserPayments.value = true;
      final userId = int.parse(searchUserIdController.text.trim());
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

  UserPaymentModel? get filteredUserPayment {
    final q = userPaymentSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty || userPayment.value == null) return userPayment.value;

    final data = userPayment.value!;
    final userId = (data.userId ?? '').toLowerCase();
    final totalRegularPayments =
        (data.summary?.totalRegularPayments?.toString() ?? '').toLowerCase();
    final totalBonus = (data.summary?.totalBonus?.toString() ?? '')
        .toLowerCase();
    final totalTransactions =
        (data.summary?.totalTransactions?.toString() ?? '').toLowerCase();

    final matches =
        userId.contains(q) ||
        totalRegularPayments.contains(q) ||
        totalBonus.contains(q) ||
        totalTransactions.contains(q);

    return matches ? data : null;
  }
}
