import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class SuppliersDataTable extends StatelessWidget {
  final List<SupplierModel> rows;
  final ValueChanged<SupplierModel>? onEdit;
  final ValueChanged<SupplierModel>? onDelete;

  const SuppliersDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<SupplierModel>(
      rows: rows,
      emptyMessage: 'No suppliers found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Drivers', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Total Sales',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (s, index) {
        final name = '${s.firstName ?? '-'} ${s.lastName ?? ''}'.trim();
        return [
          DataCell(DataTableTextCell(text: name)),
          DataCell(DataTableTextCell(text: s.email)),
          DataCell(DataTableTextCell(text: s.phone)),
          DataCell(DataTableTextCell(text: s.cities)),
          DataCell(DataTableNumberCell(number: s.driversCount)),
          DataCell(DataTableNumberCell(number: s.ordersCount)),
          DataCell(DataTableNumberCell(number: s.totalSales)),
          DataCell(DataTableDateCell(date: s.createdAt)),
        ];
      },
    );
  }
}
