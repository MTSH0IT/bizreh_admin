import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class CitiesDataTable extends StatelessWidget {
  final List<CityModel> rows;
  final ValueChanged<CityModel>? onEdit;
  final ValueChanged<CityModel>? onDelete;

  const CitiesDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<CityModel>(
      rows: rows,
      emptyMessage: 'No cities found',
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
      buildCells: (c, index) {
        return [
          DataCell(DataTableTextCell(text: c.title)),
          DataCell(DataTableTextCell(text: c.arTitle)),
          DataCell(DataTableDateCell(date: c.createdAt)),
        ];
      },
    );
  }
}
