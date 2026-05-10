import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/features/users/views/widgets/user_form_dialog.dart';
import 'package:bizreh_admin/features/users/views/widgets/users_data_table.dart';
import 'package:bizreh_admin/features/users/views/widgets/user_notification_dialog.dart';
import 'package:bizreh_admin/features/users/views/widgets/user_notification_all_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController controller = Get.find<UsersController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search users...',
          onChanged: controller.setSearchQuery,
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(controller),
          onRefresh: controller.getUsers,
          addText: 'Add User',
          refreshText: 'Refresh',
          extraActions: [
            ElevatedButton.icon(
              onPressed: () => _openNotificationDialogForAll(controller),
              icon: const Icon(Icons.notifications_active),
              label: const Text('Send message to all'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final filtered = controller.filteredUsers;

          return UsersDataTable(
            rows: filtered,
            isUpdatingStatus: controller.isUpdatingStatus,
            onToggleActive: (user, isActive) {
              final id = user.id;
              if (id == null) return;
              controller.changeStatus(userId: id, isActive: isActive);
            },
            onEdit: (user) => _openEditDialog(controller, user),
            onDelete: (user) => _confirmDelete(controller, user),
            onSendNotification: (user) {
              final id = user.id;
              if (id == null) return;
              _openNotificationDialogForUser(controller, id);
            },
          );
        }),
      ],
    );
  }

  void _openCreateDialog(UsersController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => UserFormDialog(controller: controller),
    );
  }

  void _openEditDialog(UsersController controller, UserModel user) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setUserForEdit(user),
      dialogBuilder: (_) => UserFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    UsersController controller,
    UserModel user,
  ) async {
    final id = user.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete User',
      message:
          'Are you sure you want to delete "${user.firstName ?? ''} ${user.lastName ?? ''}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteUser(id);
  }

  void _openNotificationDialogForUser(UsersController controller, int userId) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearNotificationForm,
      dialogBuilder: (_) =>
          UserNotificationDialog(controller: controller, userId: userId),
    );
  }

  void _openNotificationDialogForAll(UsersController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearNotificationForm,
      dialogBuilder: (_) => UserNotificationAllDialog(controller: controller),
    );
  }
}
