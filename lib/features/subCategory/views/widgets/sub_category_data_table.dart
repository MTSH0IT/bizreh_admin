import 'package:bizreh_admin/features/subCategory/models/sub_category_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class SubCategoryDataTable extends StatelessWidget {
  final List<SubCategoryModel> rows;
  final ValueChanged<SubCategoryModel>? onEdit;
  final ValueChanged<SubCategoryModel>? onDelete;

  const SubCategoryDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<SubCategoryModel>(
      rows: rows,
      emptyMessage: 'No sub categories found',
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
          label: Text(
            'Position',
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
      buildCells: (sub, index) {
        return [
          DataCell(
            DataTableImageCell(imageUrl: sub.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: sub.title)),
          DataCell(DataTableTextCell(text: sub.arTitle)),
          DataCell(DataTableNumberCell(number: sub.position)),
          DataCell(DataTableDateCell(date: sub.createdAt)),
        ];
      },
    );
  }
}
