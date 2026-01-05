import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
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
              LabeledTextField(
                label: 'Supplier ID',
                hint: 'Enter supplier id',
                controller: controller.supplierIdController,
                keyboardType: TextInputType.number,
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
                      if (context.mounted) {
                        Get.back();
                      }
                    } catch (_) {}
                  },
            child: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create'),
          );
        }),
      ],
    );
  }
}
