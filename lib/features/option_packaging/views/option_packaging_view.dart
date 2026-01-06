import 'package:bizreh_admin/features/option_packaging/controllers/option_packaging_controller.dart';
import 'package:bizreh_admin/features/option_packaging/controllers/product_options_controller.dart';
import 'package:bizreh_admin/features/packaging/controllers/packaging_controller.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart'
    as packageModel;
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/toolbar_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/option_form_dialog.dart';
import 'widgets/options_data_table.dart';
import 'widgets/option_packaging_form_dialog.dart';
import 'widgets/options_packaging_matrix_table.dart';

class OptionPackagingView extends StatefulWidget {
  final ProductModel product;

  const OptionPackagingView({super.key, required this.product});

  @override
  State<OptionPackagingView> createState() => _OptionPackagingViewState();
}

class _OptionPackagingViewState extends State<OptionPackagingView> {
  late final ProductOptionsController optionsController;
  late final PackagingController packagingController;
  late final OptionPackagingController optionPackagingController;

  String get _optionsTag => 'product_options_${widget.product.id ?? 0}';

  @override
  void initState() {
    super.initState();

    optionsController = Get.put(
      ProductOptionsController(product: widget.product),
      tag: _optionsTag,
    );

    if (Get.isRegistered<PackagingController>()) {
      packagingController = Get.find<PackagingController>();
    } else {
      packagingController = Get.put(PackagingController());
    }

    optionPackagingController = Get.put(OptionPackagingController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<ProductOptionsController>(tag: _optionsTag)) {
      Get.delete<ProductOptionsController>(tag: _optionsTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ToolbarRow(
              onAdd: () => _openOptionFormDialog(context),
              onRefresh: () async {
                optionsController.loadFromProduct();
                await optionsController.reloadFromServer();
                await packagingController.getPackagings();
              },
              addText: 'Add Option',
              refreshText: 'Reload',
            ),
            const SizedBox(height: 16),
            Obx(() {
              final rows = optionsController.options.toList();
              optionsController.options.length;

              return OptionsDataTable(
                rows: rows,
                onEdit: (opt) {
                  optionsController.setOptionForEdit(opt);
                  _openOptionFormDialog(context);
                },
                onDelete: (opt) => _confirmDelete(context, opt),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Option × Packaging Matrix',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (packagingController.isLoading.value ||
                  optionsController.isReloading.value) {
                return const BuildProgressIndicator();
              }

              final options = optionsController.options.toList();
              final packagings = packagingController.packagings.toList();

              return OptionsPackagingMatrixTable(
                options: options,
                packagings: packagings,
                onCellTap:
                    (
                      Option opt,
                      packageModel.PackageModel pkg,
                      int? mappingId,
                      int? price,
                      int? stock,
                    ) {
                      _openMatrixCellDialog(
                        context,
                        opt,
                        pkg,
                        mappingId,
                        price,
                        stock,
                      );
                    },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openOptionFormDialog(BuildContext context) {
    openFormDialog<void>(
      onBeforeOpen: () {},
      dialogBuilder: (_) => OptionFormDialog(controller: optionsController),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Option option) async {
    final id = option.id;
    if (id == null) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Option',
      message: 'Are you sure you want to delete "${option.optionName ?? '-'}"?',
      isLoading: optionsController.isDeleting,
    );

    if (!ok) return;
    await optionsController.deleteOption(id);
  }

  Future<void> _openMatrixCellDialog(
    BuildContext context,
    Option option,
    packageModel.PackageModel packaging,
    int? mappingId,
    int? currentPrice,
    int? currentStock,
  ) async {
    openFormDialog<void>(
      dialogBuilder: (_) => OptionPackagingFormDialog(
        controller: optionPackagingController,
        option: option,
        packaging: packaging,
        mappingId: mappingId,
        initialPrice: currentPrice,
        initialStock: currentStock,
        onSaved: () async {
          await optionsController.reloadFromServer();
        },
      ),
    );
  }
}
