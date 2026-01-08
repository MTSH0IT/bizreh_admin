import 'package:bizreh_admin/features/product_top_silling/controllers/product_top_selling_controller.dart';
import 'package:bizreh_admin/features/product_top_silling/views/widgets/product_top_selling_data_table.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTopSellingView extends StatelessWidget {
  const ProductTopSellingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductTopSellingController controller = Get.put(
      ProductTopSellingController(),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search top selling products...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onRefresh: controller.getTopSellingProducts,
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final rows = controller.filteredProducts;

            return ProductTopSellingDataTable(
              rows: rows,
              onRemove: (product) =>
                  _confirmRemove(context, controller, product),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    ProductTopSellingController controller,
    ProductModel product,
  ) async {
    final id = product.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Remove Top Selling',
      message:
          'Are you sure you want to remove "${product.title ?? '-'}" from top selling?',
      isLoading: controller.isDeleting,
      confirmText: 'Remove',
    );

    if (!ok) return;
    await controller.removeTopSelling(product);
  }
}
