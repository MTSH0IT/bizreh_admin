import 'dart:developer';

import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/features/points/models/point_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/packaging_service.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class PointsController extends GetxController {
  final PointsService _pointsService = sl<PointsService>();
  final BrandsService _brandsService = sl<BrandsService>();
  final PackagingService _packagingService = sl<PackagingService>();

  final RxList<PointModel> pointsOffers = <PointModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxBool isMetaLoading = false.obs;
  final RxList<BrandsModel> brands = <BrandsModel>[].obs;
  final RxList<PackageModel> packagings = <PackageModel>[].obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController pointsPerUnitController = TextEditingController();
  final TextEditingController minQuantityController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final RxInt selectedBrandId = RxInt(0);
  final RxInt selectedPackagingId = RxInt(0);
  final RxInt selectedIsActive = 1.obs;

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
    pointsPerUnitController.dispose();
    minQuantityController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  Future<void> getMeta() async {
    final brandsController = Get.isRegistered<BrandsController>()
        ? Get.find<BrandsController>()
        : null;

    if (brandsController != null && brandsController.brands.isNotEmpty) {
      brands.assignAll(brandsController.brands);
    }

    if (brands.isNotEmpty && packagings.isNotEmpty) {
      return;
    }

    try {
      isMetaLoading.value = true;

      final futures = <Future<dynamic>>[];
      final keys = <String>[];

      if (brands.isEmpty) {
        futures.add(_brandsService.getBrands());
        keys.add('brands');
      }
      if (packagings.isEmpty) {
        futures.add(_packagingService.getPackagings());
        keys.add('packagings');
      }

      final results = await Future.wait(futures);

      for (var i = 0; i < results.length; i++) {
        switch (keys[i]) {
          case 'brands':
            brands.assignAll(results[i] as List<BrandsModel>);
            break;
          case 'packagings':
            packagings.assignAll(results[i] as List<PackageModel>);
            break;
        }
      }
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getMeta: ${e.message}');
    } catch (e) {
      showMassage('Failed to load brands/packagings', false);
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
      final brand = (p.brandTitle ?? '').toLowerCase();
      final packaging = (p.packagingTitle ?? '').toLowerCase();
      return title.contains(q) ||
          arTitle.contains(q) ||
          brand.contains(q) ||
          packaging.contains(q);
    }).toList();
  }

  bool get isEditing => selectedPointOffer.value != null;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    pointsPerUnitController.clear();
    minQuantityController.clear();
    startDateController.clear();
    endDateController.clear();

    selectedBrandId.value = 0;
    selectedPackagingId.value = 0;
    selectedIsActive.value = 1;

    selectedPointOffer.value = null;
  }

  void setIsActive(int? v) {
    if (v == null) return;
    selectedIsActive.value = v;
  }

  void setSelectedBrandId(int? id) {
    if (id == null) return;
    selectedBrandId.value = id;
  }

  void setSelectedPackagingId(int? id) {
    if (id == null) return;
    selectedPackagingId.value = id;
  }

  void setPointForEdit(PointModel point) {
    selectedPointOffer.value = point;

    titleController.text = point.title ?? '';
    arTitleController.text = point.arTitle ?? '';
    pointsPerUnitController.text = point.pointsPerUnit?.toString() ?? '';
    minQuantityController.text = point.minQuantity?.toString() ?? '';
    startDateController.text = point.startDate == null
        ? ''
        : point.startDate!
              .toIso8601String()
              .replaceFirst('T', ' ')
              .split('.')
              .first;
    endDateController.text = point.endDate == null
        ? ''
        : point.endDate!
              .toIso8601String()
              .replaceFirst('T', ' ')
              .split('.')
              .first;

    selectedBrandId.value = point.brandId ?? 0;
    selectedPackagingId.value = point.packagingId ?? 0;
    selectedIsActive.value = point.isActive ?? 1;
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
    if (selectedBrandId.value <= 0) {
      showMassage('Please select brand', false);
      return false;
    }
    if (selectedPackagingId.value <= 0) {
      showMassage('Please select packaging', false);
      return false;
    }
    if (pointsPerUnitController.text.trim().isEmpty) {
      showMassage('Please enter points per unit', false);
      return false;
    }
    if (minQuantityController.text.trim().isEmpty) {
      showMassage('Please enter min quantity', false);
      return false;
    }
    if (startDateController.text.trim().isEmpty) {
      showMassage('Please select start date', false);
      return false;
    }
    if (endDateController.text.trim().isEmpty) {
      showMassage('Please select end date', false);
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildBody() {
    final body = <String, dynamic>{
      'title': titleController.text.trim(),
      'ar_title': arTitleController.text.trim(),
      'brand_id': selectedBrandId.value,
      'packaging_id': selectedPackagingId.value,
      'points_per_unit':
          int.tryParse(pointsPerUnitController.text.trim()) ??
          pointsPerUnitController.text.trim(),
      'min_quantity':
          int.tryParse(minQuantityController.text.trim()) ??
          minQuantityController.text.trim(),
      'start_date': startDateController.text.trim(),
      'end_date': endDateController.text.trim(),
      'is_active': selectedIsActive.value,
    };

    return body;
  }

  Future<void> createPointsOffer() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _pointsService.createPointsOffer(body: _buildBody());
      await getPointsOffers();
      clearForm();
      Get.back();
      showMassage('Points offer created successfully', true);
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
      Get.back();
      showMassage('Points offer updated successfully', true);
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
