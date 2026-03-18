import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class OptionsDataTable extends StatelessWidget {
  final List<Option> rows;
  final ValueChanged<Option>? onEdit;
  final ValueChanged<Option>? onDelete;

  const OptionsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<Option>(
      rows: rows,
      emptyMessage: 'No options found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Arabic Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (opt, index) {
        return [
          DataCell(DataTableImageCell(imageUrl: opt.mainImage)),
          DataCell(DataTableTextCell(text: opt.optionName)),
          DataCell(DataTableTextCell(text: opt.arOptionName)),
        ];
      },
    );
  }
}
