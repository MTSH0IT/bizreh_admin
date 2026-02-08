import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
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
    return AlertDialog(
      title: const Text('Create Driver'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'First name',
                hint: 'Enter first name',
                controller: controller.firstNameController,
              ),
              LabeledTextField(
                label: 'Last name',
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
                label: 'Vehicle number',
                hint: 'Enter vehicle number',
                controller: controller.vehicleNumberController,
              ),
              LabeledTextField(
                label: 'License number',
                hint: 'Enter license number',
                controller: controller.licenseNumberController,
              ),
              Obx(() {
                final loading = controller.isSuppliersLoading.value;
                final items = controller.suppliers
                    .where((s) => s.id != null)
                    .map(
                      (s) => DropdownMenuItem<int>(
                        value: s.id!,
                        child: Text(
                          '${s.firstName ?? ''} ${s.lastName ?? ''}'
                                  .trim()
                                  .isEmpty
                              ? 'Supplier #${s.id!}'
                              : '${s.firstName ?? ''} ${s.lastName ?? ''}'
                                    .trim(),
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
                    controller.selectedIsActive.value = (v == true) ? 1 : 0;
                  },
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        Obx(() {
          final busy = controller.isCreating.value;
          return ElevatedButton(
            onPressed: busy
                ? null
                : () async {
                    try {
                      await controller.createDriver();
                    } catch (_) {}
                  },
            child: busy
                ? const BuildProgressIndicator(
                    size: 18,
                    strokeWidth: 2,
                    centered: false,
                  )
                : const Text('Create'),
          );
        }),
      ],
    );
  }
}
