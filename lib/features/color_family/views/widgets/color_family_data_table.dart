import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/widgets/color_dot.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class ColorFamilyDataTable extends StatelessWidget {
  final List<ColorModel> rows;
  final ValueChanged<ColorModel>? onEdit;
  final ValueChanged<ColorModel>? onDelete;

  const ColorFamilyDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<ColorModel>(
      rows: rows,
      emptyMessage: 'No colors found',
      onEdit: onEdit,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Arabic Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Degree', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (c, index) {
        return [
          DataCell(DataTableTextCell(text: c.name)),
          DataCell(DataTableTextCell(text: c.arName)),
          DataCell(
            ColorDot(color: parseColorDegree(c.colorDegree), selected: false),
          ),
          DataCell(DataTableDateCell(date: c.createdAt)),
        ];
      },
    );
  }
}
