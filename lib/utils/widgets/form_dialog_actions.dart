import 'package:bizreh_admin/utils/widgets/build_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormDialogActions extends StatelessWidget {
  final VoidCallback onCancel;
  final Future<void> Function() onSubmit;
  final bool Function() isBusy;
  final String cancelText;
  final String submitText;

  const FormDialogActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.isBusy,
    this.cancelText = 'Cancel',
    required this.submitText,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final busy = isBusy();

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: busy ? null : onCancel,
            child: Text(cancelText),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: busy
                ? null
                : () async {
                    await onSubmit();
                  },
            child: busy ? const BuildProgressIndicator() : Text(submitText),
          ),
        ],
      );
    });
  }
}
