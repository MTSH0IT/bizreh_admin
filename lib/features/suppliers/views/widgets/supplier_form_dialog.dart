import 'package:bizreh_admin/features/suppliers/controllers/suppliers_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SupplierFormDialog extends StatelessWidget {
  final SuppliersController controller;

  const SupplierFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Supplier' : 'Create Supplier'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'First Name',
                hint: 'Enter first name',
                controller: controller.firstNameController,
              ),
              LabeledTextField(
                label: 'Last Name',
                hint: 'Enter last name',
                controller: controller.lastNameController,
              ),
              LabeledTextField(
                label: 'Email',
                hint: 'Enter email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              LabeledTextField(
                label: 'Phone',
                hint: 'Enter phone',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              if (!isEditing)
                LabeledTextField(
                  label: 'Password',
                  hint: 'Enter password',
                  controller: controller.passwordController,
                  obscureText: true,
                ),
              const SizedBox(height: 12),
              if (!isEditing)
                Obx(() {
                  final loading = controller.isMetaLoading.value;
                  final items = controller.cities
                      .where((c) => c.id != null)
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c.id!,
                          child: Text(c.title ?? c.arTitle ?? 'City #${c.id!}'),
                        ),
                      )
                      .toList();

                  final selected = controller.selectedCityId.value == 0
                      ? null
                      : controller.selectedCityId.value;

                  return LoadingDropdownFormField2<int>(
                    isLoading: loading,
                    items: items,
                    value: selected,
                    labelText: 'City',
                    hintText: 'Select city',
                    enableSearch: true,
                    searchHintText: 'Search city...',
                    onChanged: (v) {
                      controller.selectedCityId.value = v ?? 0;
                    },
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
              await controller.updateSupplier();
            } else {
              await controller.createSupplier();
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
