import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserNotificationAllDialog extends StatelessWidget {
  final UsersController controller;

  const UserNotificationAllDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send notification to all users'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledTextField(
              label: 'Title',
              hint: 'Enter notification title',
              controller: controller.notificationTitleController,
            ),
            LabeledTextField(
              label: 'Message',
              hint: 'Enter notification message',
              controller: controller.notificationMessageController,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearNotificationForm();
            Get.back();
          },
          onSubmit: () async {
            await controller.sendNotificationToAllUsers();
          },
          isBusy: () => controller.isSendingAllNotification.value,
          submitText: 'Send to all',
        ),
      ],
    );
  }
}
