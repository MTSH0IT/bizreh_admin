import 'package:bizreh_admin/features/orders/models/order_model.dart';
import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class OrdersDataTable extends StatelessWidget {
  final List<OrderModel> rows;
  final ValueChanged<OrderModel> onAssign;
  final ValueChanged<OrderModel> onChangeStatus;

  const OrdersDataTable({
    super.key,
    required this.rows,
    required this.onAssign,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<OrderModel>(
      rows: rows,
      emptyMessage: 'No orders found',
      showActions: false,
      columns: const [
        DataColumn(
          label: Text('Order #', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Assign', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (o, index) {
        final driverText = (o.driverName ?? '').toString().trim().isEmpty
            ? '-'
            : (o.driverName ?? '').toString();

        return [
          DataCell(DataTableTextCell(text: o.orderNumber)),
          DataCell(DataTableTextCell(text: o.userName)),
          DataCell(DataTableTextCell(text: o.cityName)),
          DataCell(DataTableTextCell(text: o.totalAmount?.toStringAsFixed(2))),
          DataCell(DataTableTextCell(text: o.status)),
          DataCell(DataTableTextCell(text: o.paymentStatus)),
          DataCell(DataTableTextCell(text: driverText)),
          DataCell(DataTableDateCell(date: o.createdAt)),
          DataCell(
            OutlinedButton(
              onPressed: (o.id == null) ? null : () => onAssign(o),
              style: OutlinedButton.styleFrom(foregroundColor: kprimaryColor),
              child: const Text('Assign'),
            ),
          ),
          DataCell(
            OutlinedButton(
              onPressed: (o.id == null) ? null : () => onChangeStatus(o),
              style: OutlinedButton.styleFrom(foregroundColor: kprimaryColor),
              child: const Text('Change'),
            ),
          ),
        ];
      },
    );
  }
}
