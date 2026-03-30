import 'package:bizreh_admin/features/orders/controllers/orders_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOrderStatusDialog extends StatelessWidget {
  final OrdersController controller;
  final int orderId;

  const ChangeOrderStatusDialog({
    super.key,
    required this.controller,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change order status'),
      content: SizedBox(
        width: 520,
        child: Obx(() {
          const statuses = <String>['delivered', 'failed', 'cancelled'];

          final selected = controller.selectedStatus.value.trim().isEmpty
              ? null
              : controller.selectedStatus.value;

          final items = statuses
              .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
              .toList();

          return LoadingDropdownFormField2<String>(
            isLoading: false,
            items: items,
            value: selected,
            labelText: 'Status',
            hintText: 'Select status',
            onChanged: (v) {
              controller.selectedStatus.value = v ?? '';
            },
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.selectedStatus.value = '';
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        Obx(() {
          final busy = controller.isUpdatingStatus.value;
          return ElevatedButton(
            onPressed: busy
                ? null
                : () => controller.changeStatusForOrder(orderId: orderId),
            child: busy
                ? const BuildProgressIndicator(
                    size: 18,
                    strokeWidth: 2,
                    centered: false,
                  )
                : const Text('Save'),
          );
        }),
      ],
    );
  }
}
