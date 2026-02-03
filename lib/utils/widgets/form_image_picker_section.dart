import 'dart:io';

import 'package:bizreh_admin/utils/func/image_picker_helper.dart';
import 'package:bizreh_admin/utils/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormImagePickerSection extends StatelessWidget {
  final RxString selectedImagePath;
  final String? existingImageUrl;
  final bool isEditing;
  final void Function(String path) onPathSelected;
  final int imageQuality;

  const FormImagePickerSection({
    super.key,
    required this.selectedImagePath,
    required this.existingImageUrl,
    required this.isEditing,
    required this.onPathSelected,
    this.imageQuality = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final path = selectedImagePath.value;
      final hasExisting =
          isEditing && existingImageUrl != null && existingImageUrl!.isNotEmpty;

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
                    child: ImageNetwork(image: existingImageUrl!),
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
                    child: Image.file(
                      File(path),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                            color: Color(0xFFF3F4F6),
                            child: Center(
                              child: Icon(Icons.broken_image_outlined),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await pickImageAndSetPath(
                onPathSelected: onPathSelected,
                imageQuality: imageQuality,
              );
            },
            icon: const Icon(Icons.image),
            label: Text(
              hasExisting && path.isEmpty ? 'Change Image' : 'Select Image',
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    });
  }
}
