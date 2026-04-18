import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/payment.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class UserPaymentsV2Table extends StatelessWidget {
  final List<Payment> payments;

  const UserPaymentsV2Table({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No payments found',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return DataTableWidget<Payment>(
      rows: payments,
      emptyMessage: 'No payments match your search',
      showActions: false,
      columns: const [
        DataColumn(
          label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (payment, index) {
        return [
          DataCell(DataTableTextCell(text: payment.id?.toString() ?? '-')),
          DataCell(DataTableTextCell(text: payment.amount ?? '-')),
          DataCell(DataTableTextCell(text: payment.type ?? '-')),
          DataCell(DataTableTextCell(text: payment.notes ?? '-')),
          DataCell(DataTableDateCell(date: payment.createdAt)),
        ];
      },
    );
  }
}
