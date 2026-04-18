import 'package:bizreh_admin/features/payment/models/user_payment_and_order_model/order.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class UserOrdersTable extends StatelessWidget {
  final List<Order> orders;
  final bool isOpeningOrder;
  final ValueChanged<int> onOpenOrderDetails;

  const UserOrdersTable({
    super.key,
    required this.orders,
    required this.isOpeningOrder,
    required this.onOpenOrderDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('No orders found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return DataTableWidget<Order>(
      rows: orders,
      emptyMessage: 'No orders match your search',
      showActions: false,
      columns: const [
        DataColumn(
          label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Order Number',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Total Amount',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (order, index) {
        return [
          DataCell(DataTableTextCell(text: order.id?.toString() ?? '-')),
          DataCell(DataTableTextCell(text: order.orderNumber ?? '-')),
          DataCell(
            DataTableTextCell(text: order.totalAmount?.toString() ?? '-'),
          ),
          DataCell(DataTableDateCell(date: order.createdAt)),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: isOpeningOrder || order.id == null
                    ? null
                    : () => onOpenOrderDetails(order.id!),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(isOpeningOrder ? 'Loading...' : 'View Details'),
              ),
            ),
          ),
        ];
      },
    );
  }
}
