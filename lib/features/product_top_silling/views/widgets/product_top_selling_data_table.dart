import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class ProductTopSellingDataTable extends StatelessWidget {
  final List<ProductModel> rows;
  final ValueChanged<ProductModel>? onRemove;

  const ProductTopSellingDataTable({
    super.key,
    required this.rows,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<ProductModel>(
      rows: rows,
      emptyMessage: 'No top selling products found',
      showActions: false,
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
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (product, index) {
        return [
          DataCell(
            DataTableImageCell(imageUrl: product.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: product.title)),
          DataCell(DataTableTextCell(text: product.arTitle)),
          DataCell(DataTableDateCell(date: product.createdAt)),
          DataCell(
            TextButton(
              onPressed: onRemove == null ? null : () => onRemove!(product),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
            ),
          ),
        ];
      },
    );
  }
}
