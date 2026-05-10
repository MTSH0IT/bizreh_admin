import 'dart:developer';

import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/color_servise.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class ColorFamilyController extends GetxController {
  final ColorService _service = sl<ColorService>();

  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController arNameController = TextEditingController();
  final TextEditingController colorDegreeController = TextEditingController();

  final Rx<ColorModel?> selectedColor = Rx<ColorModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getColors();
  }

  @override
  void onClose() {
    nameController.dispose();
    arNameController.dispose();
    colorDegreeController.dispose();
    super.onClose();
  }

  Future<void> getColors() async {
    try {
      isLoading.value = true;
      final data = await _service.getColorFamilies();
      colors.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getColors: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch colors', false);
      log('Error in getColors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createColor() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _service.createColorFamily(
        name: nameController.text.trim(),
        arName: arNameController.text.trim(),
        colorDegree: colorDegreeController.text.trim(),
      );
      await getColors();
      clearForm();
      Get.back();
      showMassage('Color created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createColor: ${e.message}');
    } catch (e) {
      showMassage('Failed to create color', false);
      log('Error in createColor: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateColor() async {
    final current = selectedColor.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _service.updateColorFamily(
        id: current!.id!,
        name: nameController.text.trim(),
        arName: arNameController.text.trim(),
        colorDegree: colorDegreeController.text.trim(),
      );
      await getColors();
      clearForm();
      Get.back();
      showMassage('Color updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateColor: ${e.message}');
    } catch (e) {
      showMassage('Failed to update color', false);
      log('Error in updateColor: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteColor(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteColorFamily(id);
      await getColors();
      showMassage('Color deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteColor: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete color', false);
      log('Error in deleteColor: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      showMassage('Please enter name', false);
      return false;
    }
    if (arNameController.text.trim().isEmpty) {
      showMassage('Please enter Arabic name', false);
      return false;
    }
    if (colorDegreeController.text.trim().isEmpty) {
      showMassage('Please enter color degree', false);
      return false;
    }
    return true;
  }

  void clearForm() {
    nameController.clear();
    arNameController.clear();
    colorDegreeController.clear();
    selectedColor.value = null;
  }

  void setColorForEdit(ColorModel model) {
    selectedColor.value = model;
    nameController.text = model.name ?? '';
    arNameController.text = model.arName ?? '';
    colorDegreeController.text = model.colorDegree ?? '';
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<ColorModel> get filteredColors {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return colors.toList();

    return colors.where((c) {
      final n = (c.name ?? '').toLowerCase();
      final an = (c.arName ?? '').toLowerCase();
      final d = (c.colorDegree ?? '').toLowerCase();
      return n.contains(q) || an.contains(q) || d.contains(q);
    }).toList();
  }

  bool get isEditing => selectedColor.value != null;
}
