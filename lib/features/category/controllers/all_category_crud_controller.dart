import 'dart:developer';

import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/super_category/controllers/super_category_controller.dart';
import 'package:bizreh_admin/features/super_category/models/super_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/super_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoryCrudController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final SuperCategoryService _superCategoryService = SuperCategoryService();

  final RxList<AllCategoryModel> allCategories = <AllCategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxList<SuperCategoryModel> superCategories = <SuperCategoryModel>[].obs;
  final RxBool isSuperCategoriesLoading = false.obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  final RxInt selectedSuperCategoryId = 0.obs;

  final Rx<AllCategoryModel?> selectedCategory = Rx<AllCategoryModel?>(null);

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
    getSuperCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  Future<void> getAllCategories() async {
    try {
      isLoading.value = true;
      final fetched = await _categoryService.getAllCategories();
      allCategories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getAllCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch categories', false);
      log('Error in getAllCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSuperCategories() async {
    final superCategoryController = Get.isRegistered<SuperCategoryController>()
        ? Get.find<SuperCategoryController>()
        : null;

    if (superCategoryController != null &&
        superCategoryController.superCategories.isNotEmpty) {
      superCategories.assignAll(superCategoryController.superCategories);
      return;
    }

    try {
      isSuperCategoriesLoading.value = true;
      final fetched = await _superCategoryService.getSuperCategories();
      superCategories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getSuperCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load super categories', false);
      log('Error in getSuperCategories: $e');
    } finally {
      isSuperCategoriesLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<AllCategoryModel> get filteredAllCategories {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return allCategories.toList();

    return allCategories.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final arTitle = (c.arTitle ?? '').toLowerCase();
      final superTitle = (c.superCategoryTitle ?? '').toLowerCase();
      final superArTitle = (c.superCategoryArTitle ?? '').toLowerCase();
      return title.contains(q) ||
          arTitle.contains(q) ||
          superTitle.contains(q) ||
          superArTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedCategory.value != null;
  AllCategoryModel? get currentCategory => selectedCategory.value;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedSuperCategoryId.value = 0;
    selectedCategory.value = null;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setSuperCategoryId(int? id) {
    selectedSuperCategoryId.value = id ?? 0;
  }

  void setCategoryForEdit(AllCategoryModel category) {
    selectedCategory.value = category;
    titleController.text = category.title ?? '';
    arTitleController.text = category.arTitle ?? '';
    positionController.text = category.position?.toString() ?? '';
    selectedImagePath.value = '';
    selectedSuperCategoryId.value = category.superCategoryId ?? 0;
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

      await getAllCategories();
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
    final current = selectedCategory.value;
    if (current == null || current.id == null) return;
    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;

      await _categoryService.updateCategory(
        id: current.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        superCategoryId: selectedSuperCategoryId.value,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );
      await getAllCategories();
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
      await getAllCategories();
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
}
