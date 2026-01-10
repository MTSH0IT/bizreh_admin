import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
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
                        child: TextFormField(
                          controller: controller.firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: controller.lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final isBusy =
                        controller.isCreating.value ||
                        controller.isUpdating.value;

                    return TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: controller.isEditing
                            ? 'Password (leave empty to keep current)'
                            : 'Password',
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                      enabled: !isBusy,
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
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
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
