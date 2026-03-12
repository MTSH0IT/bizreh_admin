import 'package:bizreh_admin/features/packaging/controllers/packaging_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagingFormDialog extends StatelessWidget {
  final PackagingController controller;

  const PackagingFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Packaging' : 'Create Packaging'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updatePackaging();
            } else {
              await controller.createPackaging();
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
            hint: 'Enter packaging title',
            controller: controller.titleController,
          ),
          LabeledTextField(
            label: 'Arabic Title',
            hint: 'Enter Arabic packaging title',
            controller: controller.arTitleController,
          ),
        ],
      ),
    );
  }
}
