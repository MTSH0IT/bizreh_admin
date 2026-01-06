import 'dart:developer';

import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/option_packaging_servise.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class OptionPackagingController extends GetxController {
  final OptionPackagingService _service = OptionPackagingService();

  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  Future<void> saveMapping({
    int? mappingId,
    required int productOptionId,
    required int packagingId,
    required num pricePerUnit,
    required int stockQuantity,
  }) async {
    try {
      isSaving.value = true;

      if (mappingId == null) {
        await _service.createOptionPackaging(
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit,
          stockQuantity: stockQuantity,
        );
        showMassage('Mapping created successfully', true);
      } else {
        await _service.updateOptionPackaging(
          id: mappingId,
          productOptionId: productOptionId,
          packagingId: packagingId,
          pricePerUnit: pricePerUnit,
          stockQuantity: stockQuantity,
        );
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
