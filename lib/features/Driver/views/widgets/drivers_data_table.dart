import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriversDataTable extends StatelessWidget {
  final List<DriverModel> rows;
  final RxBool? isUpdatingStatus;
  final void Function(DriverModel driver, int isActive)? onToggleActive;
  final ValueChanged<DriverModel>? onDelete;

  const DriversDataTable({
    super.key,
    required this.rows,
    this.isUpdatingStatus,
    this.onToggleActive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<DriverModel>(
      rows: rows,
      emptyMessage: 'No drivers found',
      showActions: true,
      onEdit: null,
      onDelete: onDelete,
      columns: const [
        DataColumn(
          label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('License', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        // DataColumn(
        //   label: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
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
      buildCells: (driver, index) {
        final name = '${driver.firstName ?? '-'} ${driver.lastName ?? ''}'
            .trim();
        final bool active = (driver.isActive ?? 0) == 1;

        return [
          DataCell(DataTableTextCell(text: name)),
          DataCell(DataTableTextCell(text: driver.email)),
          DataCell(DataTableTextCell(text: driver.phone)),
          DataCell(DataTableTextCell(text: driver.vehicleNumber)),
          DataCell(DataTableTextCell(text: driver.licenseNumber)),
          //DataCell(DataTableNumberCell(number: driver.ordersCount)),
          DataCell(
            Obx(() {
              final disabled = isUpdatingStatus?.value == true;
              return Switch(
                value: active,
                onChanged: disabled
                    ? null
                    : (v) => onToggleActive?.call(driver, v ? 1 : 0),
              );
            }),
          ),
          DataCell(DataTableDateCell(date: driver.createdAt)),
        ];
      },
    );
  }
}
