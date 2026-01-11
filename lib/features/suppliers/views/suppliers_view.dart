import 'package:bizreh_admin/features/suppliers/controllers/suppliers_controller.dart';
import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/features/suppliers/views/widgets/supplier_form_dialog.dart';
import 'package:bizreh_admin/features/suppliers/views/widgets/suppliers_data_table.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersView extends StatelessWidget {
  const SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    final SuppliersController controller = Get.put(SuppliersController());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search suppliers...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(controller),
            onRefresh: controller.getSuppliers,
            addText: 'Add Supplier',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final rows = controller.filteredSuppliers;

            return SuppliersDataTable(
              rows: rows,
              onEdit: (s) => _openEditDialog(controller, s),
              onDelete: (s) => _confirmDelete(controller, s),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(SuppliersController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => SupplierFormDialog(controller: controller),
    );
  }

  void _openEditDialog(SuppliersController controller, SupplierModel supplier) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSupplierForEdit(supplier),
      dialogBuilder: (_) => SupplierFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    SuppliersController controller,
    SupplierModel supplier,
  ) async {
    final id = supplier.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Supplier',
      message:
          'Are you sure you want to delete "${supplier.firstName ?? ''} ${supplier.lastName ?? ''}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteSupplier(id);
  }
}
