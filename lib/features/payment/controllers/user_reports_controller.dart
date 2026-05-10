import 'dart:developer';

import 'package:bizreh_admin/features/payment/models/user_payment_py_year/user_payment_py_year.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/payment_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class UserReportsController extends GetxController {
  final PaymentService _service;

  UserReportsController({required PaymentService service}) : _service = service;

  final RxList<UserPaymentPyYear> userReports = <UserPaymentPyYear>[].obs;
  final RxBool isLoadingUserReports = false.obs;
  final RxString userReportSearchQuery = ''.obs;

  Future<void> getUserReportsByYear(int year) async {
    try {
      isLoadingUserReports.value = true;
      final data = await _service.getUserReportByYear(year);
      userReports.value = data;
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

  void clearSearch() {
    userReportSearchQuery.value = '';
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

  @override
  void onClose() {
    clearSearch();
    super.onClose();
  }
}
