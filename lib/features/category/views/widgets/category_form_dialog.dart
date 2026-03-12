import 'package:bizreh_admin/features/category/controllers/category_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryFormDialog extends StatelessWidget {
  final CategoryController controller;

  const CategoryFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Category' : 'Create Category'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updateCategory();
            } else {
              await controller.createCategory();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],

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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          FormImagePickerSection(
            selectedImagePath: controller.selectedImagePath,
            existingImageUrl: controller.currentCategory?.image,
            isEditing: isEditing,
            onPathSelected: controller.setImagePath,
          ),
        ],
      ),
    );
  }
}
