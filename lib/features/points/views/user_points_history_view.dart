import 'package:bizreh_admin/features/points/controllers/user_points_history_controller.dart';
import 'package:bizreh_admin/features/points/models/user_point_history/history.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/services/orders_service.dart';

class UserPointsHistoryView extends StatelessWidget {
  final int userId;

  const UserPointsHistoryView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final tag = userId.toString();
    final UserPointsHistoryController controller =
        Get.isRegistered<UserPointsHistoryController>(tag: tag)
        ? Get.find<UserPointsHistoryController>(tag: tag)
        : Get.put(
            UserPointsHistoryController(
              userId: userId,
              pointsService: sl<PointsService>(),
              ordersService: sl<OrdersService>(),
            ),
            tag: tag,
          );

    return Obx(() {
      if (controller.isLoading.value) {
        return const BuildProgressIndicator();
      }

      final error = controller.errorMessage.value.trim();
      if (error.isNotEmpty) {
        return _ErrorState(error: error, onRetry: controller.refresh);
      }

      final pointHistory = controller.pointHistory.value;
      if (pointHistory == null) {
        return _EmptyState(onRetry: controller.refresh);
      }

      final summary = controller.summary;
      final history = controller.history;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsSectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'User Points History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  'User #$userId',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: controller.refresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = [
                _SummaryCard(
                  label: 'Current Balance',
                  value: _value(summary?.currentBalance),
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _SummaryCard(
                  label: 'Total Earned',
                  value: _value(summary?.totalEarned),
                  icon: Icons.arrow_downward_rounded,
                  valueColor: const Color(0xFF15803D),
                ),
                _SummaryCard(
                  label: 'Total Used',
                  value: _value(summary?.totalSpent),
                  icon: Icons.arrow_upward_rounded,
                  valueColor: const Color(0xFFB91C1C),
                ),
                _SummaryCard(
                  label: 'Transactions',
                  value: _value(summary?.totalTransactions),
                  icon: Icons.receipt_long_outlined,
                ),
              ];

              if (constraints.maxWidth >= 980) {
                return Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 12),
                    Expanded(child: cards[1]),
                    const SizedBox(width: 12),
                    Expanded(child: cards[2]),
                    const SizedBox(width: 12),
                    Expanded(child: cards[3]),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[1]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[3]),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          DetailsSectionCard(
            title: 'History',
            child: history.isEmpty
                ? const Text(
                    'No history available for this user.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final orderId = _resolveOrderId(item);
                      return _HistoryCard(
                        item: item,
                        isOpeningOrder: controller.isOpeningOrder,
                        onOpenOrder: orderId == null
                            ? null
                            : () => controller.openOrderDetails(orderId),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF374151)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final History item;
  final VoidCallback? onOpenOrder;
  final RxBool isOpeningOrder;

  const _HistoryCard({
    required this.item,
    required this.onOpenOrder,
    required this.isOpeningOrder,
  });

  @override
  Widget build(BuildContext context) {
    final pointsValue = item.points ?? 0;
    final isEarned = (item.pointsType ?? '').toLowerCase() == 'earned';
    final pointsColor = isEarned
        ? const Color(0xFF15803D)
        : const Color(0xFFB91C1C);
    final date = formatDate(item.createdAt);
    final ref = (item.referenceType ?? '-').trim();
    final refAr = (item.referenceTypeAr ?? '').trim();
    final source = (item.sourceDescription ?? '').trim();
    final orderId = _resolveOrderId(item);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: pointsColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${isEarned ? '+' : '-'}${pointsValue.abs()} pts',
                  style: TextStyle(
                    color: pointsColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _Tag(text: ref.isEmpty ? '-' : ref),
              if (refAr.isNotEmpty) ...[
                const SizedBox(width: 6),
                _Tag(text: refAr),
              ],
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (source.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              source,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (item.orderDetails?.orderNumber?.trim().isNotEmpty == true ||
              item.giftDetails?.title?.trim().isNotEmpty == true ||
              orderId != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (item.orderDetails?.orderNumber?.trim().isNotEmpty == true)
                  Text(
                    'Order: ${item.orderDetails!.orderNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                if (item.giftDetails?.title?.trim().isNotEmpty == true)
                  Text(
                    'Gift: ${item.giftDetails!.title}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                if (orderId != null)
                  Text(
                    'Order ID: $orderId',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ],
          if (orderId != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                final disabled = isOpeningOrder.value;
                return ElevatedButton.icon(
                  onPressed: disabled ? null : onOpenOrder,
                  icon: const Icon(Icons.receipt_long, size: 16),
                  label: Text(disabled ? 'Loading...' : 'Open Order'),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 28),
          const SizedBox(height: 8),
          Text(error, style: const TextStyle(color: Color(0xFFDC2626))),
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

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'No points data loaded.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Load'),
          ),
        ],
      ),
    );
  }
}

String _value(int? value) => value?.toString() ?? '-';

int? _resolveOrderId(History item) {
  final direct = item.orderDetails?.orderId;
  if (direct != null) return direct;

  final refType = (item.referenceType ?? '').toLowerCase();
  if (refType.contains('order')) {
    return item.referenceId;
  }

  return null;
}
