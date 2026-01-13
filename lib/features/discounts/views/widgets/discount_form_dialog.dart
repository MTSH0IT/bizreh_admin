import 'package:bizreh_admin/features/discounts/controllers/discounts_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:bizreh_admin/utils/widgets/loading_multi_select_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountFormDialog extends StatelessWidget {
  final DiscountsController controller;

  const DiscountFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Discount' : 'Create Discount'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic title',
                controller: controller.arTitleController,
              ),
              LabeledTextField(
                label: 'Amount',
                hint: 'Enter amount',
                controller: controller.amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Obx(() {
                return LoadingDropdownFormField2<String>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed')),
                    DropdownMenuItem(
                      value: 'percentage',
                      child: Text('Percentage'),
                    ),
                  ],
                  value: controller.selectedAmountType.value,
                  onChanged: controller.setAmountType,
                  labelText: 'Amount Type',
                  hintText: 'Select amount type',
                );
              }),
              const SizedBox(height: 12),
              LabeledTextField(
                label: 'Min Purchase Amount',
                hint: 'Enter min purchase amount',
                controller: controller.minPurchaseAmountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.expirationDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Expiration Date',
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 2),
                  );
                  if (picked != null) {
                    controller.expirationDateController.text = picked
                        .toIso8601String()
                        .split('T')
                        .first;
                  }
                },
              ),
              const SizedBox(height: 12),
              Obx(() {
                return LoadingDropdownFormField2<int>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Active')),
                    DropdownMenuItem(value: 0, child: Text('Inactive')),
                  ],
                  value: controller.selectedIsActive.value,
                  onChanged: controller.setIsActive,
                  labelText: 'Status',
                  hintText: 'Select status',
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.products
                    .where((p) => p.id != null)
                    .map(
                      (p) => DropdownMenuItem<int>(
                        value: p.id,
                        child: Text(
                          p.title?.isNotEmpty == true
                              ? p.title!
                              : p.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingMultiSelectDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  values: controller.selectedProductIds.toList(),
                  onChanged: controller.setSelectedProducts,
                  labelText: 'Products',
                  hintText: 'Select products',
                  enableSearch: true,
                  searchHintText: 'Search products...',
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.brands
                    .where((b) => b.id != null)
                    .map(
                      (b) => DropdownMenuItem<int>(
                        value: b.id,
                        child: Text(
                          b.title?.isNotEmpty == true
                              ? b.title!
                              : b.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingMultiSelectDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  values: controller.selectedBrandIds.toList(),
                  onChanged: controller.setSelectedBrands,
                  labelText: 'Brands',
                  hintText: 'Select brands',
                  enableSearch: true,
                  searchHintText: 'Search brands...',
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.categories
                    .where((c) => c.id != null)
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(
                          c.title?.isNotEmpty == true
                              ? c.title!
                              : c.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingMultiSelectDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  values: controller.selectedMainCategoryIds.toList(),
                  onChanged: controller.setSelectedMainCategories,
                  labelText: 'Categories (Main)',
                  hintText: 'Select categories',
                  enableSearch: true,
                  searchHintText: 'Search categories...',
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.subCategories
                    .where((c) => c.id != null)
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(
                          c.title?.isNotEmpty == true
                              ? c.title!
                              : c.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingMultiSelectDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  values: controller.selectedSubCategoryIds.toList(),
                  onChanged: controller.setSelectedSubCategories,
                  labelText: 'Sub Categories',
                  hintText: 'Select sub categories',
                  enableSearch: true,
                  searchHintText: 'Search sub categories...',
                );
              }),
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
              await controller.updateDiscount();
            } else {
              await controller.createDiscount();
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
    );
  }
}
