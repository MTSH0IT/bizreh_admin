import 'package:bizreh_admin/features/ads/controllers/ads_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsFormDialog extends StatelessWidget {
  final AdsController controller;

  const AdsFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Ad' : 'Create Ad'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              LabeledTextField(
                label: 'Description',
                hint: 'Enter description',
                controller: controller.descriptionController,
                maxLines: 3,
              ),
              LabeledTextField(
                label: 'Arabic Description',
                hint: 'Enter Arabic description',
                controller: controller.arDescriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              // Obx(() {
              //   final loading = controller.isMetaLoading.value;
              //   final items = controller.products
              //       .where((p) => p.id != null)
              //       .map(
              //         (ProductModel p) => DropdownMenuItem<int>(
              //           value: p.id!,
              //           child: Text(p.title ?? p.arTitle ?? 'Product #${p.id!}'),
              //         ),
              //       )
              //       .toList();

              //   return LoadingDropdownFormField2<int>(
              //     isLoading: loading,
              //     items: items,
              //     value: controller.selectedProductId.value,
              //     onChanged: controller.setProductId,
              //     labelText: 'Product',
              //     hintText: 'Select product',
              //     enableSearch: true,
              //     searchHintText: 'Search product...',
              //   );
              // }),
              // const SizedBox(height: 12),
              FormImagePickerSection(
                selectedImagePath: controller.selectedImagePath,
                existingImageUrl: controller.currentAd?.image,
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
              await controller.updateAd();
            } else {
              await controller.createAd();
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
