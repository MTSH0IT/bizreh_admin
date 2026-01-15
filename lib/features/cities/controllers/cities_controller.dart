import 'dart:developer';

import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/cities_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CitiesController extends GetxController {
  final CitiesService _service = CitiesService();

  final RxList<CityModel> cities = <CityModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();

  final Rx<CityModel?> selectedCity = Rx<CityModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCities();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    super.onClose();
  }

  Future<void> getCities() async {
    try {
      isLoading.value = true;
      final data = await _service.getCities();
      cities.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getCities: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch cities', false);
      log('Error in getCities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCity() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _service.createCity(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
      );
      await getCities();
      clearForm();
      Get.back();
      showMassage('City created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createCity: ${e.message}');
    } catch (e) {
      showMassage('Failed to create city', false);
      log('Error in createCity: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateCity() async {
    final current = selectedCity.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _service.updateCity(
        id: current!.id!,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
      );
      await getCities();
      clearForm();
      Get.back();
      showMassage('City updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateCity: ${e.message}');
    } catch (e) {
      showMassage('Failed to update city', false);
      log('Error in updateCity: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteCity(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteCity(id);
      await getCities();
      showMassage('City deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteCity: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete city', false);
      log('Error in deleteCity: $e');
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
    selectedCity.value = null;
  }

  void setCityForEdit(CityModel model) {
    selectedCity.value = model;
    titleController.text = model.title ?? '';
    arTitleController.text = model.arTitle ?? '';
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<CityModel> get filteredCities {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return cities.toList();

    return cities.where((c) {
      final t = (c.title ?? '').toLowerCase();
      final at = (c.arTitle ?? '').toLowerCase();
      return t.contains(q) || at.contains(q);
    }).toList();
  }

  bool get isEditing => selectedCity.value != null;
}
