import 'package:bizreh_admin/features/gifts/models/gifts_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class GiftsDataTable extends StatelessWidget {
  final List<GiftsModel> rows;
  final ValueChanged<GiftsModel>? onEdit;
  final ValueChanged<GiftsModel>? onDelete;

  const GiftsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<GiftsModel>(
      rows: rows,
      emptyMessage: 'No gifts found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
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
          label: Text('Points', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Redemptions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Available',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (g, index) {
        return [
          DataCell(
            DataTableImageCell(imageUrl: g.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: g.title)),
          DataCell(DataTableTextCell(text: g.arTitle)),
          DataCell(DataTableNumberCell(number: g.points)),
          DataCell(
            DataTableTextCell(text: (g.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableNumberCell(number: g.totalRedemptions)),
          // DataCell(
          //   DataTableTextCell(text: (g.isAvailable ?? false) ? 'Yes' : 'No'),
          // ),
          DataCell(DataTableDateCell(date: g.createdAt)),
        ];
      },
    );
  }
}
