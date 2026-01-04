import 'dart:io';

import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/utils/func/image_picker_helper.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFormDialog extends StatelessWidget {
  final ProductsController controller;

  const ProductFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Product' : 'Create Product'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter product title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic product title',
                controller: controller.arTitleController,
              ),
              LabeledTextField(
                label: 'Description',
                hint: 'Enter description',
                controller: controller.descriptionController,
                maxLines: 3,
              ),
              LabeledTextField(
                label: 'Arabic Description',
                hint: 'Enter Arabic description',
                controller: controller.arDescriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Obx(() {
                final loading = controller.isMetaLoading.value;
                final items = controller.brands
                    .where((b) => b.id != null)
                    .map(
                      (b) => DropdownMenuItem<int>(
                        value: b.id!,
                        child: Text(b.title ?? b.arTitle ?? 'Brand #${b.id!}'),
                      ),
                    )
                    .toList();

                final selected = controller.selectedBrandId.value == 0
                    ? null
                    : controller.selectedBrandId.value;

                return LoadingDropdownFormField2<int>(
                  isLoading: loading,
                  items: items,
                  value: selected,
                  labelText: 'Brand',
                  hintText: 'Select brand',
                  enableSearch: true,
                  searchHintText: 'Search brand...',
                  onChanged: (v) {
                    controller.selectedBrandId.value = v ?? 0;
                  },
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final loading = controller.isMetaLoading.value;
                final items = controller.allSubCategories
                    .where((s) => s.id != null)
                    .map((s) {
                      final title = s.title ?? s.arTitle ?? 'Sub #${s.id!}';
                      final parent = s.categoryTitle ?? s.categoryArTitle;
                      final text = parent == null || parent.isEmpty
                          ? title
                          : '$title - $parent';
                      return DropdownMenuItem<int>(
                        value: s.id!,
                        child: Text(text),
                      );
                    })
                    .toList();

                final selected = controller.selectedSubCategoryId.value == 0
                    ? null
                    : controller.selectedSubCategoryId.value;

                return LoadingDropdownFormField2<int>(
                  isLoading: loading,
                  items: items,
                  value: selected,
                  labelText: 'Sub Category',
                  hintText: 'Select sub category',
                  enableSearch: true,
                  searchHintText: 'Search sub category...',
                  onChanged: (v) {
                    controller.selectedSubCategoryId.value = v ?? 0;
                  },
                );
              }),
              LabeledTextField(
                label: 'Position',
                hint: 'Enter position',
                controller: controller.positionController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Obx(() {
                final isActive = controller.selectedIsActive.value == 1;
                return DropdownButtonFormField<bool>(
                  initialValue: isActive,
                  decoration: const InputDecoration(
                    labelText: 'Is Active',
                    filled: true,
                    fillColor: Color(0xFFF3F4F6),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Active')),
                    DropdownMenuItem(value: false, child: Text('Inactive')),
                  ],
                  onChanged: (v) {
                    controller.selectedIsActive.value = (v == true) ? 1 : 0;
                  },
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final path = controller.selectedImagePath.value;
                final existingImage = controller.currentProduct?.image;
                final hasExisting =
                    isEditing &&
                    existingImage != null &&
                    existingImage.isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    if (hasExisting && path.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Image:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageNetwork(image: existingImage),
                            ),
                          ),
                        ],
                      ),
                    if (path.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Image:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(path), fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickImageAndSetPath(
                          onPathSelected: controller.setImagePath,
                          imageQuality: 80,
                        );
                      },
                      icon: const Icon(Icons.image),
                      label: Text(
                        hasExisting && path.isEmpty
                            ? 'Change Image'
                            : 'Select Image',
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        Obx(() {
          final busy =
              controller.isCreating.value || controller.isUpdating.value;
          return ElevatedButton(
            onPressed: busy
                ? null
                : () async {
                    try {
                      if (controller.isEditing) {
                        await controller.updateProduct();
                      } else {
                        await controller.createProduct();
                      }
                      if (context.mounted) {
                        Get.back();
                      }
                    } catch (_) {}
                  },
            child: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? 'Update' : 'Create'),
          );
        }),
      ],
    );
  }
}
