import 'dart:developer';

import 'package:bizreh_admin/features/category/models/all_category_model.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../category/controllers/all_category_crud_controller.dart';

class AllSubCategoryCrudController extends GetxController {
  final SubCategoryService _subCategoryService;
  final CategoryService _categoryService;

  AllSubCategoryCrudController({
    required SubCategoryService subCategoryService,
    required CategoryService categoryService,
  }) : _subCategoryService = subCategoryService,
       _categoryService = categoryService;

  final RxList<AllSubCategoryModel> allSubCategories =
      <AllSubCategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxList<AllCategoryModel> categories = <AllCategoryModel>[].obs;
  final RxBool isCategoriesLoading = false.obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  final RxInt selectedCategoryId = 0.obs;

  final Rx<AllSubCategoryModel?> selectedSubCategory = Rx<AllSubCategoryModel?>(
    null,
  );

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllSubCategories();
    getCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  Future<void> getAllSubCategories() async {
    try {
      isLoading.value = true;
      final fetched = await _subCategoryService.getAllSubCategories();
      allSubCategories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getAllSubCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load all sub categories', false);
      log('Error in getAllSubCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    final categoriesController = Get.isRegistered<AllCategoryCrudController>()
        ? Get.find<AllCategoryCrudController>()
        : null;

    if (categoriesController != null &&
        categoriesController.allCategories.isNotEmpty) {
      categories.assignAll(categoriesController.allCategories);
      return;
    }

    try {
      isCategoriesLoading.value = true;
      final fetched = await _categoryService.getAllCategories();
      categories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load categories', false);
      log('Error in getCategories: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<AllSubCategoryModel> get filteredAllSubCategories {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return allSubCategories.toList();

    return allSubCategories.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final arTitle = (c.arTitle ?? '').toLowerCase();
      final catTitle = (c.categoryTitle ?? '').toLowerCase();
      final superTitle = (c.superCategoryTitle ?? '').toLowerCase();
      return title.contains(q) ||
          arTitle.contains(q) ||
          catTitle.contains(q) ||
          superTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedSubCategory.value != null;
  AllSubCategoryModel? get currentSubCategory => selectedSubCategory.value;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedCategoryId.value = 0;
    selectedSubCategory.value = null;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setCategoryId(int? id) {
    selectedCategoryId.value = id ?? 0;
  }

  void setSubCategoryForEdit(AllSubCategoryModel subCategory) {
    selectedSubCategory.value = subCategory;
    titleController.text = subCategory.title ?? '';
    arTitleController.text = subCategory.arTitle ?? '';
    positionController.text = subCategory.position?.toString() ?? '';
    selectedImagePath.value = '';
    selectedCategoryId.value = subCategory.categoryId ?? 0;
  }

  bool _validateForm({required bool requireImage}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter sub category title', false);
      return false;
    }

    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic sub category title', false);
      return false;
    }

    if (positionController.text.trim().isEmpty) {
      showMassage('Please enter position', false);
      return false;
    }

    if (selectedCategoryId.value == 0) {
      showMassage('Please select category', false);
      return false;
    }

    if (requireImage && selectedImagePath.value.trim().isEmpty) {
      showMassage('Please select an image', false);
      return false;
    }

    return true;
  }

  Future<void> createSubCategory() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _subCategoryService.createSubCategory(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        categoryId: selectedCategoryId.value,
        imagePath: selectedImagePath.value,
      );

      await getAllSubCategories();
      clearForm();
      Get.back();
      showMassage('Sub category created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createSubCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to create sub category', false);
      log('Error in createSubCategory: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateSubCategory() async {
    final current = selectedSubCategory.value;
    if (current == null || current.id == null) return;
    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;

      await _subCategoryService.updateSubCategory(
        id: current.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        categoryId: selectedCategoryId.value,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );

      await getAllSubCategories();
      clearForm();
      Get.back();
      showMassage('Sub category updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateSubCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to update sub category', false);
      log('Error in updateSubCategory: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteSubCategory(int id) async {
    try {
      isDeleting.value = true;
      await _subCategoryService.deleteSubCategory(id);
      await getAllSubCategories();
      showMassage('Sub category deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteSubCategory: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete sub category', false);
      log('Error in deleteSubCategory: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
