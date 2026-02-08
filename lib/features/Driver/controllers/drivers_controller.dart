import 'dart:developer';

import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/features/suppliers/controllers/suppliers_controller.dart';
import 'package:bizreh_admin/features/suppliers/models/supplier_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/driver_service.dart';
import 'package:bizreh_admin/services/suppliers_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriversController extends GetxController {
  final DriverService _driverService = DriverService();
  final SuppliersService _suppliersService = SuppliersService();

  final RxList<DriverModel> drivers = <DriverModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdatingStatus = false.obs;
  final RxBool isDeleting = false.obs;

  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  final RxBool isSuppliersLoading = false.obs;
  final RxInt selectedSupplierId = 0.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController supplierIdController = TextEditingController();
  final RxInt selectedIsActive = 1.obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDrivers();
    loadSuppliersIfNeeded();
  }

  Future<void> loadSuppliersIfNeeded() async {
    final suppliersController = Get.isRegistered<SuppliersController>()
        ? Get.find<SuppliersController>()
        : null;

    if (suppliersController != null &&
        suppliersController.suppliers.isNotEmpty) {
      suppliers.assignAll(suppliersController.suppliers);
      return;
    }

    if (suppliers.isNotEmpty) {
      return;
    }

    await loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    try {
      isSuppliersLoading.value = true;
      final list = await _suppliersService.getSuppliers();
      suppliers.assignAll(list);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in loadSuppliers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load suppliers', false);
      log('Error in loadSuppliers: $e');
    } finally {
      isSuppliersLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    vehicleNumberController.dispose();
    licenseNumberController.dispose();
    supplierIdController.dispose();
    super.onClose();
  }

  Future<void> getDrivers() async {
    try {
      isLoading.value = true;
      final fetched = await _driverService.getDrivers();
      drivers.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getDrivers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load drivers', false);
      log('Error in getDrivers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDriver() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;

      await _driverService.createDriver(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        vehicleNumber: vehicleNumberController.text.trim(),
        licenseNumber: licenseNumberController.text.trim(),
        supplierId: selectedSupplierId.value,
        isActive: selectedIsActive.value,
      );

      await getDrivers();
      clearForm();
      Get.back();
      showMassage('Driver created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createDriver: ${e.message}');
    } catch (e) {
      showMassage('Failed to create driver', false);
      log('Error in createDriver: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> changeStatus({
    required int driverId,
    required int isActive,
  }) async {
    try {
      isUpdatingStatus.value = true;
      await _driverService.changeDriverStatus(id: driverId, isActive: isActive);
      await getDrivers();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in changeStatus: ${e.message}');
    } catch (e) {
      showMassage('Failed to change driver status', false);
      log('Error in changeStatus: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  Future<void> deleteDriver(int driverId) async {
    try {
      isDeleting.value = true;
      await _driverService.deleteDriver(driverId);
      await getDrivers();
      showMassage('Driver deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteDriver: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete driver', false);
      log('Error in deleteDriver: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm() {
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

    if (passwordController.text.isEmpty) {
      showMassage('Please enter password', false);
      return false;
    }

    if (vehicleNumberController.text.trim().isEmpty) {
      showMassage('Please enter vehicle number', false);
      return false;
    }

    if (licenseNumberController.text.trim().isEmpty) {
      showMassage('Please enter license number', false);
      return false;
    }

    final supplierId = selectedSupplierId.value;
    if (supplierId == 0) {
      showMassage('Please select supplier', false);
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
    vehicleNumberController.clear();
    licenseNumberController.clear();
    supplierIdController.clear();
    selectedSupplierId.value = 0;
    selectedIsActive.value = 1;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<DriverModel> get filteredDrivers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return drivers.toList();

    return drivers.where((d) {
      final fn = (d.firstName ?? '').toLowerCase();
      final ln = (d.lastName ?? '').toLowerCase();
      final email = (d.email ?? '').toLowerCase();
      final phone = (d.phone ?? '').toLowerCase();
      return fn.contains(q) ||
          ln.contains(q) ||
          email.contains(q) ||
          phone.contains(q);
    }).toList();
  }
}
