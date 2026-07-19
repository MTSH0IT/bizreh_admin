import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/features/products_sku/model/products_sku/products_sku.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/products_sku_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class ProductsSkuController extends GetxController {
  final ProductsSkuService _productsSkuService;

  ProductsSkuController({required ProductsSkuService productsSkuService})
    : _productsSkuService = productsSkuService;

  final RxList<ProductsSku> optionPackagings = <ProductsSku>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<ProductsSku?> selectedSku = Rx<ProductsSku?>(null);
  final TextEditingController skuController = TextEditingController();

  @override
  void onInit() {
    getOptionPackagings();
    super.onInit();
  }

  @override
  void onClose() {
    skuController.dispose();
    super.onClose();
  }

  Future<void> getOptionPackagings() async {
    try {
      isLoading.value = true;
      final fetched = await _productsSkuService.getOptionPackagings();
      optionPackagings.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getOptionPackagings: ${e.message}');
    } catch (e) {
      showMassage('Failed to load option packagings', false);
      log('Error in getOptionPackagings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<ProductsSku> get filteredOptionPackagings {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return optionPackagings;
    return optionPackagings.where((item) {
      final productName = (item.product?.title ?? '').toLowerCase();
      final arProductName = (item.product?.arTitle ?? '').toLowerCase();
      final optionName = (item.productOption?.optionName ?? '').toLowerCase();
      final packagingName = (item.packaging?.title ?? '').toLowerCase();
      final sku = (item.optionSku ?? '').toLowerCase();
      return productName.contains(q) ||
          arProductName.contains(q) ||
          optionName.contains(q) ||
          packagingName.contains(q) ||
          sku.contains(q);
    }).toList();
  }

  void setSkuForEdit(ProductsSku item) {
    selectedSku.value = item;
    skuController.text = item.optionSku ?? '';
  }

  void clearSkuForm() {
    skuController.clear();
    selectedSku.value = null;
  }

  Future<void> updateSku() async {
    final current = selectedSku.value;
    if (current?.id == null) return;
    if (skuController.text.trim().isEmpty) {
      showMassage('Please enter SKU', false);
      return;
    }

    try {
      isUpdating.value = true;
      await _productsSkuService.updateOptionPackagingSku(
        current!.id!,
        skuController.text.trim(),
      );
      await getOptionPackagings();
      clearSkuForm();
      Get.back();
      showMassage('SKU updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateSku: ${e.message}');
    } catch (e) {
      showMassage('Failed to update SKU', false);
      log('Error in updateSku: $e');
    } finally {
      isUpdating.value = false;
    }
  }
}
