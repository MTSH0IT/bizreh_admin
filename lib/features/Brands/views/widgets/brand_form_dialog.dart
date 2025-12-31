import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'dart:io';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class BrandFormDialog extends StatelessWidget {
  final BrandsController controller;

  const BrandFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Brand' : 'Create Brand'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter brand title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic brand title',
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
                final existingImage = controller.currentBrand?.image;
                final hasExisting =
                    isEditing &&
                    existingImage != null &&
                    existingImage.isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Image',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (path.isNotEmpty) ...[
                      SizedBox(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const ColoredBox(
                                color: Color(0xFFF3F4F6),
                                child: Center(
                                  child: Icon(Icons.broken_image_outlined),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ] else if (hasExisting) ...[
                      SizedBox(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ImageNetwork(image: existingImage),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              path.isEmpty
                                  ? (isEditing
                                        ? (hasExisting
                                              ? 'Keeping current image'
                                              : 'No image')
                                        : 'Please select an image')
                                  : path.split(Platform.pathSeparator).last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 80,
                            );
                            if (image != null) {
                              controller.setImagePath(image.path);
                            }
                          },
                          child: Text(path.isEmpty ? 'Choose' : 'Change'),
                        ),
                        if (path.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => controller.setImagePath(''),
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ],
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
                    if (controller.isEditing) {
                      await controller.updateBrand();
                    } else {
                      await controller.createBrand();
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
