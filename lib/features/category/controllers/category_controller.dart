import 'dart:developer';

import 'package:bizreh_admin/features/category/models/category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = sl<CategoryService>();

  // Reactive data
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  // Super category relation
  final RxInt selectedSuperCategoryId = 0.obs;

  // Selected category for editing
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  // Search
  final RxString searchQuery = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  // Load categories for a given super category
  Future<void> getCategories(int superCategoryId) async {
    try {
      isLoading.value = true;
      selectedSuperCategoryId.value = superCategoryId;

      final fetched = await _categoryService.getCategories(superCategoryId);
      categories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load categories', false);
      log('Error in getCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCategory() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _categoryService.createCategory(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        superCategoryId: selectedSuperCategoryId.value,
        imagePath: selectedImagePath.value,
      );

      await getCategories(selectedSuperCategoryId.value);
      clearForm();
      Get.back();
      showMassage('Category created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to create category', false);
      log('Error in createCategory: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateCategory() async {
    if (selectedCategory.value == null || !_validateForm(requireImage: false)) {
      return;
    }

    try {
      isUpdating.value = true;

      await _categoryService.updateCategory(
        id: selectedCategory.value!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        superCategoryId: selectedSuperCategoryId.value,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );

      await getCategories(selectedSuperCategoryId.value);
      clearForm();
      Get.back();
      showMassage('Category updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to update category', false);
      log('Error in updateCategory: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      isDeleting.value = true;

      await _categoryService.deleteCategory(id);
      await getCategories(selectedSuperCategoryId.value);

      showMassage('Category deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete category', false);
      log('Error in deleteCategory: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm({required bool requireImage}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter category title', false);
      return false;
    }

    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic category title', false);
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      showMassage('Please enter position', false);
      return false;
    }

    if (selectedSuperCategoryId.value == 0) {
      showMassage('Please select super category', false);
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
    selectedCategory.value = null;
  }

  void setCategoryForEdit(CategoryModel category) {
    selectedCategory.value = category;
    titleController.text = category.title ?? '';
    arTitleController.text = category.arTitle ?? '';
    positionController.text = category.position?.toString() ?? '';
    selectedImagePath.value = '';
    selectedSuperCategoryId.value = category.superCategoryId ?? 0;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<CategoryModel> get filteredCategories {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return categories.toList();

    return categories.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final arTitle = (c.arTitle ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedCategory.value != null;
  CategoryModel? get currentCategory => selectedCategory.value;
}
