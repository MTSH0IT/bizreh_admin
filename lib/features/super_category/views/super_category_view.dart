import 'package:bizreh_admin/features/super_category/controllers/super_category_controller.dart';
import 'package:bizreh_admin/features/super_category/models/super_category_model.dart';
import 'package:bizreh_admin/features/super_category/views/widgets/super_category_form_dialog.dart';
import 'package:bizreh_admin/features/super_category/views/widgets/super_category_data_table.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperCategoryView extends StatelessWidget {
  const SuperCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final SuperCategoryController controller =
        Get.find<SuperCategoryController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search super categories...',
          onChanged: (v) => controller.setSearchQuery(v),
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getSuperCategories,
          addText: 'Add Super Category',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final filtered = controller.filteredSuperCategories;

          return SuperCategoryDataTable(
            rows: filtered,
            onEdit: (superCategory) =>
                _openEditDialog(context, controller, superCategory),
            onDelete: (superCategory) =>
                _confirmDelete(context, controller, superCategory),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    SuperCategoryController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => SuperCategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    SuperCategoryController controller,
    SuperCategoryModel superCategory,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSuperCategoryForEdit(superCategory),
      dialogBuilder: (_) => SuperCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SuperCategoryController controller,
    SuperCategoryModel superCategory,
  ) async {
    final id = superCategory.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Super Category',
      message:
          'Are you sure you want to delete "${superCategory.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteSuperCategory(id);
  }
}
