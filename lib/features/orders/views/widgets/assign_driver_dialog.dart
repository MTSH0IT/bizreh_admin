import 'package:bizreh_admin/features/orders/controllers/orders_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignDriverDialog extends StatelessWidget {
  final OrdersController controller;
  final int orderId;

  const AssignDriverDialog({
    super.key,
    required this.controller,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign driver'),
      content: SizedBox(
        width: 520,
        child: Obx(() {
          final loading = controller.isDriversLoading.value;
          final items = controller.drivers.where((d) => d.driverId != null).map(
            (d) {
              final name = '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();
              final text = name.isEmpty ? 'Driver #${d.driverId!}' : name;
              return DropdownMenuItem<int>(
                value: d.driverId!,
                child: Text(text),
              );
            },
          ).toList();

          final selected = controller.selectedDriverId.value == 0
              ? null
              : controller.selectedDriverId.value;

          return LoadingDropdownFormField2<int>(
            isLoading: loading,
            items: items,
            value: selected,
            labelText: 'Driver',
            hintText: 'Select driver',
            enableSearch: true,
            searchHintText: 'Search driver...',
            onChanged: (v) {
              controller.selectedDriverId.value = v ?? 0;
            },
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.selectedDriverId.value = 0;
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        Obx(() {
          final busy = controller.isAssigning.value;
          return ElevatedButton(
            onPressed: busy
                ? null
                : () async {
                    await controller.assignDriverToOrder(orderId: orderId);
                  },
            child: busy
                ? const BuildProgressIndicator(
                    size: 18,
                    strokeWidth: 2,
                    centered: false,
                  )
                : const Text('Assign'),
          );
        }),
      ],
    );
  }
}
