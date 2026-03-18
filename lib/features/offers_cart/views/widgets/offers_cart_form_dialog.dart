import 'package:bizreh_admin/features/offers_cart/controllers/offers_cart_controller.dart';
import 'package:bizreh_admin/utils/widgets/app_form_dialog.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OffersCartFormDialog extends StatelessWidget {
  final OffersCartController controller;

  const OffersCartFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AppFormDialog(
      title: Text(isEditing ? 'Edit Offer' : 'Create Offer'),
      width: 620,
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updateOffer();
            } else {
              await controller.createOffer();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledTextField(
            label: 'Name',
            hint: 'Enter name',
            controller: controller.nameController,
          ),
          LabeledTextField(
            label: 'Arabic Name',
            hint: 'Enter Arabic name',
            controller: controller.arNameController,
          ),
          LabeledTextField(
            label: 'Description',
            hint: 'Enter description',
            controller: controller.descriptionController,
            maxLines: 3,
          ),
          LabeledTextField(
            label: 'Arabic Description',
            hint: 'Enter Arabic description',
            controller: controller.arDescriptionController,
            maxLines: 3,
          ),
          LabeledTextField(
            label: 'Price',
            hint: 'Enter price',
            controller: controller.priceController,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          LabeledTextField(
            label: 'Quantity',
            hint: 'Enter quantity',
            controller: controller.quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: controller.addItemRow,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add item'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final list = controller.items;
            return Column(
              children: List.generate(list.length, (index) {
                final item = list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Option packaging id',
                          hint: 'e.g. 92',
                          controller: item.optionPackagingIdController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LabeledTextField(
                          label: 'Item quantity',
                          hint: 'e.g. 3',
                          controller: item.quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => controller.removeItemRow(index),
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
