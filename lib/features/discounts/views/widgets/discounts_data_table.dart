import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';

class DiscountsDataTable extends StatelessWidget {
  final List<DiscountModel> rows;
  final ValueChanged<DiscountModel>? onEdit;
  final ValueChanged<DiscountModel>? onDelete;

  const DiscountsDataTable({
    super.key,
    required this.rows,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<DiscountModel>(
      rows: rows,
      emptyMessage: 'No discounts found',
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
      ],
      buildCells: (d, index) {
        return [
          DataCell(DataTableTextCell(text: d.title)),
          DataCell(DataTableTextCell(text: d.arTitle)),
          //DataCell(DataTableTextCell(text: d.type)),
          DataCell(DataTableNumberCell(number: d.amount)),
          DataCell(DataTableTextCell(text: d.amountType)),
          DataCell(DataTableTextCell(text: d.minPurchaseAmount)),
          DataCell(DataTableDateCell(date: d.exprationDate)),
          DataCell(
            DataTableTextCell(text: (d.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableNumberCell(number: d.productsCount)),
          DataCell(DataTableNumberCell(number: d.brandsCount)),
          DataCell(DataTableNumberCell(number: d.categoriesCount)),
          DataCell(DataTableDateCell(date: d.createdAt)),
        ];
      },
    );
  }
}
