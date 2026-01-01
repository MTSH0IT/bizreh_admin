import 'dart:io';

import 'package:bizreh_admin/features/category/controllers/category_controller.dart';
import 'package:bizreh_admin/utils/func/image_picker_helper.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryFormDialog extends StatelessWidget {
  final CategoryController controller;

  const CategoryFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Category' : 'Create Category'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter category title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic category title',
                controller: controller.arTitleController,
              ),
              LabeledTextField(
                label: 'Position',
                hint: 'Enter position',
                controller: controller.positionController,
                keyboardType: TextInputType.number,
              ),
              Obx(() {
                final path = controller.selectedImagePath.value;
                final existingImage = controller.currentCategory?.image;
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
                        await controller.updateCategory();
                      } else {
                        await controller.createCategory();
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
