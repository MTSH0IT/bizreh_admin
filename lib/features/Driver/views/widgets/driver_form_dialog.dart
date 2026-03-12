import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DriverFormDialog extends StatelessWidget {
  final DriversController controller;

  const DriverFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: const Text('Create Driver'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            await controller.createDriver();
          },
          isBusy: () => controller.isCreating.value,
          submitText: 'Create',
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
          LabeledTextField(
            label: 'Password',
            hint: 'Enter password',
            controller: controller.passwordController,
            obscureText: true,
          ),
          LabeledTextField(
            label: 'Vehicle Number',
            hint: 'Enter vehicle number',
            controller: controller.vehicleNumberController,
          ),
          LabeledTextField(
            label: 'License Number',
            hint: 'Enter license number',
            controller: controller.licenseNumberController,
          ),
          const SizedBox(height: 12),
          Obx(() {
            final loading = controller.isSuppliersLoading.value;
            final items = controller.suppliers
                .where((s) => s.id != null)
                .map(
                  (s) => DropdownMenuItem<int>(
                    value: s.id!,
                    child: Text(
                      ('${s.firstName ?? ''} ${s.lastName ?? ''}'.trim())
                              .isEmpty
                          ? 'Supplier #${s.id!}'
                          : '${s.firstName ?? ''} ${s.lastName ?? ''}'.trim(),
                    ),
                  ),
                )
                .toList();

            final selected = controller.selectedSupplierId.value == 0
                ? null
                : controller.selectedSupplierId.value;

            return LoadingDropdownFormField2<int>(
              isLoading: loading,
              items: items,
              value: selected,
              labelText: 'Supplier',
              hintText: 'Select supplier',
              enableSearch: true,
              searchHintText: 'Search supplier...',
              onChanged: (v) {
                final id = v ?? 0;
                controller.selectedSupplierId.value = id;
                controller.supplierIdController.text = id == 0
                    ? ''
                    : id.toString();
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
              value: controller.selectedIsActive.value,
              onChanged: (v) {
                controller.selectedIsActive.value = v ?? 1;
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
