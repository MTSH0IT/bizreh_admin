import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/tags_input_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductFormDialog extends StatelessWidget {
  final ProductsController controller;

  const ProductFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Product' : 'Create Product'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updateProduct();
            } else {
              await controller.createProduct();
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
            hint: 'Enter product title',
            controller: controller.titleController,
          ),
          LabeledTextField(
            label: 'Arabic Title',
            hint: 'Enter Arabic product title',
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
          Obx(() {
            final loading = controller.isMetaLoading.value;
            final items = controller.brands
                .where((b) => b.id != null)
                .map(
                  (b) => DropdownMenuItem<int>(
                    value: b.id!,
                    child: Text(b.title ?? b.arTitle ?? 'Brand #${b.id!}'),
                  ),
                )
                .toList();

            final selected = controller.selectedBrandId.value == 0
                ? null
                : controller.selectedBrandId.value;

            return LoadingDropdownFormField2<int>(
              isLoading: loading,
              items: items,
              value: selected,
              labelText: 'Brand',
              hintText: 'Select brand',
              enableSearch: true,
              searchHintText: 'Search brand...',
              onChanged: (v) {
                controller.selectedBrandId.value = v ?? 0;
              },
            );
          }),
          const SizedBox(height: 12),
          Obx(() {
            final loading = controller.isMetaLoading.value;
            final items = controller.allSubCategories
                .where((s) => s.id != null)
                .map((s) {
                  final title = s.title ?? s.arTitle ?? 'Sub #${s.id!}';
                  final parent = s.categoryTitle ?? s.categoryArTitle;
                  final text = parent == null || parent.isEmpty
                      ? title
                      : '$title - $parent';
                  return DropdownMenuItem<int>(value: s.id!, child: Text(text));
                })
                .toList();

            final selected = controller.selectedSubCategoryId.value == 0
                ? null
                : controller.selectedSubCategoryId.value;

            return LoadingDropdownFormField2<int>(
              isLoading: loading,
              items: items,
              value: selected,
              labelText: 'Sub Category',
              hintText: 'Select sub category',
              enableSearch: true,
              searchHintText: 'Search sub category...',
              onChanged: (v) {
                controller.selectedSubCategoryId.value = v ?? 0;
              },
            );
          }),
          LabeledTextField(
            label: 'Position',
            hint: 'Enter position',
            controller: controller.positionController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          Obx(
            () => TagsInputSection(
              inputController: controller.tagInputController,
              tags: controller.formTags.toList(),
              onAddTag: controller.addTagFromInput,
              onRemoveTag: controller.removeTag,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final isActive = controller.selectedIsActive.value == 1;
            return DropdownButtonFormField<bool>(
              initialValue: isActive,
              decoration: const InputDecoration(
                labelText: 'Is Active',
                filled: true,
                fillColor: Color(0xFFF3F4F6),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: true, child: Text('Active')),
                DropdownMenuItem(value: false, child: Text('Inactive')),
              ],
              onChanged: (v) {
                final active = v ?? true;
                controller.selectedIsActive.value = active ? 1 : 0;
              },
            );
          }),
          const SizedBox(height: 12),
          FormImagePickerSection(
            selectedImagePath: controller.selectedImagePath,
            existingImageUrl: controller.currentProduct?.image,
            isEditing: isEditing,
            onPathSelected: controller.setImagePath,
          ),
        ],
      ),
    );
  }
}
