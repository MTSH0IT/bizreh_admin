import 'dart:developer';

import 'package:bizreh_admin/features/sub_category/models/sub_category_model.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryController extends GetxController {
  final SubCategoryService _subCategoryService = SubCategoryService();

  // بيانات
  final RxList<SubCategoryModel> subCategories = <SubCategoryModel>[].obs;
  final RxList<AllSubCategoryModel> allSubCategories =
      <AllSubCategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // فورم
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final RxString selectedImagePath = ''.obs;

  // العلاقة مع الـ Category
  final RxInt selectedCategoryId = 0.obs;

  // العنصر المحدد للتعديل
  final Rx<SubCategoryModel?> selectedSubCategory = Rx<SubCategoryModel?>(null);

  // البحث
  final RxString searchQuery = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    positionController.dispose();
    super.onClose();
  }

  // تحميل الـ SubCategories الخاصة بـ Category معين
  Future<void> getSubCategories(int categoryId) async {
    try {
      isLoading.value = true;
      selectedCategoryId.value = categoryId;

      final fetched = await _subCategoryService.getSubCategories(categoryId);
      subCategories.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getSubCategories: ${e.message}');
    } catch (e) {
      showMassage('Failed to load sub categories', false);
      log('Error in getSubCategories: $e');
    } finally {
      isLoading.value = false;
    }
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

      await getSubCategories(selectedCategoryId.value);
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
    if (selectedSubCategory.value == null ||
        !_validateForm(requireImage: false)) {
      return;
    }

    try {
      isUpdating.value = true;

      await _subCategoryService.updateSubCategory(
        id: selectedSubCategory.value!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        position: positionController.text.trim(),
        categoryId: selectedCategoryId.value,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
      );

      await getSubCategories(selectedCategoryId.value);
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
      await getSubCategories(selectedCategoryId.value);

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

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    positionController.clear();
    selectedImagePath.value = '';
    selectedSubCategory.value = null;
  }

  void setSubCategoryForEdit(SubCategoryModel subCategory) {
    selectedSubCategory.value = subCategory;
    titleController.text = subCategory.title ?? '';
    arTitleController.text = subCategory.arTitle ?? '';
    positionController.text = subCategory.position?.toString() ?? '';
    selectedImagePath.value = '';
    selectedCategoryId.value = subCategory.categoryId ?? 0;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
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
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  List<SubCategoryModel> get filteredSubCategories {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return subCategories.toList();

    return subCategories.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final arTitle = (c.arTitle ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedSubCategory.value != null;
  SubCategoryModel? get currentSubCategory => selectedSubCategory.value;
}
