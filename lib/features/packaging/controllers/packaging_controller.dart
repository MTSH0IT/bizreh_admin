import 'dart:developer';

import 'package:bizreh_admin/features/packaging/models/package_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/packaging_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagingController extends GetxController {
  final PackagingService _service = PackagingService();

  final RxList<PackageModel> packagings = <PackageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();

  final Rx<PackageModel?> selectedPackaging = Rx<PackageModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPackagings();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    super.onClose();
  }

  Future<void> getPackagings() async {
    try {
      isLoading.value = true;
      final data = await _service.getPackagings();
      packagings.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getPackagings: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch packagings', false);
      log('Error in getPackagings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPackaging() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _service.createPackaging(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
      );
      await getPackagings();
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createPackaging: ${e.message}');
    } catch (e) {
      showMassage('Failed to create packaging', false);
      log('Error in createPackaging: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updatePackaging() async {
    final current = selectedPackaging.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _service.updatePackaging(
        id: current!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
      );
      await getPackagings();
      clearForm();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updatePackaging: ${e.message}');
    } catch (e) {
      showMassage('Failed to update packaging', false);
      log('Error in updatePackaging: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deletePackaging(int id) async {
    try {
      isDeleting.value = true;
      await _service.deletePackaging(id);
      await getPackagings();
      showMassage('Packaging deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deletePackaging: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete packaging', false);
      log('Error in deletePackaging: $e');
    } finally {
      isDeleting.value = false;
    }
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
    return true;
  }

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    selectedPackaging.value = null;
  }

  void setPackagingForEdit(PackageModel model) {
    selectedPackaging.value = model;
    titleController.text = model.title ?? '';
    arTitleController.text = model.arTitle ?? '';
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<PackageModel> get filteredPackagings {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return packagings.toList();

    return packagings.where((p) {
      final t = (p.title ?? '').toLowerCase();
      final at = (p.arTitle ?? '').toLowerCase();
      return t.contains(q) || at.contains(q);
    }).toList();
  }

  bool get isEditing => selectedPackaging.value != null;
}
