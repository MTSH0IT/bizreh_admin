import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class PackagingsDataTable extends StatelessWidget {
  final List<PackageModel> rows;
  final ValueChanged<PackageModel>? onEdit;
  final ValueChanged<PackageModel>? onDelete;

  const PackagingsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<PackageModel>(
      rows: rows,
      emptyMessage: 'No packagings found',
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
          DataCell(DataTableDateCell(date: p.createdAt)),
        ];
      },
    );
  }
}
