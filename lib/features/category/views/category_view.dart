import 'package:bizreh_admin/features/category/controllers/category_controller.dart';
import 'package:bizreh_admin/features/category/models/category_model.dart';
import 'package:bizreh_admin/features/category/views/widgets/category_data_table.dart';
import 'package:bizreh_admin/features/category/views/widgets/category_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  final int? superCategoryId;

  const CategoryView({super.key, this.superCategoryId});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    if (superCategoryId != null &&
        categoryController.selectedSuperCategoryId.value != superCategoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        categoryController.getCategories(superCategoryId!);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search categories...',
          onChanged: categoryController.setSearchQuery,
          initialValue: categoryController.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, categoryController),
          onRefresh: () {
            final id = superCategoryId;
            if (id != null) {
              categoryController.getCategories(id);
            }
          },
          addText: 'Add Category',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (categoryController.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = categoryController.filteredCategories;

          return CategoryDataTable(
            rows: rows,
            onEdit: (category) =>
                _openEditDialog(context, category, categoryController),
            onDelete: (category) =>
                _confirmDelete(context, category, categoryController),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, CategoryController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => CategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    CategoryModel category,
    CategoryController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setCategoryForEdit(category),
      dialogBuilder: (_) => CategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryModel category,
    CategoryController controller,
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
