import 'dart:developer';

import 'package:bizreh_admin/features/cities/models/city_model.dart';
import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/cities_service.dart';
import 'package:bizreh_admin/services/suppliers_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersController extends GetxController {
  final SuppliersService _service;
  final CitiesService _citiesService;

  SuppliersController({
    required SuppliersService suppliersService,
    required CitiesService citiesService,
  }) : _service = suppliersService,
       _citiesService = citiesService;

  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final RxList<CityModel> cities = <CityModel>[].obs;
  final RxBool isMetaLoading = false.obs;
  final RxInt selectedCityId = 0.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMeta();
    getSuppliers();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _loadMeta() async {
    try {
      isMetaLoading.value = true;
      final data = await _citiesService.getCities();
      cities.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in _loadMeta(cities): ${e.message}');
    } catch (e) {
      showMassage('Failed to load cities', false);
      log('Error in _loadMeta(cities): $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  Future<void> getSuppliers() async {
    try {
      isLoading.value = true;
      final data = await _service.getSuppliers();
      suppliers.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getSuppliers: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch suppliers', false);
      log('Error in getSuppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSupplier() async {
    if (!_validateForm(requirePassword: true, requireCity: true)) return;

    try {
      isCreating.value = true;
      await _service.createSupplier(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        cityId: selectedCityId.value,
      );
      await getSuppliers();
      clearForm();
      Get.back();
      showMassage('Supplier created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createSupplier: ${e.message}');
    } catch (e) {
      showMassage('Failed to create supplier', false);
      log('Error in createSupplier: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateSupplier() async {
    final current = selectedSupplier.value;
    if (current?.id == null) return;
    if (!_validateForm(requirePassword: false, requireCity: false)) return;

    try {
      isUpdating.value = true;
      await _service.updateSupplier(
        id: current!.id!,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );
      await getSuppliers();
      clearForm();
      Get.back();
      showMassage('Supplier updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateSupplier: ${e.message}');
    } catch (e) {
      showMassage('Failed to update supplier', false);
      log('Error in updateSupplier: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteSupplier(id);
      await getSuppliers();
      showMassage('Supplier deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteSupplier: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete supplier', false);
      log('Error in deleteSupplier: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm({
    required bool requirePassword,
    required bool requireCity,
  }) {
    if (firstNameController.text.trim().isEmpty) {
      showMassage('Please enter first name', false);
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      showMassage('Please enter last name', false);
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      showMassage('Please enter email', false);
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      showMassage('Please enter phone', false);
      return false;
    }
    if (requirePassword && passwordController.text.trim().isEmpty) {
      showMassage('Please enter password', false);
      return false;
    }
    if (requireCity && selectedCityId.value == 0) {
      showMassage('Please select city', false);
      return false;
    }

    final email = emailController.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      showMassage('Please enter a valid email address', false);
      return false;
    }

    return true;
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedCityId.value = 0;
    selectedSupplier.value = null;
  }

  void setSupplierForEdit(SupplierModel model) {
    selectedSupplier.value = model;
    firstNameController.text = model.firstName ?? '';
    lastNameController.text = model.lastName ?? '';
    emailController.text = model.email ?? '';
    phoneController.text = model.phone ?? '';
    passwordController.clear();
    selectedCityId.value = 0;
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<SupplierModel> get filteredSuppliers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return suppliers.toList();

    return suppliers.where((s) {
      final fn = (s.firstName ?? '').toLowerCase();
      final ln = (s.lastName ?? '').toLowerCase();
      final em = (s.email ?? '').toLowerCase();
      final ph = (s.phone ?? '').toLowerCase();
      final ct = (s.cities ?? '').toLowerCase();
      return fn.contains(q) ||
          ln.contains(q) ||
          em.contains(q) ||
          ph.contains(q) ||
          ct.contains(q);
    }).toList();
  }

  bool get isEditing => selectedSupplier.value != null;
}
