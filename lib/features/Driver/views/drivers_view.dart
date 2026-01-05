import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/features/Driver/views/widgets/driver_form_dialog.dart';
import 'package:bizreh_admin/features/Driver/views/widgets/drivers_data_table.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriversView extends StatelessWidget {
  const DriversView({super.key});

  @override
  Widget build(BuildContext context) {
    final DriversController controller = Get.put(DriversController());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search drivers...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(context, controller),
            onRefresh: controller.getDrivers,
            addText: 'Add Driver',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final rows = controller.filteredDrivers;

            return DriversDataTable(
              rows: rows,
              isUpdatingStatus: controller.isUpdatingStatus,
              onToggleActive: (driver, isActive) {
                final id = driver.driverId;
                if (id == null) return;
                controller.changeStatus(driverId: id, isActive: isActive);
              },
              onDelete: (driver) => _confirmDelete(context, controller, driver),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(BuildContext context, DriversController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => DriverFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DriversController controller,
    DriverModel driver,
  ) async {
    final id = driver.driverId;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Driver',
      message:
          'Are you sure you want to delete "${driver.firstName ?? ''} ${driver.lastName ?? ''}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteDriver(id);
  }
}
