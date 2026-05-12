import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model/option.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/products_option_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductOptionsController extends GetxController {
  final ProductsOptionService _service;
  final ProductsService _productsService;

  final ProductModel product;

  ProductOptionsController({
    required this.product,
    required ProductsOptionService service,
    required ProductsService productsService,
  }) : _service = service,
       _productsService = productsService;

  final RxList<Option> options = <Option>[].obs;

  final TextEditingController optionNameController = TextEditingController();
  final TextEditingController arOptionNameController = TextEditingController();
  final RxString mainImagePath = ''.obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isReloading = false.obs;

  final Rx<Option?> selectedOption = Rx<Option?>(null);

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
    super.onClose();
  }

  void loadFromProduct() {
    options.assignAll(product.options ?? <Option>[]);
  }

  Future<void> reloadFromServer() async {
    if (productId == 0) return;

    try {
      isReloading.value = true;

      final ProductModel? updated = await _productsService.getProductById(
        productId,
      );

      if (updated?.options != null) {
        product.options = updated!.options;
        loadFromProduct();
      }
    } catch (e) {
      log('Error in reloadFromServer: $e');
    } finally {
      isReloading.value = false;
    }
  }

  void setOptionForEdit(Option option) {
    selectedOption.value = option;
    optionNameController.text = option.optionName ?? '';
    arOptionNameController.text = option.arOptionName ?? '';
    mainImagePath.value = '';
  }

  void clearForm() {
    optionNameController.clear();
    arOptionNameController.clear();
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
        productId: productId,
        mainImagePath: mainImagePath.value.isNotEmpty
            ? mainImagePath.value
            : null,
      );

      Get.back();
      showMassage('Option created successfully', true);
      clearForm();
      await reloadFromServer();
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
        productId: productId,
        mainImagePath: mainImagePath.value.isNotEmpty
            ? mainImagePath.value
            : null,
      );

      Get.back();
      showMassage('Option updated successfully', true);
      clearForm();
      await reloadFromServer();
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
      await reloadFromServer();
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
