import 'package:bizreh_admin/features/payment/models/user_payment_model/payment.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class UserPaymentsPaymentsTable extends StatelessWidget {
  final List<Payment>? payments;
  final String? searchQuery;

  const UserPaymentsPaymentsTable({
    super.key,
    required this.payments,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (payments == null || payments!.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('No payments found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    List<Payment> filteredPayments = payments!;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final q = searchQuery!.toLowerCase();
      filteredPayments = payments!.where((payment) {
        final amount = (payment.amount ?? '').toLowerCase();
        final type = (payment.type ?? '').toLowerCase();
        final notes = (payment.notes ?? '').toLowerCase();
        final createdAt = (payment.createdAt?.toString() ?? '').toLowerCase();
        
        return amount.contains(q) ||
            type.contains(q) ||
            notes.contains(q) ||
            createdAt.contains(q);
      }).toList();
    }

    return DataTableWidget<Payment>(
      rows: filteredPayments,
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
          label: Text('Created At', style: TextStyle(fontWeight: FontWeight.bold)),
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
