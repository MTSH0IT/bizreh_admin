import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFormDialog extends StatelessWidget {
  final UsersController controller;

  const UserFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.isEditing ? 'Edit User' : 'Create User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'First Name',
                          hint: 'Enter first name',
                          controller: controller.firstNameController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LabeledTextField(
                          label: 'Last Name',
                          hint: 'Enter last name',
                          controller: controller.lastNameController,
                        ),
                      ),
                    ],
                  ),

                  LabeledTextField(
                    label: 'Email',
                    hint: 'Enter email address',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  LabeledTextField(
                    label: 'Phone',
                    hint: 'Enter phone number',
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  Obx(() {
                    return LabeledTextField(
                      label: controller.isEditing
                          ? 'Password (leave empty to keep current)'
                          : 'Password',
                      hint: 'Enter password',
                      controller: controller.passwordController,
                      obscureText: true,
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final isLoading =
                      controller.isCreating.value ||
                      controller.isUpdating.value;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (controller.isEditing) {
                              controller.updateUser();
                            } else {
                              controller.createUser();
                            }
                          },
                    child: isLoading
                        ? const BuildProgressIndicator(
                            size: 16,
                            strokeWidth: 2,
                            centered: false,
                          )
                        : Text(controller.isEditing ? 'Update' : 'Create'),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
