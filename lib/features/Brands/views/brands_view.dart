import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/Brands/views/widgets/brands_data_table.dart';
import 'package:bizreh_admin/features/Brands/views/widgets/brand_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandsController controller = Get.find<BrandsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search brands...',
          onChanged: (v) => controller.setSearchQuery(v),
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onAdd: () => _openCreateDialog(context, controller),
          onRefresh: controller.getBrands,
          addText: 'Add Brand',
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }

          final filtered = controller.filteredBrands;

          return BrandsDataTable(
            rows: filtered,
            onEdit: (brand) => _openEditDialog(context, controller, brand),
            onDelete: (brand) => _confirmDelete(context, controller, brand),
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, BrandsController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => BrandFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    BrandsController controller,
    BrandsModel brand,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setBrandForEdit(brand),
      dialogBuilder: (_) => BrandFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BrandsController controller,
    BrandsModel brand,
  ) async {
    final id = brand.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Brand',
      message: 'Are you sure you want to delete "${brand.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteBrand(id);
  }
}
