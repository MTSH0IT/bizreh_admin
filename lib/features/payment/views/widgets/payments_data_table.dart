import 'package:bizreh_admin/features/payment/models/payment_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class PaymentsDataTable extends StatelessWidget {
  final List<PaymentModel> rows;
  final ValueChanged<PaymentModel>? onEdit;
  final ValueChanged<PaymentModel>? onDelete;

  const PaymentsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<PaymentModel>(
      rows: rows,
      emptyMessage: 'No payments found',
      showActions: false, // We'll use custom actions column
      columns: const [
        DataColumn(
          label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('User ID', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Full Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
        DataColumn(
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (payment, index) {
        return [
          DataCell(DataTableTextCell(text: payment.id?.toString() ?? '-')),
          DataCell(DataTableTextCell(text: payment.userId?.toString() ?? '-')),
          DataCell(
            DataTableTextCell(
              text:
                  '${payment.firstName ?? ''} ${payment.lastName ?? ''}'
                          .trim() ==
                      ''
                  ? '-'
                  : '${payment.firstName} ${payment.lastName}',
            ),
          ),
          DataCell(DataTableTextCell(text: payment.amount ?? '-')),
          DataCell(DataTableTextCell(text: payment.type ?? '-')),
          DataCell(DataTableTextCell(text: payment.notes ?? '-')),
          DataCell(DataTableDateCell(date: payment.createdAt)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(
                    onPressed: () => onEdit!(payment),
                    icon: const Icon(Icons.edit, size: 16),
                    tooltip: 'Edit',
                    color: Colors.blue,
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: () => onDelete!(payment),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    tooltip: 'Delete',
                    color: Colors.red,
                  ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
