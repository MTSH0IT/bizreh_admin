import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class ProductsDataTable extends StatelessWidget {
  final List<ProductModel> rows;
  final ValueChanged<ProductModel>? onDetails;
  final ValueChanged<ProductModel>? onEdit;
  final ValueChanged<ProductModel>? onDelete;
  final ValueChanged<ProductModel>? onOptions;
  final bool Function(ProductModel product)? isTopSelling;
  final ValueChanged<ProductModel>? onToggleTopSelling;

  const ProductsDataTable({
    super.key,
    required this.rows,
    this.onDetails,
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
      // نستخدم عمود Actions مخصص بدل العمود الافتراضي لتقليل عرض الجدول
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
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onDetails == null
                      ? null
                      : () => onDetails!(product),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  tooltip: 'Details',
                ),
                IconButton(
                  onPressed: onOptions == null
                      ? null
                      : () => onOptions!(product),
                  icon: const Icon(Icons.tune, size: 16),
                  tooltip: 'Options',
                ),
                PopupMenuButton<String>(
                  tooltip: 'More',
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!(product);
                    }
                    if (value == 'delete' && onDelete != null) {
                      onDelete!(product);
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16, color: kprimaryColor),
                            const SizedBox(width: 8),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.more_horiz, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
