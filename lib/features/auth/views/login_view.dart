import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/auth/views/widgets/login_card.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: const LoginCard(),
        ),
      ),
    );
  }
}
