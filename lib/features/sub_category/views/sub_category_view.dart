import 'package:bizreh_admin/features/sub_category/controllers/sub_category_controler.dart';
import 'package:bizreh_admin/features/sub_category/models/sub_category_model.dart';
import 'package:bizreh_admin/features/sub_category/views/widgets/sub_category_data_table.dart';
import 'package:bizreh_admin/features/sub_category/views/widgets/sub_category_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryView extends StatelessWidget {
  final int? categoryId;

  const SubCategoryView({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final SubCategoryController subController =
        Get.find<SubCategoryController>();

    if (categoryId != null &&
        subController.selectedCategoryId.value != categoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        subController.getSubCategories(categoryId!);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search sub categories...',
          onChanged: subController.setSearchQuery,
          initialValue: subController.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, subController),
          onRefresh: () {
            final id = categoryId;
            if (id != null) {
              subController.getSubCategories(id);
            }
          },
          addText: 'Add Sub Category',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (subController.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final rows = subController.filteredSubCategories;

          return SubCategoryDataTable(
            rows: rows,
            onEdit: (subCategory) =>
                _openEditDialog(context, subController, subCategory),
            onDelete: (subCategory) =>
                _confirmDelete(context, subController, subCategory),
          );
        }),
      ],
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
    SubCategoryController controller,
    SubCategoryModel subCategory,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSubCategoryForEdit(subCategory),
      dialogBuilder: (_) => SubCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SubCategoryController controller,
    SubCategoryModel subCategory,
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
