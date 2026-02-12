import 'package:bizreh_admin/features/color_family/controllers/color_family_controller.dart';
import 'package:bizreh_admin/utils/func/color_degree.dart';
import 'package:bizreh_admin/utils/widgets/form_dialog_actions.dart';
import 'package:bizreh_admin/utils/widgets/labeled_text_field.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorFamilyFormDialog extends StatelessWidget {
  final ColorFamilyController controller;

  const ColorFamilyFormDialog({super.key, required this.controller});

  String _toHexRgb(Color color) {
    final rgb = color.value & 0x00FFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.isEditing;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Color' : 'Create Color'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
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
                hint: 'Enter arabic name',
                controller: controller.arNameController,
              ),
              LabeledTextField(
                label: 'Color degree',
                hint: 'Enter color degree',
                controller: controller.colorDegreeController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.colorDegreeController,
                    builder: (context, value, _) {
                      final preview = parseColorDegree(value.text);

                      return Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: preview,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      Color tempColor = parseColorDegree(
                        controller.colorDegreeController.text,
                      );

                      final picked = await showDialog<Color>(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Pick color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: tempColor,
                                onColorChanged: (c) => tempColor = c,
                                enableAlpha: false,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(tempColor),
                                child: const Text('Select'),
                              ),
                            ],
                          );
                        },
                      );

                      if (picked != null) {
                        controller.colorDegreeController.text = _toHexRgb(
                          picked,
                        );
                      }
                    },
                    icon: const Icon(Icons.color_lens_outlined),
                    label: const Text('Pick Color'),
                  ),
                ],
              ),
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
              await controller.updateColor();
            } else {
              await controller.createColor();
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
