import 'package:bizreh_admin/features/color_family/controllers/color_family_controller.dart';
import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/features/color_family/views/widgets/color_family_data_table.dart';
import 'package:bizreh_admin/features/color_family/views/widgets/color_family_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorFamilyView extends StatelessWidget {
  const ColorFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorFamilyController controller = Get.put(ColorFamilyController());

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search colors...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(controller),
            onRefresh: controller.getColors,
            addText: 'Add Color',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final rows = controller.filteredColors;

            return ColorFamilyDataTable(
              rows: rows,
              onEdit: (c) => _openEditDialog(controller, c),
              onDelete: (c) => _confirmDelete(controller, c),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(ColorFamilyController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => ColorFamilyFormDialog(controller: controller),
    );
  }

  void _openEditDialog(ColorFamilyController controller, ColorModel model) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setColorForEdit(model),
      dialogBuilder: (_) => ColorFamilyFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    ColorFamilyController controller,
    ColorModel model,
  ) async {
    final id = model.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Color',
      message: 'Are you sure you want to delete "${model.name ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteColor(id);
  }
}
