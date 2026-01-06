import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
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
              FormImagePickerSection(
                selectedImagePath: controller.selectedImagePath,
                existingImageUrl: controller.currentBrand?.image,
                isEditing: isEditing,
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
              await controller.updateBrand();
            } else {
              await controller.createBrand();
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
