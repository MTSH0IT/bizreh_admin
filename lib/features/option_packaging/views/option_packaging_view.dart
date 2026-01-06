import 'package:bizreh_admin/features/option_packaging/controllers/products_option_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model.dart';
import 'package:bizreh_admin/utils/widgets/confirm_delete_dialog.dart';
import 'package:bizreh_admin/utils/widgets/data_table_widget.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionPackagingView extends StatefulWidget {
  final ProductModel product;

  const OptionPackagingView({super.key, required this.product});

  @override
  State<OptionPackagingView> createState() => _OptionPackagingViewState();
}

class _OptionPackagingViewState extends State<OptionPackagingView> {
  late final ProductsOptionsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductsOptionsController(product: widget.product));
  }

  @override
  void dispose() {
    Get.delete<ProductsOptionsController>();
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
        constraints: const BoxConstraints(maxWidth: 950),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title ?? 'Product Options',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _openFormDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Option'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: controller.loadFromProduct,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reload'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final rows = controller.options.toList();
              // Touch the reactive list so Obx registers updates reliably
              controller.options.length;
              return DataTableWidget<Map<String, dynamic>>(
                rows: rows,
                emptyMessage: 'No options found',
                onEdit: (opt) {
                  controller.setOptionForEdit(opt);
                  _openFormDialog(context);
                },
                onDelete: (opt) => _confirmDelete(context, opt),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Arabic Name',
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
                buildCells: (opt, index) {
                  return [
                    DataCell(
                      DataTableTextCell(text: opt['option_name'] as String?),
                    ),
                    DataCell(
                      DataTableTextCell(text: opt['ar_option_name'] as String?),
                    ),
                    DataCell(
                      DataTableTextCell(text: opt['option_sku'] as String?),
                    ),
                  ];
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openFormDialog(BuildContext context) {
    final isEditing = controller.isEditing;

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Edit Option' : 'Create Option'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabeledTextField(
                  label: 'Option Name',
                  hint: 'Enter option name',
                  controller: controller.optionNameController,
                ),
                LabeledTextField(
                  label: 'Arabic Option Name',
                  hint: 'Enter Arabic option name',
                  controller: controller.arOptionNameController,
                ),
                LabeledTextField(
                  label: 'SKU',
                  hint: 'Enter option sku',
                  controller: controller.optionSkuController,
                ),
                const SizedBox(height: 12),
                FormImagePickerSection(
                  selectedImagePath: controller.mainImagePath,
                  existingImageUrl: null,
                  isEditing: false,
                  onPathSelected: controller.setImagePath,
                ),
              ],
            ),
          ),
        ),
        actions: [
          FormDialogActions(
            onCancel: () {
              controller.clearForm();
              Get.back();
            },
            onSubmit: () async {
              if (controller.isEditing) {
                final id = controller.selectedOption.value?['id'];
                if (id is int) {
                  await controller.updateOption(id);
                }
              } else {
                await controller.createOption();
              }
              if (context.mounted) {
                Get.back();
              }
            },
            isBusy: () =>
                controller.isCreating.value || controller.isUpdating.value,
            submitText: isEditing ? 'Update' : 'Create',
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Map<String, dynamic> option,
  ) async {
    final id = option['id'];
    if (id is! int) return;

    final ok = await showConfirmDeleteDialog(
      title: 'Delete Option',
      message:
          'Are you sure you want to delete "${option['option_name'] ?? '-'}"?',
      isLoading: controller.isDeleting,
    );

    if (!ok) return;
    await controller.deleteOption(id);
  }
}
