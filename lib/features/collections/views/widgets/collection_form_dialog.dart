import 'package:bizreh_admin/features/collections/controllers/collections_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:bizreh_admin/utils/widgets/tags_input_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionFormDialog extends StatelessWidget {
  final CollectionsController controller;

  const CollectionFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Collection' : 'Create Collection'),
      width: 520,
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (isEditing) {
              await controller.updateCollection();
              return;
            }

            if (controller.isParentApi.value) {
              await controller.createParentCollection();
            } else {
              await controller.createCollection();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isEditing)
            Obx(
              () => SwitchListTile.adaptive(
                value: controller.isParentApi.value,
                onChanged: (value) => controller.isParentApi.value = value,
                title: const Text('Create as Parent Collection API'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          const SizedBox(height: 4),
          LabeledTextField(
            label: 'Title',
            hint: 'Enter collection title',
            controller: controller.titleController,
          ),
          LabeledTextField(
            label: 'Arabic Title',
            hint: 'Enter Arabic title',
            controller: controller.arTitleController,
          ),
          const SizedBox(height: 12),
          Obx(() {
            final parentItems = controller.parentOptions
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: e.id,
                    child: Text(e.displayTitle),
                  ),
                )
                .toList();
            final selected = controller.selectedParentId.value == 0
                ? null
                : controller.selectedParentId.value;

            return LoadingDropdownFormField2<int>(
              isLoading: false,
              items: parentItems,
              value: selected,
              onChanged: (v) => controller.selectedParentId.value = v ?? 0,
              labelText: 'Parent Collection',
              hintText: 'Select parent (optional)',
              enableSearch: true,
              searchHintText: 'Search parent...',
            );
          }),
          const SizedBox(height: 12),
          Obx(() {
            final showAdvanced = isEditing || !controller.isParentApi.value;
            if (!showAdvanced) return const SizedBox.shrink();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingDropdownFormField2<String>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(value: 'and', child: Text('and')),
                    DropdownMenuItem(value: 'or', child: Text('or')),
                  ],
                  value: controller.conditionType.value,
                  onChanged: (v) {
                    controller.conditionType.value = v ?? 'and';
                  },
                  labelText: 'Condition Type',
                  hintText: 'Select condition type',
                ),
                const SizedBox(height: 12),
                LoadingDropdownFormField2<String>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(
                      value: 'collections',
                      child: Text('collections'),
                    ),
                    DropdownMenuItem(value: 'products', child: Text('products')),
                  ],
                  value: controller.type.value,
                  onChanged: (v) {
                    controller.type.value = v ?? 'collections';
                  },
                  labelText: 'Type',
                  hintText: 'Select type',
                ),
                LabeledTextField(
                  label: 'Brand',
                  hint: 'Comma-separated brand IDs',
                  controller: controller.brandController,
                ),
                LabeledTextField(
                  label: 'Sub Category',
                  hint: 'Comma-separated sub category IDs',
                  controller: controller.subCategoryController,
                ),
                Obx(
                  () => TagsInputSection(
                    inputController: controller.tagInputController,
                    tags: controller.formTags.toList(),
                    onAddTag: controller.addTagFromInput,
                    onRemoveTag: controller.removeTag,
                  ),
                ),
                LabeledTextField(
                  label: 'Custom Products',
                  hint: 'Comma-separated product IDs',
                  controller: controller.customProductsController,
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          Obx(
            () => LoadingDropdownFormField2<int>(
              isLoading: false,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Active')),
                DropdownMenuItem(value: 0, child: Text('Inactive')),
              ],
              value: controller.status.value,
              onChanged: (v) => controller.status.value = v ?? 1,
              labelText: 'Status',
              hintText: 'Select status',
            ),
          ),
          FormImagePickerSection(
            selectedImagePath: controller.selectedImagePath,
            existingImageUrl: controller.selectedCollection.value?.image
                ?.toString(),
            isEditing: isEditing,
            onPathSelected: controller.setImagePath,
          ),
        ],
      ),
    );
  }
}
