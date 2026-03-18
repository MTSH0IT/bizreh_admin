import 'dart:developer';

import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/features/color_family/controllers/color_family_controller.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/color_servise.dart';
import 'package:bizreh_admin/services/option_packaging_servise.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionPackagingController extends GetxController {
  final OptionPackagingService _service = OptionPackagingService();
  final ColorService _colorService = ColorService();

  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxBool isColorsLoading = false.obs;
  final RxInt selectedColorId = 0.obs;

  VoidCallback? onSaved;

  @override
  void onInit() {
    super.onInit();
    loadColorsIfNeeded();
  }

  Future<void> loadColorsIfNeeded() async {
    final colorFamilyController = Get.isRegistered<ColorFamilyController>()
        ? Get.find<ColorFamilyController>()
        : null;

    if (colorFamilyController != null &&
        colorFamilyController.colors.isNotEmpty) {
      colors.assignAll(colorFamilyController.colors);
      return;
    }

    if (colors.isNotEmpty) {
      return;
    }

    await loadColors();
  }

  Future<void> loadColors() async {
    try {
      isColorsLoading.value = true;
      final data = await _colorService.getColorFamilies();
      colors.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in loadColors: ${e.message}');
    } catch (e) {
      showMassage('Failed to load colors', false);
      log('Error in loadColors: $e');
    } finally {
      isColorsLoading.value = false;
    }
  }

  void setSelectedColorId(int? id) {
    selectedColorId.value = id ?? 0;
  }

  bool validateMappingInputs({
    required num? pricePerUnit,
    required int? stockQuantity,
    required String? optionSku,
  }) {
    if (pricePerUnit == null) {
      showMassage('Please enter a valid price', false);
      return false;
    }

    if (pricePerUnit <= 0) {
      showMassage('Price must be greater than 0', false);
      return false;
    }

    if (stockQuantity == null) {
      showMassage('Please enter a valid stock quantity', false);
      return false;
    }

    if (stockQuantity < 0) {
      showMassage('Stock quantity cannot be negative', false);
      return false;
    }

    if (optionSku == null || optionSku.trim().isEmpty) {
      showMassage('Please enter a valid sku', false);
      return false;
    }

    return true;
  }

  Future<void> saveMapping({
    int? mappingId,
    required int productOptionId,
    required int packagingId,
    num? pricePerUnit,
    int? stockQuantity,
    required String optionSku,
    int? colorId,
  }) async {
    if (!validateMappingInputs(
      pricePerUnit: pricePerUnit,
      stockQuantity: stockQuantity,
      optionSku: optionSku,
    )) {
      return;
    }

    try {
      isSaving.value = true;

      if (mappingId == null) {
        await _service.createOptionPackaging(
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit!,
          stockQuantity: stockQuantity!,
          optionSku: optionSku.trim(),
          colorId: colorId,
        );
        Get.back();
        showMassage('Mapping created successfully', true);
        onSaved?.call();
      } else {
        await _service.updateOptionPackaging(
          id: mappingId,
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit!,
          stockQuantity: stockQuantity!,
          optionSku: optionSku.trim(),
          colorId: colorId,
        );
        Get.back();
        showMassage('Mapping updated successfully', true);
        onSaved?.call();
      }
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in saveMapping: ${e.message}');
    } catch (e) {
      showMassage('Failed to save mapping', false);
      log('Error in saveMapping: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteMapping(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteOptionPackaging(id);
      onSaved?.call();
      Get.back();
      showMassage('Mapping deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteMapping: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete mapping', false);
      log('Error in deleteMapping: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
