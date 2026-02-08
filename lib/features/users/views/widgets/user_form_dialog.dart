import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserFormDialog extends StatelessWidget {
  final UsersController controller;

  const UserFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(controller.isEditing ? 'Edit User' : 'Create User'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              await controller.updateUser();
            } else {
              await controller.createUser();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: controller.isEditing ? 'Update' : 'Create',
        ),
      ],
    );
  }
}
