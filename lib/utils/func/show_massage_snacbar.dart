import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMassage(String message, bool success) {
  Future.delayed(const Duration(milliseconds: 600), () {
    if (!Get.isSnackbarOpen) {
      Get.showSnackbar(
        GetSnackBar(
          title: success ? 'نجاح' : 'خطأ',
          message: message,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: success
              ? const Color(0xFF16A34A)
              : const Color(0xFFDC2626),
          borderRadius: 16,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          maxWidth: 520,
          isDismissible: true,
          duration: const Duration(seconds: 5),
          animationDuration: const Duration(milliseconds: 300),
          icon: Icon(
            success ? Icons.check_circle : Icons.error_outline,
            color: Colors.white,
          ),
        ),
      );
    }
  });
}
