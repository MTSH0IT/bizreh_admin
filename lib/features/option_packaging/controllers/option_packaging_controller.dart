import 'dart:developer';

import 'package:bizreh_admin/features/color_family/models/color_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/color_servise.dart';
import 'package:bizreh_admin/services/option_packaging_servise.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class OptionPackagingController extends GetxController {
  final OptionPackagingService _service = OptionPackagingService();
  final ColorService _colorService = ColorService();

  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxBool isColorsLoading = false.obs;
  final RxInt selectedColorId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadColors();
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

  Future<void> saveMapping({
    int? mappingId,
    required int productOptionId,
    required int packagingId,
    required num pricePerUnit,
    required int stockQuantity,
    required int colorId,
  }) async {
    try {
      isSaving.value = true;

      if (mappingId == null) {
        await _service.createOptionPackaging(
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit,
          stockQuantity: stockQuantity,
          colorId: colorId,
        );
        Get.back();
        showMassage('Mapping created successfully', true);
      } else {
        await _service.updateOptionPackaging(
          id: mappingId,
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit,
          stockQuantity: stockQuantity,
          colorId: colorId,
        );
        Get.back();
        showMassage('Mapping updated successfully', true);
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
