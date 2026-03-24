import 'package:bizreh_admin/features/points/models/user_point_histoy_model.dart';
import 'package:bizreh_admin/features/points/controllers/user_points_balance_controller.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/details_key_value.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPointsBalanceView extends StatelessWidget {
  final int userId;

  const UserPointsBalanceView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final tag = userId.toString();
    final UserPointsBalanceController controller =
        Get.isRegistered<UserPointsBalanceController>(tag: tag)
        ? Get.find<UserPointsBalanceController>(tag: tag)
        : Get.put(UserPointsBalanceController(userId: userId), tag: tag);

    return Obx(() {
      if (controller.isLoading.value) {
        return const BuildProgressIndicator();
      }

      final error = controller.errorMessage.value.trim();
      if (error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final balance = controller.balance.value;
      if (balance == null) {
        return Center(
          child: ElevatedButton.icon(
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Load'),
          ),
        );
      }

      final history = controller.history;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsSectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'User Points Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: controller.refresh,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 6),
                Text(
                  'User #${balance.userId}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 860;

              final left = DetailsSectionCard(
                title: 'Balance',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DetailsKeyValue(
                            label: 'Available Points',
                            value: balance.availablePoints.toString(),
                          ),
                        ),
                        Expanded(
                          child: DetailsKeyValue(
                            label: 'Transactions',
                            value: balance.totalTransactions.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              final right = DetailsSectionCard(
                title: 'Totals',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DetailsKeyValue(
                            label: 'Total Earned',
                            value: balance.totalPointsEarned.toString(),
                          ),
                        ),
                        Expanded(
                          child: DetailsKeyValue(
                            label: 'Total Used',
                            value: balance.totalPointsUsed.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 12),
                    Expanded(child: right),
                  ],
                );
              }

              return Column(
                children: [left, const SizedBox(height: 12), right],
              );
            },
          ),
          const SizedBox(height: 12),
          DetailsSectionCard(
            title: 'History',
            child: history.isEmpty
                ? const Text(
                    'No history',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  )
                : Column(
                    children: [
                      ...history.map(
                        (h) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _HistoryRow(
                            item: h,
                            onOpenOrder: h.orderId == null
                                ? null
                                : () => controller.openOrderDetails(h.orderId!),
                            isOpeningOrder: controller.isOpeningOrder,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}

class _HistoryRow extends StatelessWidget {
  final UserPointHistoyModel item;
  final VoidCallback? onOpenOrder;
  final RxBool isOpeningOrder;

  const _HistoryRow({
    required this.item,
    required this.onOpenOrder,
    required this.isOpeningOrder,
  });

  @override
  Widget build(BuildContext context) {
    final points = item.points?.toString() ?? '-';
    final type = (item.pointsType ?? '-').trim();
    final ref = (item.referenceType ?? '-').trim();
    final orderId = item.orderId;
    final date = formatDate(item.createdAt);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$points ($type)',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _Meta(label: 'Reference', value: ref.isEmpty ? '-' : ref),
                    _Meta(label: 'Date', value: date),
                    _Meta(
                      label: 'Order ID',
                      value: orderId == null ? '-' : orderId.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (orderId != null)
            Obx(() {
              final disabled = isOpeningOrder.value;
              return ElevatedButton.icon(
                onPressed: disabled ? null : onOpenOrder,
                icon: const Icon(Icons.receipt_long, size: 16),
                label: Text(disabled ? 'Loading...' : 'Order details'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;

  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(value.trim().isEmpty ? '-' : value),
      ],
    );
  }
}
