import 'package:bizreh_admin/features/orders/models/order_model/order_model.dart';
import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/func/status_color.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class OrdersDataTable extends StatelessWidget {
  final List<OrderModel> rows;
  //final ValueChanged<OrderModel> onAssign;
  final ValueChanged<OrderModel> onChangeStatus;
  final ValueChanged<OrderModel> onDetails;

  const OrdersDataTable({
    super.key,
    required this.rows,
    //required this.onAssign,
    required this.onChangeStatus,
    required this.onDetails,
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
          label: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
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
        // DataColumn(
        //   label: Text('Assign', style: TextStyle(fontWeight: FontWeight.bold)),
        // ),
        DataColumn(
          label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
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
          DataCell(
            DataTableTextCell(
              text: o.financialSummary?.total?.toStringAsFixed(2),
            ),
          ),
          DataCell(DataTableNumberCell(number: o.totalItemsCount)),
          DataCell(
            DataTableTextCell(
              text: o.status,
              style: TextStyle(color: getOrderStatusColor(o.status ?? "")),
            ),
          ),
          DataCell(
            DataTableTextCell(
              text: o.paymentStatus,
              style: TextStyle(
                color: getPaymentStatusColor(o.paymentStatus ?? ""),
              ),
            ),
          ),
          DataCell(DataTableTextCell(text: driverText)),
          DataCell(DataTableDateCell(date: o.createdAt)),
          // DataCell(
          //   OutlinedButton(
          //     onPressed: (o.id == null) ? null : () => onAssign(o),
          //     style: OutlinedButton.styleFrom(foregroundColor: kprimaryColor),
          //     child: const Text('Assign'),
          //   ),
          // ),
          DataCell(
            OutlinedButton(
              onPressed: (o.id == null) ? null : () => onChangeStatus(o),
              style: OutlinedButton.styleFrom(foregroundColor: kprimaryColor),
              child: const Text('Change'),
            ),
          ),
          DataCell(
            OutlinedButton(
              onPressed: (o.id == null) ? null : () => onDetails(o),
              style: OutlinedButton.styleFrom(foregroundColor: kprimaryColor),
              child: const Text('View'),
            ),
          ),
        ];
      },
    );
  }
}
