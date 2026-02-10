import 'package:bizreh_admin/features/ads/models/ads_model.dart';
import 'package:bizreh_admin/utils/widgets/active_switch.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsDataTable extends StatelessWidget {
  final List<AdsModel> rows;
  final RxBool? isUpdatingStatus;
  final void Function(AdsModel ad, int isActive)? onToggleActive;
  final ValueChanged<AdsModel>? onEdit;
  final ValueChanged<AdsModel>? onDelete;

  const AdsDataTable({
    super.key,
    required this.rows,
    this.isUpdatingStatus,
    this.onToggleActive,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<AdsModel>(
      rows: rows,
      emptyMessage: 'No ads found',
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
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Arabic Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Product ID',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
        DataColumn(
          label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
        ),

        DataColumn(
          label: Text(
            'Created At',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      buildCells: (ad, index) {
        final active = (ad.isActive ?? 0) == 1;

        return [
          DataCell(DataTableImageCell(imageUrl: ad.image)),
          DataCell(DataTableTextCell(text: ad.title)),
          DataCell(DataTableTextCell(text: ad.arTitle)),
          DataCell(DataTableTextCell(text: ad.description)),
          DataCell(DataTableTextCell(text: ad.arDescription)),
          // DataCell(DataTableNumberCell(number: ad.productId)),
          DataCell(
            Obx(() {
              final disabled = isUpdatingStatus?.value == true;
              return ActiveSwitch(
                value: active,
                disabled: disabled,
                onChanged: (v) => onToggleActive?.call(ad, v ? 1 : 0),
              );
            }),
          ),
          DataCell(DataTableDateCell(date: ad.createdAt)),
        ];
      },
    );
  }
}
