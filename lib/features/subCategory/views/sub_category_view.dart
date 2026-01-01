import 'package:bizreh_admin/features/category/controllers/category_controller.dart';
import 'package:bizreh_admin/features/subCategory/controllers/sub_category_controler.dart';
import 'package:bizreh_admin/features/subCategory/models/sub_category_model.dart';
import 'package:bizreh_admin/features/subCategory/views/widgets/sub_category_data_table.dart';
import 'package:bizreh_admin/features/subCategory/views/widgets/sub_category_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryView extends StatelessWidget {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final SubCategoryController subController = Get.put(
      SubCategoryController(),
    );
    final CategoryController categoryController = Get.put(CategoryController());
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sub Categories',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          // شريط الكاتيجوريز في الأعلى
          Obx(() {
            final categories = categoryController.categories;
            final selectedId = subController.selectedCategoryId.value;

            if (categories.isEmpty) {
              return const Text('No categories found');
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((c) {
                  final id = c.id;
                  if (id == null) return const SizedBox.shrink();
                  final selected = id == selectedId;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c.title ?? '-'),
                      selected: selected,
                      onSelected: (_) {
                        subController.getSubCategories(id);
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          const SizedBox(height: 16),
          SearchField(
            hintText: 'Search sub categories...',
            onChanged: subController.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(context, subController),
            onRefresh: () {
              final id = subController.selectedCategoryId.value;
              if (id != 0) {
                subController.getSubCategories(id);
              }
            },
            addText: 'Add Sub Category',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (subController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final rows = subController.filteredSubCategories;

            return SubCategoryDataTable(
              rows: rows,
              onEdit: (sub) => _openEditDialog(context, sub, subController),
              onDelete: (sub) => _confirmDelete(context, sub, subController),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(
    BuildContext context,
    SubCategoryController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => SubCategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    SubCategoryModel subCategory,
    SubCategoryController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSubCategoryForEdit(subCategory),
      dialogBuilder: (_) => SubCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SubCategoryModel subCategory,
    SubCategoryController controller,
  ) async {
    final id = subCategory.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Sub Category',
      message: 'Are you sure you want to delete "${subCategory.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteSubCategory(id);
  }
}
