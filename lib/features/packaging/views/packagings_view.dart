import 'package:bizreh_admin/features/packaging/controllers/packaging_controller.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/packaging/views/widgets/packaging_form_dialog.dart';
import 'package:bizreh_admin/features/packaging/views/widgets/packagings_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagingsView extends StatelessWidget {
  const PackagingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PackagingController controller = Get.put(PackagingController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search packagings...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getPackagings,
          addText: 'Add Packaging',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredPackagings;

          return PackagingsDataTable(
            rows: rows,
            onEdit: (p) => _openEditDialog(context, controller, p),
            onDelete: (p) => _confirmDelete(context, controller, p),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, PackagingController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => PackagingFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    PackagingController controller,
    PackageModel packaging,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setPackagingForEdit(packaging),
      dialogBuilder: (_) => PackagingFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PackagingController controller,
    PackageModel packaging,
  ) async {
    final id = packaging.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Packaging',
      message: 'Are you sure you want to delete "${packaging.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deletePackaging(id);
  }
}
