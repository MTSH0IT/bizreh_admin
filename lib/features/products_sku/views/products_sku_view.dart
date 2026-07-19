import 'package:bizreh_admin/features/products_sku/controllers/products_sku_controller.dart';
import 'package:bizreh_admin/features/products_sku/model/products_sku/products_sku.dart';
import 'package:bizreh_admin/features/products_sku/views/widgets/sku_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/search_field.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsSkuView extends GetView<ProductsSkuController> {
  const ProductsSkuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Search product SKUs...',
          onChanged: controller.setSearchQuery,
          initialValue: controller.searchQuery.value,
        ),
        const SizedBox(height: 12),
        ToolbarRow(
          onRefresh: controller.getOptionPackagings,
          refreshText: 'Refresh',
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const BuildProgressIndicator();
          }
          return DataTableWidget<ProductsSku>(
            rows: controller.filteredOptionPackagings,
            emptyMessage: 'No product SKUs found',
            showActions: true,
            onEdit: (item) => _openEditDialog(controller, item),
            columns: const [
              DataColumn(
                label: Text(
                  'Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Option Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Packaging Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Color',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'SKU',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            buildCells: (item, index) {
              return [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.product?.title ?? ''),

                      Text(
                        item.product?.arTitle ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.productOption?.optionName ?? ''),
                      Text(
                        item.productOption?.arOptionName ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.packaging?.title ?? ''),
                      Text(
                        item.packaging?.arTitle ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.color?.name ?? ''),
                      Text(
                        item.color?.arName ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(DataTableTextCell(text: item.optionSku)),
              ];
            },
          );
        }),
      ],
    );
  }

  void _openEditDialog(ProductsSkuController controller, ProductsSku item) {
    openFormDialog<void>(
      onBeforeOpen: () => controller.setSkuForEdit(item),
      dialogBuilder: (_) => SkuFormDialog(controller: controller),
    );
  }
}
