import 'dart:developer';

import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/category/controllers/all_category_crud_controller.dart';
import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/discounts/models/discount_model/discount_model.dart';
import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/sub_category/controllers/all_sub_category_crud_controller.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/discounts_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountsController extends GetxController {
  final DiscountsService _discountsService = DiscountsService();
  final ProductsService _productsService = ProductsService();
  final BrandsService _brandsService = BrandsService();
  final CategoryService _categoryService = CategoryService();
  final SubCategoryService _subCategoryService = SubCategoryService();

  final RxList<DiscountModel> discounts = <DiscountModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxBool isMetaLoading = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<BrandsModel> brands = <BrandsModel>[].obs;
  final RxList<AllCategoryModel> categories = <AllCategoryModel>[].obs;
  final RxList<AllSubCategoryModel> subCategories = <AllSubCategoryModel>[].obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController minPurchaseAmountController =
      TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();

  final RxString selectedAmountType = 'fixed'.obs; // fixed | percentage
  final RxString selectedRoleType = 'all'.obs; // all
  final RxInt selectedIsActive = 1.obs; // 1 active

  final RxList<int> selectedProductIds = <int>[].obs;
  final RxList<int> selectedBrandIds = <int>[].obs;
  final RxList<int> selectedMainCategoryIds = <int>[].obs;
  final RxList<int> selectedSubCategoryIds = <int>[].obs;

  final Rx<DiscountModel?> selectedDiscount = Rx<DiscountModel?>(null);

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDiscounts();
    getMeta();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    amountController.dispose();
    minPurchaseAmountController.dispose();
    expirationDateController.dispose();
    super.onClose();
  }

  Future<void> getDiscounts() async {
    try {
      isLoading.value = true;
      final fetched = await _discountsService.getDiscounts();
      discounts.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getDiscounts: ${e.message}');
    } catch (e) {
      showMassage('Failed to load discounts', false);
      log('Error in getDiscounts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMeta() async {
    final productsController = Get.isRegistered<ProductsController>()
        ? Get.find<ProductsController>()
        : null;
    final brandsController = Get.isRegistered<BrandsController>()
        ? Get.find<BrandsController>()
        : null;
    final categoriesController = Get.isRegistered<AllCategoryCrudController>()
        ? Get.find<AllCategoryCrudController>()
        : null;
    final subCategoriesController =
        Get.isRegistered<AllSubCategoryCrudController>()
        ? Get.find<AllSubCategoryCrudController>()
        : null;

    if (productsController != null && productsController.products.isNotEmpty) {
      products.assignAll(productsController.products);
    }

    if (brandsController != null && brandsController.brands.isNotEmpty) {
      brands.assignAll(brandsController.brands);
    }

    if (categoriesController != null &&
        categoriesController.allCategories.isNotEmpty) {
      categories.assignAll(categoriesController.allCategories);
    }

    if (subCategoriesController != null &&
        subCategoriesController.allSubCategories.isNotEmpty) {
      subCategories.assignAll(subCategoriesController.allSubCategories);
    }

    if (products.isNotEmpty &&
        brands.isNotEmpty &&
        categories.isNotEmpty &&
        subCategories.isNotEmpty) {
      return;
    }

    try {
      isMetaLoading.value = true;

      final futures = <Future<dynamic>>[];
      final keys = <String>[];

      if (products.isEmpty) {
        futures.add(_productsService.getProducts());
        keys.add('products');
      }
      if (brands.isEmpty) {
        futures.add(_brandsService.getBrands());
        keys.add('brands');
      }
      if (categories.isEmpty) {
        futures.add(_categoryService.getAllCategories());
        keys.add('categories');
      }
      if (subCategories.isEmpty) {
        futures.add(_subCategoryService.getAllSubCategories());
        keys.add('subCategories');
      }

      final results = await Future.wait(futures);

      for (var i = 0; i < results.length; i++) {
        switch (keys[i]) {
          case 'products':
            products.assignAll(results[i] as List<ProductModel>);
            break;
          case 'brands':
            brands.assignAll(results[i] as List<BrandsModel>);
            break;
          case 'categories':
            categories.assignAll(results[i] as List<AllCategoryModel>);
            break;
          case 'subCategories':
            subCategories.assignAll(results[i] as List<AllSubCategoryModel>);
            break;
        }
      }
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getMeta: ${e.message}');
    } catch (e) {
      showMassage('Failed to load products/brands/categories', false);
      log('Error in getMeta: $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  void setSearchQuery(String q) => searchQuery.value = q;

  List<DiscountModel> get filteredDiscounts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return discounts.toList();
    return discounts.where((d) {
      final title = (d.title ?? '').toLowerCase();
      final arTitle = (d.arTitle ?? '').toLowerCase();
      final type = (d.type ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q) || type.contains(q);
    }).toList();
  }

  bool get isEditing => selectedDiscount.value != null;
  DiscountModel? get currentDiscount => selectedDiscount.value;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    amountController.clear();
    minPurchaseAmountController.clear();
    expirationDateController.clear();

    selectedAmountType.value = 'fixed';
    selectedRoleType.value = 'all';
    selectedIsActive.value = 1;

    selectedProductIds.clear();
    selectedBrandIds.clear();
    selectedMainCategoryIds.clear();
    selectedSubCategoryIds.clear();

    selectedDiscount.value = null;
  }

  void setAmountType(String? v) {
    if (v == null || v.isEmpty) return;
    selectedAmountType.value = v;
  }

  void setRoleType(String? v) {
    if (v == null || v.isEmpty) return;
    selectedRoleType.value = v;
  }

  void setIsActive(int? v) {
    if (v == null) return;
    selectedIsActive.value = v;
  }

  void setSelectedProducts(List<int> ids) {
    selectedProductIds.assignAll(ids);
  }

  void setSelectedBrands(List<int> ids) {
    selectedBrandIds.assignAll(ids);
  }

  void setSelectedMainCategories(List<int> ids) {
    selectedMainCategoryIds.assignAll(ids);
  }

  void setSelectedSubCategories(List<int> ids) {
    selectedSubCategoryIds.assignAll(ids);
  }

  void setDiscountForEdit(DiscountModel discount) {
    selectedDiscount.value = discount;
    titleController.text = discount.title ?? '';
    arTitleController.text = discount.arTitle ?? '';
    amountController.text = discount.amount?.toString() ?? '';
    minPurchaseAmountController.text = discount.minPurchaseAmount ?? '';
    expirationDateController.text = discount.exprationDate == null
        ? ''
        : discount.exprationDate!.toIso8601String().split('T').first;

    selectedAmountType.value = discount.amountType ?? 'fixed';
    selectedRoleType.value = discount.roleType ?? 'all';
    selectedIsActive.value = discount.isActive ?? 1;

    final productsIds = (discount.products ?? [])
        .map((p) => p.id)
        .whereType<int>()
        .toList();
    selectedProductIds.assignAll(productsIds);

    final brandsIds = (discount.brands ?? [])
        .map((b) => b.id)
        .whereType<int>()
        .toList();
    selectedBrandIds.assignAll(brandsIds);

    final mainIds = (discount.categories ?? [])
        .where((c) => c.categoryId != null && c.categoryType == 'main')
        .map((c) => c.categoryId)
        .whereType<int>()
        .toList();
    selectedMainCategoryIds.assignAll(mainIds);

    final subIds = (discount.categories ?? [])
        .where((c) => c.categoryId != null && c.categoryType == 'sub')
        .map((c) => c.categoryId)
        .whereType<int>()
        .toList();
    selectedSubCategoryIds.assignAll(subIds);
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter title', false);
      return false;
    }
    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic title', false);
      return false;
    }
    if (amountController.text.trim().isEmpty) {
      showMassage('Please enter amount', false);
      return false;
    }
    if (minPurchaseAmountController.text.trim().isEmpty) {
      showMassage('Please enter min purchase amount', false);
      return false;
    }
    if (expirationDateController.text.trim().isEmpty) {
      showMassage('Please select expiration date', false);
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildBody() {
    final categoryIds = <Map<String, dynamic>>[
      ...selectedMainCategoryIds.map(
        (id) => {'category_id': id, 'category_type': 'main'},
      ),
      ...selectedSubCategoryIds.map(
        (id) => {'category_id': id, 'category_type': 'sub'},
      ),
    ];

    return {
      'title': titleController.text.trim(),
      'ar_title': arTitleController.text.trim(),
      'amount':
          int.tryParse(amountController.text.trim()) ??
          double.tryParse(amountController.text.trim()) ??
          amountController.text.trim(),
      'amount_type': selectedAmountType.value,
      'min_purchase_amount':
          int.tryParse(minPurchaseAmountController.text.trim()) ??
          minPurchaseAmountController.text.trim(),
      'expration_date': expirationDateController.text.trim(),
      'role_type': selectedRoleType.value,
      'is_active': selectedIsActive.value,
      'product_ids': selectedProductIds.toList(),
      'brand_ids': selectedBrandIds.toList(),
      'category_ids': categoryIds,
    };
  }

  Future<void> createDiscount() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _discountsService.createDiscount(body: _buildBody());
      await getDiscounts();
      clearForm();
      Get.back();
      showMassage('Discount created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createDiscount: ${e.message}');
    } catch (e) {
      showMassage('Failed to create discount', false);
      log('Error in createDiscount: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateDiscount() async {
    final current = selectedDiscount.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _discountsService.updateDiscount(
        id: current!.id!,
        body: _buildBody(),
      );
      await getDiscounts();
      clearForm();
      Get.back();
      showMassage('Discount updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateDiscount: ${e.message}');
    } catch (e) {
      showMassage('Failed to update discount', false);
      log('Error in updateDiscount: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteDiscount(int id) async {
    try {
      isDeleting.value = true;
      await _discountsService.deleteDiscount(id);
      await getDiscounts();
      showMassage('Discount deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteDiscount: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete discount', false);
      log('Error in deleteDiscount: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
