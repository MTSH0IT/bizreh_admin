import 'package:bizreh_admin/features/option_packaging/controllers/option_packaging_controller.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart'
    as package_model;
import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/color_dot.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionPackagingFormDialog extends StatefulWidget {
  final OptionPackagingController controller;
  final Option option;
  final package_model.PackageModel packaging;
  final int? mappingId;
  final int? initialPrice;
  final int? initialStock;
  final int? initialColorId;
  final Future<void> Function()? onSaved;

  const OptionPackagingFormDialog({
    super.key,
    required this.controller,
    required this.option,
    required this.packaging,
    this.mappingId,
    this.initialPrice,
    this.initialStock,
    this.initialColorId,
    this.onSaved,
  });

  @override
  State<OptionPackagingFormDialog> createState() =>
      _OptionPackagingFormDialogState();
}

class _OptionPackagingFormDialogState extends State<OptionPackagingFormDialog> {
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialPrice?.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.initialStock?.toString() ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentColorId = widget.initialColorId;
      if (currentColorId != null && currentColorId > 0) {
        widget.controller.setSelectedColorId(currentColorId);
      } else {
        widget.controller.setSelectedColorId(null);
      }
      if (widget.controller.colors.isEmpty &&
          !widget.controller.isColorsLoading.value) {
        widget.controller.loadColors();
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.mappingId != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Mapping' : 'Create Mapping'),
      content: SizedBox(
        width: 420,
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
            ),
            LabeledTextField(
              label: 'Stock quantity',
              hint: 'Enter stock',
              controller: _stockController,
              keyboardType: TextInputType.number,
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
                                c.name ?? c.arName ?? 'Color #${c.id!}',
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
      ),
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
                      if (widget.onSaved != null) {
                        await widget.onSaved!();
                      }
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
            final stock = int.tryParse(_stockController.text.trim());
            final selectedColorId = widget.controller.selectedColorId.value;
            final colorId = selectedColorId == 0 ? null : selectedColorId;

            if (price == null || stock == null) {
              return;
            }

            await widget.controller.saveMapping(
              mappingId: widget.mappingId,
              productOptionId: widget.option.id!,
              packagingId: widget.packaging.id!,
              pricePerUnit: price,
              stockQuantity: stock,
              colorId: colorId,
            );

            if (widget.onSaved != null) {
              await widget.onSaved!();
            }
          },
          isBusy: () => widget.controller.isSaving.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],
    );
  }
}
