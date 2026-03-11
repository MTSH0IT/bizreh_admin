import 'package:bizreh_admin/features/points/models/point_model.dart';
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
          label: Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Packaging',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Points/Unit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Min Qty', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('End', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
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
          DataCell(DataTableTextCell(text: p.brandTitle ?? p.brandArTitle)),
          DataCell(
            DataTableTextCell(text: p.packagingTitle ?? p.packagingArTitle),
          ),
          DataCell(DataTableNumberCell(number: p.pointsPerUnit)),
          DataCell(DataTableNumberCell(number: p.minQuantity)),
          DataCell(DataTableDateCell(date: p.startDate)),
          DataCell(DataTableDateCell(date: p.endDate)),
          DataCell(
            DataTableTextCell(text: (p.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableDateCell(date: p.createdAt)),
        ];
      },
    );
  }
}
