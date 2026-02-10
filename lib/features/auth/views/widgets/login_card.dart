import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_button.dart';
import 'package:bizreh_admin/features/auth/views/widgets/forget_password_dialog.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_remember_row.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_text_field.dart';
import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';
import 'package:bizreh_admin/utils/widgets/open_form_dialog.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final RxBool rememberMe = false.obs;

    return Container(
      width: 420,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0E7FF),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: kprimaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Admin Login',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome back! Please enter your details.',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 24),
          LoginTextField(
            label: 'Email',
            hintText: 'Enter your email',
            icon: Icons.person_outline,
            controller: authController.loginEmailCtrl,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            label: 'Password',
            hintText: 'Enter your password',
            icon: Icons.lock_outline,
            obscureText: true,
            controller: authController.loginPasswordCtrl,
          ),
          const SizedBox(height: 12),
          Obx(
            () => LoginRememberRow(
              rememberMe: rememberMe.value,
              onRememberChanged: (value) => rememberMe.value = value,
              onForgotPassword: () {
                openFormDialog<void>(
                  onBeforeOpen: () {
                    authController.forgetPasswordEmailCtrl.text =
                        authController.loginEmailCtrl.text;
                  },
                  dialogBuilder: (_) =>
                      ForgetPasswordDialog(controller: authController),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => LoginButton(
              onPressed: authController.isLoading.value
                  ? null
                  : () => authController.login(rememberMe: rememberMe.value),
              isLoading: authController.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}
