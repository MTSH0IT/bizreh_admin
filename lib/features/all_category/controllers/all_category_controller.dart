import 'dart:developer';

import 'package:bizreh_admin/features/all_category/models/all_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class AllCategoryController extends GetxController {
  final CategoryService _service = CategoryService();

  final RxList<AllCategoryModel> allCategories = <AllCategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getAllCategories();
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
}
