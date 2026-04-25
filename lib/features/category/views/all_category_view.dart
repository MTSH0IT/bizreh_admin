import 'package:bizreh_admin/features/category/views/widgets/all_category_data_table.dart';
import 'package:bizreh_admin/features/category/controllers/all_category_crud_controller.dart';
import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/category/views/widgets/all_category_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoryView extends StatelessWidget {
  const AllCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AllCategoryCrudController controller = Get.put(
      AllCategoryCrudController(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search categories...',
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getAllCategories,
          addText: 'Add Category',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = controller.filteredAllCategories;

          return AllCategoryDataTable(
            rows: rows,
            onEdit: (category) =>
                _openEditDialog(context, controller, category),
            onDelete: (category) =>
                _confirmDelete(context, controller, category),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    AllCategoryCrudController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.clearForm();
        controller.getSuperCategories();
      },
      dialogBuilder: (_) => AllCategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    AllCategoryCrudController controller,
    AllCategoryModel category,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () {
        controller.setCategoryForEdit(category);
        controller.getSuperCategories();
      },
      dialogBuilder: (_) => AllCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AllCategoryCrudController controller,
    AllCategoryModel category,
  ) async {
    final id = category.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Category',
      message: 'Are you sure you want to delete "${category.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteCategory(id);
  }
}
