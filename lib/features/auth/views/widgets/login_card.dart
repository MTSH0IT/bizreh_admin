import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_button.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_remember_row.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_text_field.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
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
          const LoginTextField(
            label: 'Email',
            hintText: 'Enter your email',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          const LoginTextField(
            label: 'Password',
            hintText: 'Enter your password',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          LoginRememberRow(
            rememberMe: _rememberMe,
            onRememberChanged: (v) => setState(() => _rememberMe = v),
          ),
          const SizedBox(height: 20),
          LoginButton(
            onPressed: () {
              // TODO: handle login
            },
          ),
        ],
      ),
    );
  }
}
