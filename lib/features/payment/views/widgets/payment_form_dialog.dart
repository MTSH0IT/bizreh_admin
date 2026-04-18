import 'package:bizreh_admin/features/payment/controllers/payment_controller.dart';
import 'package:bizreh_admin/features/users/controllers/users_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentFormDialog extends StatelessWidget {
  final PaymentController controller;

  const PaymentFormDialog({super.key, required this.controller});

  List<DropdownMenuItem<int>> _buildUserDropdownItems(
    UsersController usersController,
  ) {
    return usersController.users.map((user) {
      return DropdownMenuItem<int>(
        value: user.id,
        child: Text(
          '${user.firstName} ${user.lastName}\n${user.email ?? 'No email'}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(height: 1.2, fontSize: 13),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildPaymentTypeItems() {
    return const [
      DropdownMenuItem<String>(value: 'regular', child: Text('Regular')),
      DropdownMenuItem<String>(value: 'bonus', child: Text('Bonus')),
    ];
  }

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
      child: GetBuilder<UsersController>(
        init: UsersController(),
        builder: (usersController) {
          return Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingDropdownFormField2<int>(
                  isLoading: usersController.isLoading.value,
                  labelText: 'User',
                  hintText: 'Select user',
                  value: controller.selectedPayment.value?.userId != null
                      ? int.tryParse(controller.userIdController.text)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      controller.userIdController.text = value.toString();
                    }
                  },
                  items: _buildUserDropdownItems(usersController),
                  enableSearch: true,
                  // menuItemHeight: 50,
                  searchHintText: 'Search by name or email...',
                  selectedItemTextBuilder: (menuItem) {
                    final child = menuItem.child;
                    if (child is Text) {
                      final raw = child.data ?? '';
                      if (raw.isEmpty) {
                        return menuItem.value?.toString() ?? '-';
                      }
                      return raw.split('\n').first.trim();
                    }
                    return menuItem.value?.toString() ?? '-';
                  },
                ),
                const SizedBox(height: 16),
                LabeledTextField(
                  label: 'Amount',
                  hint: 'Enter amount',
                  controller: controller.amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LoadingDropdownFormField2<String>(
                  isLoading: false,
                  labelText: 'Payment Type',
                  hintText: 'Select payment type',
                  value: controller.typeController.text.isNotEmpty
                      ? controller.typeController.text
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      controller.typeController.text = value;
                    }
                  },
                  items: _buildPaymentTypeItems(),
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
          );
        },
      ),
    );
  }
}
