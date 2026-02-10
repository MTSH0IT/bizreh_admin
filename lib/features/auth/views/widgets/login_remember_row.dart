import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:flutter/material.dart';

class LoginRememberRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback? onForgotPassword;

  const LoginRememberRow({
    super.key,
    required this.rememberMe,
    required this.onRememberChanged,
    this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (v) => onRememberChanged(v ?? false),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: kprimaryColor,
        ),
        Text('Remember Me', style: const TextStyle(color: Color(0xFF4B5563))),
        const Spacer(),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
