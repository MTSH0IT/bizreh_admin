import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/user_payment_and_order_model.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';

class UserPaymentsAndOrdersSummaryCards extends StatelessWidget {
  final UserPaymentAndOrderModel? data;

  const UserPaymentsAndOrdersSummaryCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const DetailsSectionCard(
        child: Text(
          'No payment and order data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final summary = data!.summary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _SummaryCard(
            label: 'Total Bonus',
            value: '${summary?.totalBonus ?? 0}',
            icon: Icons.card_giftcard_outlined,
            valueColor: const Color(0xFF7C3AED),
          ),
          _SummaryCard(
            label: 'Orders Amount',
            value: '${summary?.totalOrdersAmount ?? 0}',
            icon: Icons.receipt_long_outlined,
          ),
          _SummaryCard(
            label: 'Regular Payments',
            value: '${summary?.totalRegularPayments ?? 0}',
            icon: Icons.payment_outlined,
            valueColor: const Color(0xFF15803D),
          ),
          _SummaryCard(
            label: 'Balance Due',
            value: '${summary?.balanceDue ?? 0}',
            icon: Icons.account_balance_wallet_outlined,
            valueColor: const Color(0xFFB91C1C),
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
    );
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
    return DetailsSectionCard(
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
