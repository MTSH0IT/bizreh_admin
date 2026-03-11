import 'package:bizreh_admin/features/points/controllers/points_controller.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:bizreh_admin/utils/widgets/loading_dropdown_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PointFormDialog extends StatelessWidget {
  final PointsController controller;

  const PointFormDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Points Offer' : 'Create Points Offer'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Title',
                hint: 'Enter title',
                controller: controller.titleController,
              ),
              LabeledTextField(
                label: 'Arabic Title',
                hint: 'Enter Arabic title',
                controller: controller.arTitleController,
              ),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.brands
                    .where((b) => b.id != null)
                    .map(
                      (b) => DropdownMenuItem<int>(
                        value: b.id,
                        child: Text(
                          b.title?.isNotEmpty == true
                              ? b.title!
                              : b.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                final current = controller.selectedBrandId.value;
                final value = current > 0 ? current : null;

                return LoadingDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  value: value,
                  onChanged: controller.setSelectedBrandId,
                  labelText: 'Brand',
                  hintText: 'Select brand',
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final items = controller.packagings
                    .where((p) => p.id != null)
                    .map(
                      (p) => DropdownMenuItem<int>(
                        value: p.id,
                        child: Text(
                          p.title?.isNotEmpty == true
                              ? p.title!
                              : p.arTitle ?? '-',
                        ),
                      ),
                    )
                    .toList();

                final current = controller.selectedPackagingId.value;
                final value = current > 0 ? current : null;

                return LoadingDropdownFormField2<int>(
                  isLoading: controller.isMetaLoading.value,
                  items: items,
                  value: value,
                  onChanged: controller.setSelectedPackagingId,
                  labelText: 'Packaging',
                  hintText: 'Select packaging',
                );
              }),
              const SizedBox(height: 12),
              LabeledTextField(
                label: 'Points Per Unit',
                hint: '10',
                controller: controller.pointsPerUnitController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              LabeledTextField(
                label: 'Min Quantity',
                hint: 'Minimum items to earn points',
                controller: controller.minQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 1),
                  );
                  if (picked != null) {
                    final d = picked.toIso8601String().split('T').first;
                    controller.startDateController.text = '$d 00:00:00';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 1),
                  );
                  if (picked != null) {
                    final d = picked.toIso8601String().split('T').first;
                    controller.endDateController.text = '$d 23:59:59';
                  }
                },
              ),
              const SizedBox(height: 12),
              Obx(() {
                return LoadingDropdownFormField2<int>(
                  isLoading: false,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Active')),
                    DropdownMenuItem(value: 0, child: Text('Inactive')),
                  ],
                  value: controller.selectedIsActive.value,
                  onChanged: controller.setIsActive,
                  labelText: 'Status',
                  hintText: 'Select status',
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        FormDialogActions(
          onCancel: () {
            controller.clearForm();
            Get.back();
          },
          onSubmit: () async {
            if (controller.isEditing) {
              await controller.updatePointsOffer();
            } else {
              await controller.createPointsOffer();
            }
          },
          isBusy: () =>
              controller.isCreating.value || controller.isUpdating.value,
          submitText: isEditing ? 'Update' : 'Create',
        ),
      ],
    );
  }
}
