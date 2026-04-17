import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/utils/func/date_format.dart';
import 'package:bizreh_admin/utils/widgets/details_key_value.dart';
import 'package:bizreh_admin/utils/widgets/details_section_card.dart';
import 'package:flutter/material.dart';

class PaymentDetailsView extends StatelessWidget {
  final PaymentModel payment;

  const PaymentDetailsView({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(payment: payment),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final leftContent = Column(
              children: [
                _PaymentInfoCard(payment: payment),
                const SizedBox(height: 12),
                _UserInfoCard(payment: payment),
              ],
            );
            final rightContent = Column(
              children: [
                _AmountCard(payment: payment),
                const SizedBox(height: 12),
                _NotesCard(payment: payment),
              ],
            );

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: leftContent),
                  const SizedBox(width: 12),
                  Expanded(child: rightContent),
                ],
              );
            }

            return Column(
              children: [leftContent, const SizedBox(height: 12), rightContent],
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final PaymentModel payment;

  const _Header({required this.payment});

  @override
  Widget build(BuildContext context) {
    final title = 'Payment #${payment.id ?? '-'}';

    return DetailsSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Created: ${formatDate(payment.createdAt)}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Badge(
                label: payment.type ?? '-',
                color: _getPaymentTypeColor(payment.type),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  final PaymentModel payment;

  const _PaymentInfoCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Payment Information',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Payment ID',
                  value: payment.id?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'User ID',
                  value: payment.userId?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Payment Type',
                  value: payment.type ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Status',
                  value: 'Completed', // Assuming all payments are completed
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final PaymentModel payment;

  const _UserInfoCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'User Information',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Name',
                  value: '${payment.firstName ?? '-'} ${payment.lastName ?? ''}'
                      .trim(),
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Email',
                  value: payment.email ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DetailsKeyValue(label: 'Phone', value: payment.phone ?? '-'),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  final PaymentModel payment;

  const _AmountCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Amount',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DetailsKeyValue(
                  label: 'Amount',
                  value: payment.amount ?? '-',
                ),
              ),
              Expanded(
                child: DetailsKeyValue(
                  label: 'Currency',
                  value: 'SAR', // Assuming SAR as default currency
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final PaymentModel payment;

  const _NotesCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    return DetailsSectionCard(
      title: 'Notes',
      child: Text(
        payment.notes ?? 'No notes available',
        style: TextStyle(
          color: payment.notes != null
              ? const Color(0xFF111827)
              : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

Color _getPaymentTypeColor(String? type) {
  if (type == null) return Colors.grey;

  switch (type.toLowerCase()) {
    case 'cash':
      return Colors.green;
    case 'card':
      return Colors.blue;
    case 'online':
      return Colors.purple;
    case 'bonus':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}
