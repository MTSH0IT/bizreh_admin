import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class DiscountsDataTable extends StatelessWidget {
  final List<DiscountModel> rows;
  final ValueChanged<DiscountModel>? onEdit;
  final ValueChanged<DiscountModel>? onDelete;
  final ValueChanged<DiscountModel>? onDetails;

  const DiscountsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<DiscountModel>(
      rows: rows,
      emptyMessage: 'No discounts found',
      showActions: false,
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
        // DataColumn(
        //   label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
        // ),
        DataColumn(
          label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Amount Type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Min Purchase',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Min Qty', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Expires', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Brands', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Categories',
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
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (d, index) {
        return [
          DataCell(DataTableTextCell(text: d.title)),
          DataCell(DataTableTextCell(text: d.arTitle)),
          DataCell(DataTableNumberCell(number: d.amount)),
          DataCell(DataTableTextCell(text: d.amountType)),
          DataCell(DataTableTextCell(text: d.minPurchaseAmount?.toString())),
          DataCell(DataTableNumberCell(number: d.minQuantity)),
          DataCell(DataTableDateCell(date: d.expirationDate)),
          DataCell(
            DataTableTextCell(text: (d.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableNumberCell(number: d.productsCount)),
          DataCell(DataTableNumberCell(number: d.brandsCount)),
          DataCell(DataTableNumberCell(number: d.categoriesCount)),
          DataCell(DataTableDateCell(date: d.createdAt)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onDetails == null ? null : () => onDetails!(d),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  tooltip: 'Details',
                ),
                IconButton(
                  onPressed: onEdit == null ? null : () => onEdit!(d),
                  icon: const Icon(Icons.edit, size: 16),
                  color: kprimaryColor,
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete == null ? null : () => onDelete!(d),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  color: Colors.red,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
