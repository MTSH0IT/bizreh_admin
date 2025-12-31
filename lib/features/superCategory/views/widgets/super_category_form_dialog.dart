import 'package:bizreh_admin/features/superCategory/controllers/super_category_controller.dart';
import 'dart:io';
import 'package:bizreh_admin/utils/func/image_picker_helper.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperCategoryFormDialog extends StatelessWidget {
  final SuperCategoryController controller;

  const SuperCategoryFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Super Category' : 'Create Super Category'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter super category title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic super category title',
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
                final existingImage = controller.currentSuperCategory?.image;
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
                              child: Image.file(File(path)),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickImageAndSetPath(
                          onPathSelected: controller.setImagePath,
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
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        Obx(() {
          final busy =
              controller.isCreating.value || controller.isUpdating.value;
          return ElevatedButton(
            onPressed: busy
                ? null
                : () async {
                    if (controller.isEditing) {
                      await controller.updateSuperCategory();
                    } else {
                      await controller.createSuperCategory();
                    }
                    if (!controller.isCreating.value &&
                        !controller.isUpdating.value) {
                      Get.back();
                    }
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
