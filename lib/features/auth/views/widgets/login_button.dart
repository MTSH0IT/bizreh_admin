import 'package:bizreh_admin/utils/consts/colors.dart';
import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kprimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: isLoading
            ? const BuildProgressIndicator()
            : const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
      ),
    );
  }
}
