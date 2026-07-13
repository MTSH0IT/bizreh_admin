import 'package:bizreh_admin/features/option_packaging/controllers/option_packaging_controller.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/color_dot.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OptionPackagingFormDialog extends StatefulWidget {
  final OptionPackagingController controller;
  final Option option;
  final PackageModel packaging;
  final int? mappingId;
  final num? initialPrice;
  // final int? initialStock;
  final int? initialColorId;
  final String? initialSku;

  const OptionPackagingFormDialog({
    super.key,
    required this.controller,
    required this.option,
    required this.packaging,
    this.mappingId,
    this.initialPrice,
    // this.initialStock,
    this.initialColorId,
    this.initialSku,
  });

  @override
  State<OptionPackagingFormDialog> createState() =>
      _OptionPackagingFormDialogState();
}

class _OptionPackagingFormDialogState extends State<OptionPackagingFormDialog> {
  late final TextEditingController _priceController;
  // late final TextEditingController _stockController;
  late final TextEditingController _skuController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialPrice?.toString() ?? '',
    );
    // _stockController = TextEditingController(
    //   text: widget.initialStock?.toString() ?? '',
    // );
    _skuController = TextEditingController(text: widget.initialSku ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentColorId = widget.initialColorId;
      widget.controller.setSelectedColorId(currentColorId);
      if (!widget.controller.isColorsLoading.value) {
        widget.controller.loadColorsIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    // _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.mappingId != null;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Mapping' : 'Create Mapping'),
      actions: [
        if (isEditing)
          Obx(() {
            return TextButton(
              onPressed: widget.controller.isDeleting.value
                  ? null
                  : () async {
                      final id = widget.mappingId;
                      if (id == null) return;
                      await widget.controller.deleteMapping(id);
                    },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: widget.controller.isDeleting.value
                  ? const BuildProgressIndicator(
                      size: 16,
                      strokeWidth: 2,
                      centered: false,
                    )
                  : const Text('Delete'),
            );
          }),
        FormDialogActions(
          onCancel: () {
            Get.back();
          },
          onSubmit: () async {
            final price = num.tryParse(_priceController.text.trim());
            // final stock = int.tryParse(_stockController.text.trim());
            final sku = _skuController.text.trim();
            final selectedColorId = widget.controller.selectedColorId.value;
            final colorId = selectedColorId == 0 ? null : selectedColorId;

            await widget.controller.saveMapping(
              mappingId: widget.mappingId,
              productOptionId: widget.option.id!,
              packagingId: widget.packaging.id!,
              pricePerUnit: price,
              // stockQuantity: stock,
              optionSku: sku,
              colorId: colorId,
            );
          },
          isBusy: () => widget.controller.isSaving.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Option: ${widget.option.optionName ?? '-'}'),
          Text('Packaging: ${widget.packaging.title ?? '-'}'),
          const SizedBox(height: 12),
          LabeledTextField(
            label: 'Price per unit',
            hint: 'Enter price',
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
          ),
          // LabeledTextField(
          //   label: 'Stock quantity',
          //   hint: 'Enter stock',
          //   controller: _stockController,
          //   keyboardType: TextInputType.number,
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          // ),
          LabeledTextField(
            label: 'SKU',
            hint: 'Enter sku',
            controller: _skuController,
          ),
          const SizedBox(height: 12),
          Obx(() {
            final loading = widget.controller.isColorsLoading.value;
            final items = <DropdownMenuItem<int>>[
              const DropdownMenuItem(value: null, child: Text('No color')),
              ...widget.controller.colors
                  .where((c) => c.id != null)
                  .map(
                    (c) => DropdownMenuItem<int>(
                      value: c.id!,
                      child: Row(
                        children: [
                          ColorDot(
                            size: 18,
                            color: parseColorDegree(c.colorDegree),
                            selected: false,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              c.name ?? 'Color #${c.id!}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ];

            final selected = widget.controller.selectedColorId.value;

            return LoadingDropdownFormField2<int>(
              isLoading: loading,
              items: items,
              value: selected,
              labelText: 'Color',
              hintText: 'Select color',
              enableSearch: true,
              searchHintText: 'Search color...',
              onChanged: (v) {
                widget.controller.setSelectedColorId(v);
              },
            );
          }),
        ],
      ),
    );
  }
}
