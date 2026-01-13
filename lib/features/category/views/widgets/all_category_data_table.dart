import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class AllCategoryDataTable extends StatelessWidget {
  final List<AllCategoryModel> rows;
  final ValueChanged<AllCategoryModel>? onEdit;
  final ValueChanged<AllCategoryModel>? onDelete;

  const AllCategoryDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<AllCategoryModel>(
      rows: rows,
      emptyMessage: 'No categories found',
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
            'Super Category',
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
      buildCells: (c, index) {
        final superTitle =
            c.superCategoryTitle ?? c.superCategoryArTitle ?? '-';

        return [
          DataCell(
            DataTableImageCell(
              imageUrl: c.image,
              width: 50,
              height: 50,
              borderRadius: 8,
            ),
          ),
          DataCell(DataTableTextCell(text: c.title)),
          DataCell(DataTableTextCell(text: c.arTitle)),
          DataCell(DataTableTextCell(text: superTitle)),
          DataCell(DataTableNumberCell(number: c.position)),
          DataCell(DataTableDateCell(date: c.createdAt)),
        ];
      },
    );
  }
}
