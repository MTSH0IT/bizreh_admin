import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/products_option_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsOptionsController extends GetxController {
  final ProductsOptionService _service = ProductsOptionService();
  final ProductModel product;

  ProductsOptionsController({required this.product});

  final RxList<Map<String, dynamic>> options = <Map<String, dynamic>>[].obs;

  final TextEditingController optionNameController = TextEditingController();
  final TextEditingController arOptionNameController = TextEditingController();
  final TextEditingController optionSkuController = TextEditingController();
  final RxString mainImagePath = ''.obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final Rx<Map<String, dynamic>?> selectedOption = Rx<Map<String, dynamic>?>(
    null,
  );

  int get productId => product.id ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadFromProduct();
  }

  @override
  void onClose() {
    optionNameController.dispose();
    arOptionNameController.dispose();
    optionSkuController.dispose();
    super.onClose();
  }

  void loadFromProduct() {
    final raw = product.options ?? <dynamic>[];
    options.assignAll(raw.whereType<Map<String, dynamic>>().toList());
  }

  void setOptionForEdit(Map<String, dynamic> option) {
    selectedOption.value = option;
    optionNameController.text = option['option_name'] ?? '';
    arOptionNameController.text = option['ar_option_name'] ?? '';
    optionSkuController.text = option['option_sku'] ?? '';
    mainImagePath.value = '';
  }

  void clearForm() {
    optionNameController.clear();
    arOptionNameController.clear();
    optionSkuController.clear();
    mainImagePath.value = '';
    selectedOption.value = null;
  }

  void setImagePath(String path) {
    mainImagePath.value = path;
  }

  bool _validateForm({required bool requireImage}) {
    if (optionNameController.text.trim().isEmpty) {
      showMassage('Please enter option name', false);
      return false;
    }

    if (arOptionNameController.text.trim().isEmpty) {
      showMassage('Please enter Arabic option name', false);
      return false;
    }

    if (optionSkuController.text.trim().isEmpty) {
      showMassage('Please enter option sku', false);
      return false;
    }

    if (productId == 0) {
      showMassage('Product id is missing', false);
      return false;
    }

    if (requireImage && mainImagePath.value.trim().isEmpty) {
      showMassage('Please select main image', false);
      return false;
    }

    return true;
  }

  Future<void> createOption() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _service.createProductOption(
        optionName: optionNameController.text.trim(),
        arOptionName: arOptionNameController.text.trim(),
        optionSku: optionSkuController.text.trim(),
        productId: productId,
        mainImagePath: mainImagePath.value.isNotEmpty
            ? mainImagePath.value
            : null,
      );

      showMassage('Option created successfully', true);
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createOption: ${e.message}');
    } catch (e) {
      showMassage('Failed to create option', false);
      log('Error in createOption: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateOption(int id) async {
    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;

      await _service.updateProductOption(
        id: id,
        optionName: optionNameController.text.trim(),
        arOptionName: arOptionNameController.text.trim(),
        optionSku: optionSkuController.text.trim(),
        productId: productId,
        mainImagePath: mainImagePath.value.isNotEmpty
            ? mainImagePath.value
            : null,
      );

      showMassage('Option updated successfully', true);
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateOption: ${e.message}');
    } catch (e) {
      showMassage('Failed to update option', false);
      log('Error in updateOption: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteOption(int id) async {
    try {
      isDeleting.value = true;

      await _service.deleteProductOption(id);
      showMassage('Option deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteOption: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete option', false);
      log('Error in deleteOption: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool get isEditing => selectedOption.value != null;
}
