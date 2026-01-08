import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/features/product_top_silling/controllers/product_top_selling_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/products/views/widgets/products_data_table.dart';
import 'package:bizreh_admin/features/products/views/widgets/product_form_dialog.dart';
import 'package:bizreh_admin/features/option_packaging/views/option_packaging_view.dart';
import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());
    final ProductTopSellingController topSellingController = Get.put(
      ProductTopSellingController(),
    );
    final MainNavController nav = Get.find<MainNavController>();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchField(
            hintText: 'Search products...',
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 12),
          ToolbarRow(
            onAdd: () => _openCreateDialog(context, controller),
            onRefresh: controller.getProducts,
            addText: 'Add Product',
            refreshText: 'Refresh',
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const BuildProgressIndicator();
            }

            final filtered = controller.filteredProducts;

            return ProductsDataTable(
              rows: filtered,
              onEdit: (product) =>
                  _openEditDialog(context, controller, product),
              onDelete: (product) =>
                  _confirmDelete(context, controller, product),
              onOptions: (product) => _openOptionsPage(nav, product),
              isTopSelling: (p) => topSellingController.isTopSelling(p.id),
              onToggleTopSelling: (p) =>
                  _confirmToggleTopSelling(context, topSellingController, p),
            );
          }),
        ],
      ),
    );
  }

  void _openCreateDialog(BuildContext context, ProductsController controller) {
    openFormDialog<void>(
      onBeforeOpen: controller.clearForm,
      dialogBuilder: (_) => ProductFormDialog(controller: controller),
    );
  }

  void _openEditDialog(
    BuildContext context,
    ProductsController controller,
    ProductModel product,
  ) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setProductForEdit(product),
      dialogBuilder: (_) => ProductFormDialog(controller: controller),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductsController controller,
    ProductModel product,
  ) async {
    final id = product.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Product',
      message: 'Are you sure you want to delete "${product.title ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteProduct(id);
  }

  void _openOptionsPage(MainNavController nav, ProductModel product) {
    nav.push(
      MainNavEntry(
        title: product.title ?? 'product',
        page: OptionPackagingView(product: product),
      ),
    );
  }

  Future<void> _confirmToggleTopSelling(
    BuildContext context,
    ProductTopSellingController controller,
    ProductModel product,
  ) async {
    final id = product.id;
    if (id == null) return;

    final isInList = controller.isTopSelling(id);

    final ok = await showConfirmDeleteDialog(
      title: isInList ? 'Remove Top Selling' : 'Add Top Selling',
      message: isInList
          ? 'Remove "${product.title ?? '-'}" from top selling?'
          : 'Add "${product.title ?? '-'}" to top selling?',
      isLoading: isInList ? controller.isDeleting : controller.isAdding,
      confirmText: isInList ? 'Remove' : 'Add',
    );

    if (!ok) return;

    if (isInList) {
      await controller.removeTopSelling(product);
    } else {
      await controller.addTopSelling(product);
    }
  }
}
