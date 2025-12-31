import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';

class BrandsController extends GetxController {
  final BrandsService _brandsService = BrandsService();

  // Reactive variables
  final RxList<BrandsModel> brands = <BrandsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  // Selected brand for editing
  final Rx<BrandsModel?> selectedBrand = Rx<BrandsModel?>(null);

  // Search functionality
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getBrands();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  // Fetch all brands
  Future<void> getBrands() async {
    try {
      isLoading.value = true;

      final fetchedBrands = await _brandsService.getBrands();
      brands.assignAll(fetchedBrands);

      log('Successfully fetched ${fetchedBrands.length} brands');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in fetchBrands: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch brands', false);
      log('Error in fetchBrands: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create new brand
  Future<void> createBrand() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _brandsService.createBrand(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        imagePath: selectedImagePath.value,
      );
      getBrands();
      clearForm();
      //showMassage('Brand created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createBrand: ${e.message}');
    } catch (e) {
      showMassage('Failed to create brand', false);
      log('Error in createBrand: $e');
    } finally {
      isCreating.value = false;
    }
  }

  // Update existing brand
  Future<void> updateBrand() async {
    if (selectedBrand.value == null || !_validateForm(requireImage: false)) {
      return;
    }

    try {
      isUpdating.value = true;

      await _brandsService.updateBrand(
        id: selectedBrand.value!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );
      getBrands();

      clearForm();
      //showMassage('Brand updated successfully', true);
      //Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateBrand: ${e.message}');
    } catch (e) {
      showMassage('Failed to update brand', false);
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete brand
  Future<void> deleteBrand(int brandId) async {
    try {
      isDeleting.value = true;

      await _brandsService.deleteBrand(brandId);
      getBrands(); // Refresh data from server

      showMassage('Brand deleted successfully', true);
      log('Successfully deleted brand with ID: $brandId');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteBrand: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete brand', false);
      log('Error in deleteBrand: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  // Get brand products
  // Future<List<dynamic>> getBrandProducts(int brandId) async {
  //   try {
  //     return await _brandsService.getBrandProducts(brandId);
  //   } catch (e) {
  //     log('Error in getBrandProducts: $e');
  //     showMassage('Failed to fetch brand products', false);
  //     return [];
  //   }
  // }

  // Form helpers
  bool _validateForm({required bool requireImage}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter brand title', false);
      return false;
    }
    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic brand title', false);
      return false;
    }
    if (positionController.text.trim().isEmpty) {
      showMassage('Please enter position', false);
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
    positionController.clear();
    selectedImagePath.value = '';
    selectedBrand.value = null;
  }

  void setBrandForEdit(BrandsModel brand) {
    selectedBrand.value = brand;
    titleController.text = brand.title ?? '';
    arTitleController.text = brand.arTitle ?? '';
    positionController.text = brand.position?.toString() ?? '';
    selectedImagePath.value =
        ''; // Clear image path - only set when user picks new image
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  // Search methods
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<BrandsModel> get filteredBrands {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return brands.toList();

    return brands.where((b) {
      final title = (b.title ?? '').toLowerCase();
      final arTitle = (b.arTitle ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  // Getters
  bool get isEditing => selectedBrand.value != null;
  BrandsModel? get currentBrand => selectedBrand.value;
}
