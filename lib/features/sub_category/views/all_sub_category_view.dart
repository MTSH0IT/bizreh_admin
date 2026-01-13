import 'package:bizreh_admin/features/sub_category/views/widgets/all_sub_category_data_table.dart';
import 'package:bizreh_admin/features/sub_category/controllers/all_sub_category_crud_controller.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/features/sub_category/views/widgets/all_sub_category_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSubCategoryView extends StatelessWidget {
  const AllSubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final AllSubCategoryCrudController subController = Get.put(
      AllSubCategoryCrudController(),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search sub categories... ',
            onChanged: subController.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(context, subController),
            onRefresh: () {
              subController.getAllSubCategories();
            },
            addText: 'Add Sub Category',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (subController.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final rows = subController.filteredAllSubCategories;

            return AllSubCategoryDataTable(
              rows: rows,
              onEdit: (subCategory) =>
                  _openEditDialog(context, subController, subCategory),
              onDelete: (subCategory) =>
                  _confirmDelete(context, subController, subCategory),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(
    BuildContext context,
    AllSubCategoryCrudController controller,
  ) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => AllSubCategoryFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    AllSubCategoryCrudController controller,
    AllSubCategoryModel subCategory,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSubCategoryForEdit(subCategory),
      dialogBuilder: (_) => AllSubCategoryFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AllSubCategoryCrudController controller,
    AllSubCategoryModel subCategory,
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

//impl all sub category view
