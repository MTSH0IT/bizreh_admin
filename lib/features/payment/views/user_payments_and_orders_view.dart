import 'package:bizreh_admin/features/payment/controllers/user_payments_and_orders_controller.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_orders_table.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_payments_and_orders_summary_cards.dart';
import 'package:bizreh_admin/features/payment/views/widgets/user_payments_v2_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPaymentsAndOrdersView extends StatefulWidget {
  final int userId;
  final String? userName;

  const UserPaymentsAndOrdersView({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<UserPaymentsAndOrdersView> createState() =>
      _UserPaymentsAndOrdersViewState();
}

class _UserPaymentsAndOrdersViewState extends State<UserPaymentsAndOrdersView> {
  late final String tag;
  late final UserPaymentsAndOrdersController controller;

  @override
  void initState() {
    super.initState();
    tag = 'user_payments_orders_${widget.userId}';
    controller = Get.put(UserPaymentsAndOrdersController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load(widget.userId);
    });
  }

  @override
  void dispose() {
    Get.delete<UserPaymentsAndOrdersController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search orders and payments...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: () => controller.load(widget.userId),
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final data = controller.data.value;
          if (data == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xFF6B7280),
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No payments and orders data found',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            );
          }

          final orders = controller.filteredOrders;
          final payments = controller.filteredPayments;
          final selectedTable = controller.selectedTable.value;
          final ordersCount = data.summary?.ordersCount ?? data.orders?.length;
          final paymentsCount =
              data.summary?.paymentsCount ?? data.payments?.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserPaymentsAndOrdersSummaryCards(data: data),
              const SizedBox(height: 16),
              DetailsSectionCard(
                child: Row(
                  children: [
                    _TableToggleButton(
                      label: 'Orders (${ordersCount ?? 0})',
                      icon: Icons.shopping_bag_outlined,
                      selected: selectedTable == PaymentTableType.orders,
                      onTap: () =>
                          controller.setSelectedTable(PaymentTableType.orders),
                    ),
                    const SizedBox(width: 8),
                    _TableToggleButton(
                      label: 'Payments (${paymentsCount ?? 0})',
                      icon: Icons.payments_outlined,
                      selected: selectedTable == PaymentTableType.payments,
                      onTap: () => controller.setSelectedTable(
                        PaymentTableType.payments,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              DetailsSectionCard(
                title: selectedTable == PaymentTableType.orders
                    ? 'Orders History'
                    : 'Payments History',
                child: selectedTable == PaymentTableType.orders
                    ? UserOrdersTable(
                        orders: orders,
                        isOpeningOrder: controller.isOpeningOrder.value,
                        onOpenOrderDetails: controller.openOrderDetails,
                      )
                    : UserPaymentsV2Table(payments: payments),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _TableToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TableToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF4F46E5) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? const Color(0xFF3730A3)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF3730A3)
                    : const Color(0xFF374151),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
