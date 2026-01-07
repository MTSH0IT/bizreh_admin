import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/features/SuperCategory/models/super_category_model.dart';
import 'package:bizreh_admin/services/super_category_service.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';

class SuperCategoryController extends GetxController {
  final SuperCategoryService _superCategoryService = SuperCategoryService();

  // Reactive variables
  final RxList<SuperCategoryModel> superCategories = <SuperCategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  // Selected super category for editing
  final Rx<SuperCategoryModel?> selectedSuperCategory = Rx<SuperCategoryModel?>(
    null,
  );

  // Search functionality
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSuperCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  // Fetch all super categories
  Future<void> getSuperCategories() async {
    try {
      isLoading.value = true;

      final fetchedSuperCategories = await _superCategoryService
          .getSuperCategories();
      superCategories.assignAll(fetchedSuperCategories);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getSuperCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load super categories', false);
      log('Error in getSuperCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Create new super category
  Future<void> createSuperCategory() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _superCategoryService.createSuperCategory(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        imagePath: selectedImagePath.value,
      );
      getSuperCategories();
      clearForm();
      //showMassage('Super category created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createSuperCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to create super category', false);
      log('Error in createSuperCategory: $e');
    } finally {
      isCreating.value = false;
    }
  }

  // Update existing super category
  Future<void> updateSuperCategory() async {
    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;

      await _superCategoryService.updateSuperCategory(
        id: selectedSuperCategory.value!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );
      getSuperCategories();

      clearForm();
      showMassage('Super category updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateSuperCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to update super category', false);
      log('Error in updateSuperCategory: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete super category
  Future<void> deleteSuperCategory(int id) async {
    try {
      isDeleting.value = true;

      await _superCategoryService.deleteSuperCategory(id);
      getSuperCategories(); // Refresh data from server
      showMassage('Super category deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteSuperCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete super category', false);
      log('Error in deleteSuperCategory: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  // Form validation
  bool _validateForm({bool requireImage = false}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter title', false);
      return false;
    }

    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic title', false);
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      showMassage('Please enter position', false);
      return false;
    }

    if (requireImage && selectedImagePath.value.isEmpty) {
      showMassage('Please select an image', false);
      return false;
    }

    return true;
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedSuperCategory.value = null;
  }

  // Set super category for editing
  void setSuperCategoryForEdit(SuperCategoryModel superCategory) {
    selectedSuperCategory.value = superCategory;
    titleController.text = superCategory.title ?? '';
    arTitleController.text = superCategory.arTitle ?? '';
    positionController.text = superCategory.position?.toString() ?? '';
    selectedImagePath.value =
        ''; // Clear image path - only set when user picks new image
  }

  // Set image path
  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  // Search methods
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Get filtered super categories
  List<SuperCategoryModel> get filteredSuperCategories {
    if (searchQuery.value.isEmpty) {
      return superCategories;
    }

    final query = searchQuery.value.toLowerCase();
    return superCategories.where((category) {
      final title = category.title?.toLowerCase() ?? '';
      final arTitle = category.arTitle?.toLowerCase() ?? '';
      return title.contains(query) || arTitle.contains(query);
    }).toList();
  }

  // Getters
  bool get isEditing => selectedSuperCategory.value != null;
  SuperCategoryModel? get currentSuperCategory => selectedSuperCategory.value;
}
