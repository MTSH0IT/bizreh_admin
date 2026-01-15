import 'package:bizreh_admin/features/option_packaging/controllers/product_options_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionFormDialog extends StatelessWidget {
  final ProductOptionsController controller;

  const OptionFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
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
              final id = controller.selectedOption.value?.id;
              if (id != null) {
                await controller.updateOption(id);
              }
            } else {
              await controller.createOption();
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
