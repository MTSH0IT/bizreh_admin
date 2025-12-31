import 'package:bizreh_admin/features/superCategory/controllers/super_category_controller.dart';
import 'package:bizreh_admin/features/SuperCategory/models/super_category_model.dart';
import 'package:bizreh_admin/features/superCategory/views/widgets/super_category_form_dialog.dart';
import 'package:bizreh_admin/features/superCategory/views/widgets/super_category_data_table.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperCategoryView extends StatelessWidget {
  const SuperCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final SuperCategoryController controller = Get.put(
      SuperCategoryController(),
    );
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Super Categories',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          SearchField(
            hintText: 'Search super categories...',
            onChanged: (v) => controller.setSearchQuery(v),
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
              return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }

  void _openCreateDialog(
    BuildContext context,
    SuperCategoryController controller,
  ) {
    controller.clearForm();
    showDialog<void>(
      context: context,
      builder: (_) => SuperCategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    SuperCategoryController controller,
    SuperCategoryModel superCategory,
  ) {
    controller.setSuperCategoryForEdit(superCategory);
    showDialog<void>(
      context: context,
      builder: (_) => SuperCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SuperCategoryController controller,
    SuperCategoryModel superCategory,
  ) async {
    final id = superCategory.id;
    if (id == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Super Category'),
          content: Text(
            'Are you sure you want to delete "${superCategory.title ?? '-'}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isDeleting.value
                    ? null
                    : () => Navigator.of(context).pop(true),
                child: controller.isDeleting.value
                    ? const BuildProgressIndicator()
                    : const Text('Delete'),
              );
            }),
          ],
        );
      },
    );

    if (ok != true) return;
    await controller.deleteSuperCategory(id);
  }
}
