import 'package:bizreh_admin/features/products_sku/controllers/products_sku_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkuFormDialog extends StatelessWidget {
  final ProductsSkuController controller;

  const SkuFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: const Text('Edit SKU'),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearSkuForm();
            Get.back();
          },
          onSubmit: () async {
            await controller.updateSku();
          },
          isBusy: () => controller.isUpdating.value,
          submitText: 'Update',
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledTextField(
            label: 'SKU',
            hint: 'Enter SKU',
            controller: controller.skuController,
          ),
        ],
      ),
    );
  }
}
