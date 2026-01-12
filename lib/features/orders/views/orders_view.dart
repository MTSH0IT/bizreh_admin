import 'package:bizreh_admin/features/orders/controllers/orders_controller.dart';
import 'package:bizreh_admin/features/orders/views/widgets/assign_driver_dialog.dart';
import 'package:bizreh_admin/features/orders/views/widgets/orders_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search orders...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(onRefresh: controller.getOrders, refreshText: 'Refresh'),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final rows = controller.filteredOrders;

            return OrdersDataTable(
              rows: rows,
              onAssign: (order) async {
                await controller.loadDriversIfNeeded();
                if (context.mounted) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AssignDriverDialog(
                      controller: controller,
                      orderId: order.id ?? 0,
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
