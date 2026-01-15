import 'package:bizreh_admin/features/category/controllers/all_category_crud_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/form_image_picker_section.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoryFormDialog extends StatelessWidget {
  final AllCategoryCrudController controller;

  const AllCategoryFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Category' : 'Create Category'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
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
              ),
              Obx(() {
                final items = controller.superCategories
                    .map(
                      (s) => DropdownMenuItem<int>(
                        value: s.id,
                        child: Text(
                          (s.title?.isNotEmpty == true)
                              ? s.title!
                              : (s.arTitle?.isNotEmpty == true)
                              ? s.arTitle!
                              : '-',
                        ),
                      ),
                    )
                    .toList();

                return LoadingDropdownFormField2<int>(
                  isLoading: controller.isSuperCategoriesLoading.value,
                  items: items,
                  value: controller.selectedSuperCategoryId.value == 0
                      ? null
                      : controller.selectedSuperCategoryId.value,
                  onChanged: controller.setSuperCategoryId,
                  labelText: 'Super Category',
                  hintText: 'Select super category',
                  enableSearch: true,
                );
              }),
              const SizedBox(height: 12),
              FormImagePickerSection(
                selectedImagePath: controller.selectedImagePath,
                existingImageUrl: controller.currentCategory?.image,
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
    );
  }
}
