import 'package:bizreh_admin/features/category/models/category_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class CategoryDataTable extends StatelessWidget {
  final List<CategoryModel> rows;
  final ValueChanged<CategoryModel>? onEdit;
  final ValueChanged<CategoryModel>? onDelete;

  const CategoryDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<CategoryModel>(
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
      buildCells: (category, index) {
        return [
          DataCell(
            DataTableImageCell(imageUrl: category.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: category.title)),
          DataCell(DataTableTextCell(text: category.arTitle)),
          DataCell(DataTableNumberCell(number: category.position)),
          DataCell(DataTableDateCell(date: category.createdAt)),
        ];
      },
    );
  }
}
