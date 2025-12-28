import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMassage(String message, bool success) {
  Get.showSnackbar(
    GetSnackBar(
      title: success ? 'نجاح' : 'خطأ',
      message: message,
      backgroundColor: success ? Colors.green : Colors.red,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      icon: Icon(
        success ? Icons.check_circle : Icons.error_outline,
        color: Colors.white,
      ),
    ),
  );
}
