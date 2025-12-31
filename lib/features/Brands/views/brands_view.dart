import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/Brands/views/widgets/brand_form_dialog.dart';
import 'package:bizreh_admin/features/Brands/views/widgets/brands_data_table.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandsController controller = Get.put(BrandsController());
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Brands',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          SearchField(
            hintText: 'Search brands...',
            onChanged: (v) => controller.setSearchQuery(v),
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
              return const Center(child: CircularProgressIndicator());
            }

            final filtered = controller.filteredBrands;

            return BrandsDataTable(
              rows: filtered,
              onEdit: (brand) => _openEditDialog(context, controller, brand),
              onDelete: (brand) => _confirmDelete(context, controller, brand),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(BuildContext context, BrandsController controller) {
    controller.clearForm();
    showDialog<void>(
      context: context,
      builder: (_) => BrandFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    BrandsController controller,
    BrandsModel brand,
  ) {
    controller.setBrandForEdit(brand);
    showDialog<void>(
      context: context,
      builder: (_) => BrandFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BrandsController controller,
    BrandsModel brand,
  ) async {
    final id = brand.id;
    if (id == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Brand'),
          content: Text(
            'Are you sure you want to delete "${brand.title ?? '-'}"?',
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
    await controller.deleteBrand(id);
  }
}
