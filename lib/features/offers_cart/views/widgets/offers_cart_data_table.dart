import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model/offers_cart_model.dart';
import 'package:bizreh_admin/utils/widgets/active_switch.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OffersCartDataTable extends StatelessWidget {
  final List<OffersCartModel> rows;
  final ValueChanged<OffersCartModel>? onDetails;
  final RxBool? isUpdatingStatus;
  final ValueChanged<OffersCartModel>? onEdit;
  final ValueChanged<OffersCartModel>? onDelete;
  final ValueChanged<OffersCartModel>? onToggle;

  const OffersCartDataTable({
    super.key,
    required this.rows,
    this.onDetails,
    this.isUpdatingStatus,
    this.onEdit,
    this.onDelete,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<OffersCartModel>(
      rows: rows,
      emptyMessage: 'No offers found',
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
          label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Toggle', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (o, index) {
        final bool active = (o.isActive ?? 0) == 1;
        return [
          DataCell(DataTableTextCell(text: o.name)),
          DataCell(DataTableTextCell(text: o.arName)),
          DataCell(DataTableTextCell(text: o.price)),
          DataCell(DataTableNumberCell(number: o.quantity)),
          DataCell(DataTableNumberCell(number: o.itemsCount)),
          DataCell(
            DataTableTextCell(text: (o.isActive ?? 0) == 1 ? 'Yes' : 'No'),
          ),
          DataCell(DataTableDateCell(date: o.createdAt)),
          DataCell(
            Obx(() {
              final disabled =
                  onToggle == null || isUpdatingStatus?.value == true;
              return ActiveSwitch(
                value: active,
                disabled: disabled,
                onChanged: onToggle == null ? null : (_) => onToggle!(o),
              );
            }),
          ),
          DataCell(
            OutlinedButton(
              onPressed: onDetails == null ? null : () => onDetails!(o),
              child: const Text('View'),
            ),
          ),
        ];
      },
    );
  }
}
