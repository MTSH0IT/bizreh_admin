import 'package:bizreh_admin/features/collections/controllers/collections_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:bizreh_admin/utils/widgets/loading_multi_select_dropdown_form_field2.dart';
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
          if (!isEditing) ...[
            Obx(
              () => LoadingDropdownFormField2<String>(
                isLoading: false,
                items: const [
                  DropdownMenuItem(
                    value: 'parent',
                    child: Text('Parent Collection'),
                  ),
                  DropdownMenuItem(
                    value: 'products',
                    child: Text('Products Collection'),
                  ),
                ],
                value: controller.isParentApi.value ? 'parent' : 'products',
                onChanged: (v) {
                  final mode = v ?? 'parent';
                  if (mode == 'parent') {
                    controller.isParentApi.value = true;
                  } else {
                    controller.isParentApi.value = false;
                  }
                },
                labelText: 'Collection Mode',
                hintText: 'Select collection mode',
              ),
            ),
            const SizedBox(height: 12),
          ],
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
            final showAdvanced = isEditing
                ? controller.isEditingProductsType
                : !controller.isParentApi.value;
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
                Obx(() {
                  final items = controller.brands
                      .where((b) => b.id != null)
                      .map(
                        (b) => DropdownMenuItem<int>(
                          value: b.id,
                          child: Text(
                            b.title?.isNotEmpty == true
                                ? b.title!
                                : b.arTitle ?? '-',
                          ),
                        ),
                      )
                      .toList();

                  return LoadingMultiSelectDropdownFormField2<int>(
                    isLoading: controller.isMetaLoading.value,
                    items: items,
                    values: controller.selectedBrandIds.toList(),
                    onChanged: controller.setSelectedBrands,
                    labelText: 'Brands',
                    hintText: 'Select brands',
                    enableSearch: true,
                    searchHintText: 'Search brands...',
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  final items = controller.subCategories
                      .where((c) => c.id != null)
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(
                            c.title?.isNotEmpty == true
                                ? c.title!
                                : c.arTitle ?? '-',
                          ),
                        ),
                      )
                      .toList();

                  return LoadingMultiSelectDropdownFormField2<int>(
                    isLoading: controller.isMetaLoading.value,
                    items: items,
                    values: controller.selectedSubCategoryIds.toList(),
                    onChanged: controller.setSelectedSubCategories,
                    labelText: 'Sub Categories',
                    hintText: 'Select sub categories',
                    enableSearch: true,
                    searchHintText: 'Search sub categories...',
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  final items = controller.products
                      .where((p) => p.id != null)
                      .map(
                        (p) => DropdownMenuItem<int>(
                          value: p.id,
                          child: Text(
                            p.title?.isNotEmpty == true
                                ? p.title!
                                : p.arTitle ?? '-',
                          ),
                        ),
                      )
                      .toList();

                  return LoadingMultiSelectDropdownFormField2<int>(
                    isLoading: controller.isMetaLoading.value,
                    items: items,
                    values: controller.selectedCustomProductIds.toList(),
                    onChanged: controller.setSelectedCustomProducts,
                    labelText: 'Custom Products',
                    hintText: 'Select products',
                    enableSearch: true,
                    searchHintText: 'Search products...',
                  );
                }),
                const SizedBox(height: 12),
                TagsInputSection(
                  inputController: controller.tagInputController,
                  tags: controller.formTags.toList(),
                  onAddTag: controller.addTagFromInput,
                  onRemoveTag: controller.removeTag,
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
