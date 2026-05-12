import 'package:bizreh_admin/features/suppliers/controllers/suppliers_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
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

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Supplier' : 'Create Supplier'),
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
            Obx(
              () => LabeledTextField(
                label: 'Password',
                hint: 'Enter password',
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF6B7280),
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          const SizedBox(height: 12),
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
    );
  }
}
