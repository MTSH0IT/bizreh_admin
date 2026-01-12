import 'package:bizreh_admin/features/color_family/controllers/color_family_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorFamilyFormDialog extends StatelessWidget {
  final ColorFamilyController controller;

  const ColorFamilyFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Color' : 'Create Color'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Name',
                hint: 'Enter name',
                controller: controller.nameController,
              ),
              LabeledTextField(
                label: 'Arabic Name',
                hint: 'Enter arabic name',
                controller: controller.arNameController,
              ),
              LabeledTextField(
                label: 'Color degree',
                hint: 'Enter color degree',
                controller: controller.colorDegreeController,
                keyboardType: TextInputType.number,
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
              await controller.updateColor();
            } else {
              await controller.createColor();
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
