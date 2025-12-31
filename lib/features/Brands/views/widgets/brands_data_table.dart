import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class BrandsDataTable extends StatelessWidget {
  final List<BrandsModel> rows;
  final ValueChanged<BrandsModel>? onEdit;
  final ValueChanged<BrandsModel>? onDelete;

  const BrandsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<BrandsModel>(
      rows: rows,
      emptyMessage: 'No brands found',
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
            'Products',
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
      buildCells: (brand, index) {
        return [
          DataCell(
            DataTableImageCell(imageUrl: brand.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: brand.title)),
          DataCell(DataTableTextCell(text: brand.arTitle)),
          DataCell(DataTableNumberCell(number: brand.position)),
          DataCell(DataTableNumberCell(number: brand.productsCount)),
          DataCell(DataTableDateCell(date: brand.createdAt)),
        ];
      },
    );
  }
}
