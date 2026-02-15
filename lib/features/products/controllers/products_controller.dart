import 'dart:developer';

import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  final ProductsService _productsService = ProductsService();
  final BrandsService _brandsService = BrandsService();
  final SubCategoryService _subCategoryService = SubCategoryService();

  // بيانات
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // بيانات مساعدة للفورم
  final RxList<BrandsModel> brands = <BrandsModel>[].obs;
  final RxList<AllSubCategoryModel> allSubCategories =
      <AllSubCategoryModel>[].obs;
  final RxBool isMetaLoading = false.obs;

  // فورم
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController arDescriptionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  // العلاقات
  final RxInt selectedBrandId = 0.obs;
  final RxInt selectedSubCategoryId = 0.obs;
  final RxInt selectedIsActive = 1.obs; // 1 = active

  // العنصر المحدد للتعديل
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);

  // البحث
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    getProducts();
    getFormMeta();
    super.onInit();
  }

  Future<void> getFormMeta() async {
    try {
      isMetaLoading.value = true;

      final results = await Future.wait([
        _brandsService.getBrands(),
        _subCategoryService.getAllSubCategories(),
      ]);

      brands.assignAll(results[0] as List<BrandsModel>);
      allSubCategories.assignAll(results[1] as List<AllSubCategoryModel>);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getFormMeta: ${e.message}');
    } catch (e) {
      showMassage('Failed to load brands/sub categories', false);
      log('Error in getFormMeta: $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    descriptionController.dispose();
    arDescriptionController.dispose();
    positionController.dispose();
    super.onClose();
  }

  // تحميل كل المنتجات
  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final fetched = await _productsService.getProducts();
      products.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getProducts: ${e.message}');
    } catch (e) {
      showMassage('Failed to load products', false);
      log('Error in getProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _productsService.createProduct(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        description: descriptionController.text.trim(),
        arDescription: arDescriptionController.text.trim(),
        brandId: selectedBrandId.value,
        subCategoryId: selectedSubCategoryId.value,
        imagePath: selectedImagePath.value,
      );

      await getProducts();
      clearForm();
      Get.back();
      showMassage('Product created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createProduct: ${e.message}');
    } catch (e) {
      showMassage('Failed to create product', false);
      log('Error in createProduct: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateProduct() async {
    if (selectedProduct.value == null || !_validateForm(requireImage: false)) {
      return;
    }

    try {
      isUpdating.value = true;

      await _productsService.updateProduct(
        id: selectedProduct.value!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        description: descriptionController.text.trim(),
        arDescription: arDescriptionController.text.trim(),
        brandId: selectedBrandId.value,
        subCategoryId: selectedSubCategoryId.value,
        isActive: selectedIsActive.value,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );

      await getProducts();
      clearForm();
      Get.back();
      showMassage('Product updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateProduct: ${e.message}');
    } catch (e) {
      showMassage('Failed to update product', false);
      log('Error in updateProduct: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      isDeleting.value = true;

      await _productsService.deleteProduct(id);
      await getProducts();

      showMassage('Product deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteProduct: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete product', false);
      log('Error in deleteProduct: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm({required bool requireImage}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter product title', false);
      return false;
    }

    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic product title', false);
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      showMassage('Please enter description', false);
      return false;
    }

    if (arDescriptionController.text.trim().isEmpty) {
      showMassage('Please enter Arabic description', false);
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      showMassage('Please enter position', false);
      return false;
    }

    if (selectedBrandId.value == 0) {
      showMassage('Please select brand', false);
      return false;
    }

    if (selectedSubCategoryId.value == 0) {
      showMassage('Please select sub category', false);
      return false;
    }

    if (requireImage && selectedImagePath.value.trim().isEmpty) {
      showMassage('Please select an image', false);
      return false;
    }

    return true;
  }

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    descriptionController.clear();
    arDescriptionController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedProduct.value = null;
    selectedBrandId.value = 0;
    selectedSubCategoryId.value = 0;
    selectedIsActive.value = 1;
  }

  void setProductForEdit(ProductModel product) {
    selectedProduct.value = product;
    titleController.text = product.title ?? '';
    arTitleController.text = product.arTitle ?? '';
    descriptionController.text = product.description ?? '';
    arDescriptionController.text = product.arDescription ?? '';
    positionController.text = product.position?.toString() ?? "";
    selectedImagePath.value = '';
    selectedBrandId.value = product.brandId ?? 0;
    selectedSubCategoryId.value = product.subCategoryId ?? 0;
    selectedIsActive.value = product.isActive ?? 1;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<ProductModel> get filteredProducts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return products.toList();

    return products.where((p) {
      final title = (p.title ?? '').toLowerCase();
      final arTitle = (p.arTitle ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedProduct.value != null;
  ProductModel? get currentProduct => selectedProduct.value;
}
