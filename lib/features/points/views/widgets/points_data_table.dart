import 'package:bizreh_admin/features/points/models/point_model/point_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class PointsDataTable extends StatelessWidget {
  final List<PointModel> rows;
  final ValueChanged<PointModel>? onEdit;
  final ValueChanged<PointModel>? onDelete;

  const PointsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<PointModel>(
      rows: rows,
      emptyMessage: 'No points offers found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Arabic Title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Points Amount',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Amount Type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Min Purchase',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Max / User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Expires', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Brands', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Categories',
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
      buildCells: (p, index) {
        return [
          DataCell(DataTableTextCell(text: p.title)),
          DataCell(DataTableTextCell(text: p.arTitle)),
          DataCell(DataTableTextCell(text: p.type)),
          DataCell(DataTableNumberCell(number: p.pointsAmount)),
          DataCell(DataTableTextCell(text: p.amountType)),
          DataCell(DataTableTextCell(text: p.minPurchaseAmount)),
          DataCell(DataTableNumberCell(number: p.maxPointsPerUser)),
          DataCell(DataTableDateCell(date: p.exprationDate)),
          DataCell(
            DataTableTextCell(text: (p.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableNumberCell(number: p.productsCount)),
          DataCell(DataTableNumberCell(number: p.brandsCount)),
          DataCell(DataTableNumberCell(number: p.categoriesCount)),
          DataCell(DataTableDateCell(date: p.createdAt)),
        ];
      },
    );
  }
}
