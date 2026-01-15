import 'dart:developer';

import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/points/models/point_model/point_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsController extends GetxController {
  final PointsService _pointsService = PointsService();
  final ProductsService _productsService = ProductsService();
  final BrandsService _brandsService = BrandsService();
  final CategoryService _categoryService = CategoryService();
  final SubCategoryService _subCategoryService = SubCategoryService();

  final RxList<PointModel> pointsOffers = <PointModel>[].obs;
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
  final TextEditingController pointsAmountController = TextEditingController();
  final TextEditingController minPurchaseAmountController =
      TextEditingController();
  final TextEditingController maxPointsPerUserController =
      TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();

  final RxString selectedAmountType = 'fixed'.obs; // fixed | percentage
  final RxString selectedRoleType = 'all'.obs;
  final RxInt selectedIsActive = 1.obs;

  final RxList<int> selectedProductIds = <int>[].obs;
  final RxList<int> selectedBrandIds = <int>[].obs;
  final RxList<int> selectedMainCategoryIds = <int>[].obs;
  final RxList<int> selectedSubCategoryIds = <int>[].obs;

  final Rx<PointModel?> selectedPointOffer = Rx<PointModel?>(null);

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPointsOffers();
    getMeta();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    pointsAmountController.dispose();
    minPurchaseAmountController.dispose();
    maxPointsPerUserController.dispose();
    expirationDateController.dispose();
    super.onClose();
  }

  Future<void> getMeta() async {
    try {
      isMetaLoading.value = true;

      final results = await Future.wait([
        _productsService.getProducts(),
        _brandsService.getBrands(),
        _categoryService.getAllCategories(),
        _subCategoryService.getAllSubCategories(),
      ]);

      products.assignAll(results[0] as List<ProductModel>);
      brands.assignAll(results[1] as List<BrandsModel>);
      categories.assignAll(results[2] as List<AllCategoryModel>);
      subCategories.assignAll(results[3] as List<AllSubCategoryModel>);
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

  Future<void> getPointsOffers() async {
    try {
      isLoading.value = true;
      final fetched = await _pointsService.getPointsOffers();
      pointsOffers.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getPointsOffers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load points offers', false);
      log('Error in getPointsOffers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String q) => searchQuery.value = q;

  List<PointModel> get filteredPointsOffers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return pointsOffers.toList();
    return pointsOffers.where((p) {
      final title = (p.title ?? '').toLowerCase();
      final arTitle = (p.arTitle ?? '').toLowerCase();
      final type = (p.type ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q) || type.contains(q);
    }).toList();
  }

  bool get isEditing => selectedPointOffer.value != null;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    pointsAmountController.clear();
    minPurchaseAmountController.clear();
    maxPointsPerUserController.clear();
    expirationDateController.clear();

    selectedAmountType.value = 'fixed';
    selectedRoleType.value = 'all';
    selectedIsActive.value = 1;

    selectedProductIds.clear();
    selectedBrandIds.clear();
    selectedMainCategoryIds.clear();
    selectedSubCategoryIds.clear();

    selectedPointOffer.value = null;
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

  void setSelectedProducts(List<int> ids) => selectedProductIds.assignAll(ids);

  void setSelectedBrands(List<int> ids) => selectedBrandIds.assignAll(ids);

  void setSelectedMainCategories(List<int> ids) =>
      selectedMainCategoryIds.assignAll(ids);

  void setSelectedSubCategories(List<int> ids) =>
      selectedSubCategoryIds.assignAll(ids);

  void setPointForEdit(PointModel point) {
    selectedPointOffer.value = point;

    titleController.text = point.title ?? '';
    arTitleController.text = point.arTitle ?? '';
    pointsAmountController.text = point.pointsAmount?.toString() ?? '';
    minPurchaseAmountController.text = point.minPurchaseAmount ?? '';
    maxPointsPerUserController.text = point.maxPointsPerUser?.toString() ?? '';
    expirationDateController.text = point.exprationDate == null
        ? ''
        : point.exprationDate!.toIso8601String().split('T').first;

    selectedAmountType.value = point.amountType ?? 'fixed';
    selectedRoleType.value = point.roleType ?? 'all';
    selectedIsActive.value = point.isActive ?? 1;

    final productsIds = (point.products ?? [])
        .map((p) => p.id)
        .whereType<int>()
        .toList();
    selectedProductIds.assignAll(productsIds);

    final brandsIds = (point.brands ?? [])
        .map((b) => b.id)
        .whereType<int>()
        .toList();
    selectedBrandIds.assignAll(brandsIds);

    final mainIds = (point.categories ?? [])
        .where((c) => c.categoryId != null && c.categoryType == 'main')
        .map((c) => c.categoryId)
        .whereType<int>()
        .toList();
    selectedMainCategoryIds.assignAll(mainIds);

    final subIds = (point.categories ?? [])
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
    if (pointsAmountController.text.trim().isEmpty) {
      showMassage('Please enter points amount', false);
      return false;
    }
    if (minPurchaseAmountController.text.trim().isEmpty) {
      showMassage('Please enter min purchase amount', false);
      return false;
    }
    if (maxPointsPerUserController.text.trim().isEmpty) {
      showMassage('Please enter max points per user', false);
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

    final body = <String, dynamic>{
      'title': titleController.text.trim(),
      'ar_title': arTitleController.text.trim(),
      'points_amount':
          int.tryParse(pointsAmountController.text.trim()) ??
          pointsAmountController.text.trim(),
      'amount_type': selectedAmountType.value,
      'min_purchase_amount':
          int.tryParse(minPurchaseAmountController.text.trim()) ??
          minPurchaseAmountController.text.trim(),
      'max_points_per_user':
          int.tryParse(maxPointsPerUserController.text.trim()) ??
          maxPointsPerUserController.text.trim(),
      'expration_date': expirationDateController.text.trim(),
      'role_type': selectedRoleType.value,
      'is_active': selectedIsActive.value,
    };

    if (selectedProductIds.isNotEmpty) {
      body['product_ids'] = selectedProductIds.toList();
    }
    if (selectedBrandIds.isNotEmpty) {
      body['brand_ids'] = selectedBrandIds.toList();
    }
    if (categoryIds.isNotEmpty) {
      body['category_ids'] = categoryIds;
    }

    return body;
  }

  Future<void> createPointsOffer() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _pointsService.createPointsOffer(body: _buildBody());
      await getPointsOffers();
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createPointsOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to create points offer', false);
      log('Error in createPointsOffer: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updatePointsOffer() async {
    final current = selectedPointOffer.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _pointsService.updatePointsOffer(
        id: current!.id!,
        body: _buildBody(),
      );
      await getPointsOffers();
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updatePointsOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to update points offer', false);
      log('Error in updatePointsOffer: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deletePointsOffer(int id) async {
    try {
      isDeleting.value = true;
      await _pointsService.deletePointsOffer(id);
      await getPointsOffers();
      showMassage('Points offer deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deletePointsOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete points offer', false);
      log('Error in deletePointsOffer: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
