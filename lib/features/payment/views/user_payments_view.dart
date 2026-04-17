import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_payments_payments_table.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_payments_summary_cards.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPaymentsView extends StatelessWidget {
  final int userId;
  final String? userName;

  const UserPaymentsView({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'user_payments_$userId';
    final PaymentController controller = Get.isRegistered<PaymentController>(tag: tag)
        ? Get.find<PaymentController>(tag: tag)
        : Get.put(PaymentController(), tag: tag);

    // Initialize with the user ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchUserIdController.text = userId.toString();
      controller.getPaymentsByUserId();
    });

    return Obx(() {
      if (controller.isLoadingUserPayments.value) {
        return const BuildProgressIndicator();
      }

      final userPayment = controller.filteredUserPayment;

      if (userPayment == null) {
        return _EmptyState(
          onRetry: controller.getPaymentsByUserId,
          userName: userName,
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsSectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'User Payments',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  userName != null ? 'User: $userName' : 'User ID: $userId',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: controller.getPaymentsByUserId,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          UserPaymentsSummaryCards(userPayment: userPayment),
          const SizedBox(height: 12),
          DetailsSectionCard(
            title: 'Payment History',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchField(
                  hintText: 'Search payments...',
                  onChanged: controller.setUserPaymentSearchQuery,
                ),
                const SizedBox(height: 12),
                UserPaymentsPaymentsTable(
                  payments: userPayment.payments,
                  searchQuery: controller.userPaymentSearchQuery.value.trim().isEmpty
                      ? null
                      : controller.userPaymentSearchQuery.value.trim(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? userName;

  const _EmptyState({required this.onRetry, this.userName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.payments_outlined, color: Color(0xFF6B7280), size: 48),
          const SizedBox(height: 16),
          Text(
            userName != null 
                ? 'No payment data found for $userName'
                : 'No payment data found for this user',
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
