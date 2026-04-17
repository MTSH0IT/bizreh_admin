import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentFormDialog extends StatelessWidget {
  final PaymentController controller;

  const PaymentFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: Text(controller.isEditing ? 'Edit Payment' : 'Create Payment'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updatePayment();
            } else {
              await controller.createPayment();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: controller.isEditing ? 'Update' : 'Create',
        ),
      ],
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledTextField(
              label: 'User ID',
              hint: 'Enter user ID',
              controller: controller.userIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Amount',
              hint: 'Enter amount',
              controller: controller.amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Type',
              hint: 'Enter payment type',
              controller: controller.typeController,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Notes',
              hint: 'Enter notes (optional)',
              controller: controller.notesController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
