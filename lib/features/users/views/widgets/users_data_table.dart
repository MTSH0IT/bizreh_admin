import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/features/points/views/user_points_balance_view.dart';
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
      showActions: true,
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
          label: Text('Points', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ElevatedButton.icon(
              onPressed: () {
                final userId = user.id;
                if (userId == null) return;
                Get.find<MainNavController>().push(
                  MainNavEntry(
                    title: 'Points Details : $name',
                    page: UserPointsBalanceView(userId: userId),
                  ),
                );
              },
              icon: const Icon(Icons.stars_rounded, size: 16),
              label: const Text('Points details'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
