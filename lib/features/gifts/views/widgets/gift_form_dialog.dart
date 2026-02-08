import 'package:bizreh_admin/features/gifts/controllers/gifts_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GiftFormDialog extends StatelessWidget {
  final GiftsController controller;

  const GiftFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Gift' : 'Create Gift'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Points',
                hint: 'Enter points',
                controller: controller.pointsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              LabeledTextField(
                label: 'Title',
                hint: 'Enter title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic title',
                controller: controller.arTitleController,
              ),
              FormImagePickerSection(
                selectedImagePath: controller.selectedImagePath,
                existingImageUrl: controller.currentGift?.image,
                isEditing: isEditing,
                onPathSelected: controller.setImagePath,
              ),
              const SizedBox(height: 12),
              Obx(() {
                return LoadingDropdownFormField2<int>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Active')),
                    DropdownMenuItem(value: 0, child: Text('Inactive')),
                  ],
                  value: controller.isActive.value,
                  onChanged: (v) {
                    if (v == null) return;
                    controller.isActive.value = v;
                  },
                  labelText: 'Status',
                  hintText: 'Select status',
                );
              }),
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
              await controller.updateGift();
            } else {
              await controller.createGift();
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
