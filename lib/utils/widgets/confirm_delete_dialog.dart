import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showConfirmDeleteDialog({
  required String title,
  required String message,
  RxBool? isLoading,
  String cancelText = 'Cancel',
  String confirmText = 'Delete',
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (isLoading != null)
          Obx(() {
            return TextButton(
              onPressed: isLoading.value ? null : () => Get.back(result: false),
              child: Text(cancelText),
            );
          })
        else
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
        if (isLoading != null)
          Obx(() {
            return ElevatedButton(
              onPressed: isLoading.value ? null : () => Get.back(result: true),
              child: isLoading.value
                  ? const BuildProgressIndicator()
                  : Text(confirmText),
            );
          })
        else
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
      ],
    ),
    barrierDismissible: false,
  );

  return result == true;
}
