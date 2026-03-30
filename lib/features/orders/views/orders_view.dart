import 'package:bizreh_admin/features/orders/controllers/orders_controller.dart';
import 'package:bizreh_admin/features/orders/views/widgets/orders_data_table.dart';
import 'package:bizreh_admin/features/orders/views/order_details_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/status_filter_dropdown.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  static const List<String> _statusOptions = <String>[
    'all',
    'delivered',
    'pending',
    'assigned_to_driver',
    'failed',
    'cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search orders...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: controller.getOrders,
          refreshText: 'Refresh',
          extraActions: [
            Obx(() {
              final value = controller.statusFilter.value;
              final safeValue = _statusOptions.contains(value) ? value : 'all';
              return StatusFilterDropdown(
                value: safeValue,
                items: _statusOptions
                    .map(
                      (s) => DropdownMenuItem<String>(value: s, child: Text(s)),
                    )
                    .toList(),
                onChanged: (s) {
                  if (s == null) return;
                  controller.setStatusFilter(s);
                },
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredOrders;

          return OrdersDataTable(
            rows: rows,
            // onAssign: (order) async {
            //   await controller.loadDriversIfNeeded();
            //   if (context.mounted) {
            //     showDialog<void>(
            //       context: context,
            //       builder: (_) => AssignDriverDialog(
            //         controller: controller,
            //         orderId: order.id ?? 0,
            //       ),
            //     );
            //   }
            // },
            // onChangeStatus: (order) {
            //   controller.selectedStatus.value = (order.status ?? '').trim();
            //   showDialog<void>(
            //     context: context,
            //     builder: (_) => ChangeOrderStatusDialog(
            //       controller: controller,
            //       orderId: order.id ?? 0,
            //     ),
            //   );
            // },
            onDetails: (order) {
              final nav = Get.find<MainNavController>();
              nav.push(
                MainNavEntry(
                  title: 'Order ${order.orderNumber ?? ''}',
                  page: OrderDetailsView(order: order),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
