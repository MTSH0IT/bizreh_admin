import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class ProductsDataTable extends StatelessWidget {
  final List<ProductModel> rows;
  final ValueChanged<ProductModel>? onEdit;
  final ValueChanged<ProductModel>? onDelete;
  final ValueChanged<ProductModel>? onOptions;
  final bool Function(ProductModel product)? isTopSelling;
  final ValueChanged<ProductModel>? onToggleTopSelling;

  const ProductsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
    this.onOptions,
    this.isTopSelling,
    this.onToggleTopSelling,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<ProductModel>(
      rows: rows,
      emptyMessage: 'No products found',
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
          label: Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Sub Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Is Active',
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
          label: Text('Top', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (product, index) {
        final starred = isTopSelling?.call(product) == true;
        return [
          DataCell(
            DataTableImageCell(imageUrl: product.image, width: 54, height: 54),
          ),
          DataCell(DataTableTextCell(text: product.title)),
          DataCell(DataTableTextCell(text: product.arTitle)),
          DataCell(DataTableTextCell(text: product.brandName)),
          DataCell(DataTableTextCell(text: product.subCategoryName)),
          DataCell(
            DataTableTextCell(
              text: (product.isActive ?? 0) == 1 ? 'Active' : 'Inactive',
            ),
          ),
          DataCell(DataTableDateCell(date: product.createdAt)),
          DataCell(
            IconButton(
              onPressed: onToggleTopSelling == null
                  ? null
                  : () => onToggleTopSelling!(product),
              icon: Icon(
                starred ? Icons.star : Icons.star_border,
                size: 18,
                color: starred ? Colors.amber[700] : null,
              ),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: onOptions == null ? null : () => onOptions!(product),
              icon: const Icon(Icons.tune, size: 16),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
