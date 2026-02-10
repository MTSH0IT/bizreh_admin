import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordDialog extends StatelessWidget {
  final AuthController controller;

  const ForgetPasswordDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forgot Password'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: controller.forgetPasswordEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            filled: true,
            fillColor: Color(0xFFF3F4F6),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.forgetPasswordEmailCtrl.clear();
            Get.back();
          },
          onSubmit: () async {
            await controller.forgetPassword();
          },
          isBusy: () => controller.isForgettingPassword.value,
          submitText: 'Send',
        ),
      ],
    );
  }
}
