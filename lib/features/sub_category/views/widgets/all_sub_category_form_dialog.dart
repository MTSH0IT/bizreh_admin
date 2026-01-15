import 'package:bizreh_admin/features/sub_category/controllers/all_sub_category_crud_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSubCategoryFormDialog extends StatelessWidget {
  final AllSubCategoryCrudController controller;

  const AllSubCategoryFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Sub Category' : 'Create Sub Category'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter sub category title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic sub category title',
                controller: controller.arTitleController,
              ),
              LabeledTextField(
                label: 'Position',
                hint: 'Enter position',
                controller: controller.positionController,
                keyboardType: TextInputType.number,
              ),
              Obx(() {
                final items = controller.categories
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(
                          (c.title?.isNotEmpty == true)
                              ? c.title!
                              : (c.arTitle?.isNotEmpty == true)
                              ? c.arTitle!
                              : '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingDropdownFormField2<int>(
                  isLoading: controller.isCategoriesLoading.value,
                  items: items,
                  value: controller.selectedCategoryId.value == 0
                      ? null
                      : controller.selectedCategoryId.value,
                  onChanged: controller.setCategoryId,
                  labelText: 'Category',
                  hintText: 'Select category',
                  enableSearch: true,
                );
              }),
              const SizedBox(height: 12),
              FormImagePickerSection(
                selectedImagePath: controller.selectedImagePath,
                existingImageUrl: controller.currentSubCategory?.image,
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
              await controller.updateSubCategory();
            } else {
              await controller.createSubCategory();
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
