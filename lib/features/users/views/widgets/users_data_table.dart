import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/features/points/views/user_points_history_view.dart';
import 'package:bizreh_admin/features/payment/views/user_payments_and_orders_view.dart';
import 'package:bizreh_admin/features/payment/views/user_payments_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/utils/widgets/active_switch.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersDataTable extends StatelessWidget {
  final List<UserModel> rows;
  final RxBool? isUpdatingStatus;
  final void Function(UserModel user, int isActive)? onToggleActive;
  final ValueChanged<UserModel>? onEdit;
  final ValueChanged<UserModel>? onDelete;
  final ValueChanged<UserModel>? onSendNotification;

  const UsersDataTable({
    super.key,
    required this.rows,
    this.isUpdatingStatus,
    this.onToggleActive,
    this.onEdit,
    this.onDelete,
    this.onSendNotification,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableWidget<UserModel>(
      rows: rows,
      emptyMessage: 'No users found',
      showActions: false, // We use custom actions column
      onEdit: onEdit,
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
          label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
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
          label: Text(
            'Notification',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      buildCells: (user, index) {
        final name = '${user.firstName ?? '-'} ${user.lastName ?? ''}'.trim();
        final bool active = (user.isActive ?? 0) == 1;

        return [
          DataCell(DataTableTextCell(text: name)),
          DataCell(DataTableTextCell(text: user.email)),
          DataCell(DataTableTextCell(text: user.phone)),
          DataCell(DataTableTextCell(text: user.userType)),
          DataCell(
            Obx(() {
              final disabled = isUpdatingStatus?.value == true;
              return ActiveSwitch(
                value: active,
                disabled: disabled,
                onChanged: (v) => onToggleActive?.call(user, v ? 1 : 0),
              );
            }),
          ),
          DataCell(DataTableDateCell(date: user.createdAt)),
          DataCell(
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.grey,
              tooltip: 'Send notification',
              onPressed: onSendNotification == null
                  ? null
                  : () => onSendNotification!(user),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(
                    onPressed: () => onEdit!(user),
                    icon: const Icon(Icons.edit, size: 16),
                    tooltip: 'Edit',
                    color: Colors.blue,
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: () => onDelete!(user),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    tooltip: 'Delete',
                    color: Colors.red,
                  ),
                PopupMenuButton<String>(
                  tooltip: 'More',
                  onSelected: (value) {
                    final userId = user.id;
                    if (userId == null) return;

                    if (value == 'points') {
                      Get.find<MainNavController>().push(
                        MainNavEntry(
                          title: 'Points Details : $name',
                          page: UserPointsHistoryView(userId: userId),
                        ),
                      );
                    } else if (value == 'payments') {
                      Get.find<MainNavController>().push(
                        MainNavEntry(
                          title: 'Payments : $name',
                          page: UserPaymentsView(
                            userId: userId,
                            userName: name,
                          ),
                        ),
                      );
                    } else if (value == 'payments_orders') {
                      Get.find<MainNavController>().push(
                        MainNavEntry(
                          title: 'Payments & Orders : $name',
                          page: UserPaymentsAndOrdersView(
                            userId: userId,
                            userName: name,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'points',
                      child: Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 8),
                          Text('Points details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'payments',
                      child: Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text('Payments'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'payments_orders',
                      child: Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 8),
                          Text('Payments & Orders'),
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
