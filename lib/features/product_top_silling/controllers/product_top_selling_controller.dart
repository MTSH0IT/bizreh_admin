import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/product_top_selling.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class ProductTopSellingController extends GetxController {
  final ProductTopSellingService _service = ProductTopSellingService();

  final RxList<ProductModel> products = <ProductModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isAdding = false.obs;
  final RxBool isDeleting = false.obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getTopSellingProducts();
  }

  bool isTopSelling(int? productId) {
    if (productId == null) return false;
    for (final p in products) {
      if (p.id == productId) return true;
    }
    return false;
  }

  Future<void> toggleTopSelling(ProductModel product) async {
    final id = product.id;
    if (id == null) return;

    if (isTopSelling(id)) {
      await removeTopSelling(product);
    } else {
      await addTopSelling(product);
    }
  }

  Future<void> getTopSellingProducts() async {
    try {
      isLoading.value = true;
      final data = await _service.getTopSellingProducts();
      products.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getTopSellingProducts: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch top selling products', false);
      log('Error in getTopSellingProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTopSelling(ProductModel product) async {
    final id = product.id;
    if (id == null) return;

    try {
      isAdding.value = true;
      await _service.addTopSellingProduct(productId: id);
      await getTopSellingProducts();
      showMassage('Product added to top selling successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in addTopSelling: ${e.message}');
    } catch (e) {
      showMassage('Failed to add product to top selling', false);
      log('Error in addTopSelling: $e');
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> removeTopSelling(ProductModel product) async {
    final id = product.id;
    if (id == null) return;

    try {
      isDeleting.value = true;
      await _service.deleteTopSellingProduct(id);
      await getTopSellingProducts();
      showMassage('Product removed from top selling', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in removeTopSelling: ${e.message}');
    } catch (e) {
      showMassage('Failed to remove product from top selling', false);
      log('Error in removeTopSelling: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<ProductModel> get filteredProducts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return products.toList();

    return products.where((p) {
      final t = (p.title ?? '').toLowerCase();
      final at = (p.arTitle ?? '').toLowerCase();
      return t.contains(q) || at.contains(q);
    }).toList();
  }
}
