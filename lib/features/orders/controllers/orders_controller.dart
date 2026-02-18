import 'dart:developer';

import 'package:bizreh_admin/features/Driver/models/driver_model.dart';
import 'package:bizreh_admin/features/Driver/controllers/drivers_controller.dart';
import 'package:bizreh_admin/features/orders/models/order_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/driver_service.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final OrdersService _ordersService = OrdersService();
  final DriverService _driverService = DriverService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString searchQuery = ''.obs;

  final RxList<DriverModel> drivers = <DriverModel>[].obs;
  final RxBool isDriversLoading = false.obs;

  final RxInt selectedDriverId = 0.obs;
  final RxBool isAssigning = false.obs;

  final RxString selectedStatus = ''.obs;
  final RxBool isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> getOrders() async {
    try {
      isLoading.value = true;
      final fetched = await _ordersService.getOrders();
      orders.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getOrders: ${e.message}');
    } catch (e) {
      showMassage('Failed to load orders', false);
      log('Error in getOrders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDriversIfNeeded() async {
    // حاول استخدام DriversController كمصدر رئيسي إن كان موجودًا
    final driversController = Get.isRegistered<DriversController>()
        ? Get.find<DriversController>()
        : null;

    // إذا كان DriversController موجودًا ويحتوي بيانات، خذ نفس القائمة (Single Source of Truth)
    if (driversController != null && driversController.drivers.isNotEmpty) {
      drivers.assignAll(driversController.drivers);
      return;
    }

    // إذا لم يكن هناك DriversController أو قائمته فارغة لكن هذه القائمة ليست فارغة، استخدم الكاش الحالي
    if (drivers.isNotEmpty) {
      return;
    }

    // في آخر خيار، حمّل من الـ API
    await loadDrivers();
  }

  Future<void> loadDrivers() async {
    try {
      isDriversLoading.value = true;
      final fetched = await _driverService.getDrivers();
      drivers.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in loadDrivers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load drivers', false);
      log('Error in loadDrivers: $e');
    } finally {
      isDriversLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<OrderModel> get filteredOrders {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return orders.toList();

    return orders.where((o) {
      final orderNumber = (o.orderNumber ?? '').toLowerCase();
      final status = (o.status ?? '').toLowerCase();
      final paymentStatus = (o.paymentStatus ?? '').toLowerCase();
      final userName = (o.userName ?? '').toLowerCase();
      final city = (o.cityName ?? '').toLowerCase();
      return orderNumber.contains(q) ||
          status.contains(q) ||
          paymentStatus.contains(q) ||
          userName.contains(q) ||
          city.contains(q);
    }).toList();
  }

  Future<void> assignDriverToOrder({required int orderId}) async {
    final driverId = selectedDriverId.value;
    if (driverId == 0) {
      showMassage('Please select driver', false);
      return;
    }

    try {
      isAssigning.value = true;
      await _ordersService.assignDriver(orderId: orderId, driverId: driverId);
      await getOrders();
      showMassage('Driver assigned successfully', true);
      selectedDriverId.value = 0;
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in assignDriverToOrder: ${e.message}');
    } catch (e) {
      showMassage('Failed to assign driver', false);
      log('Error in assignDriverToOrder: $e');
    } finally {
      isAssigning.value = false;
    }
  }

  Future<void> changeStatusForOrder({required int orderId}) async {
    final status = selectedStatus.value.trim();
    if (status.isEmpty) {
      showMassage('Please select status', false);
      return;
    }

    try {
      isUpdatingStatus.value = true;
      await _ordersService.changeOrderStatus(orderId: orderId, status: status);
      await getOrders();
      showMassage('Order status updated successfully', true);
      selectedStatus.value = '';
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in changeStatusForOrder: ${e.message}');
    } catch (e) {
      showMassage('Failed to update order status', false);
      log('Error in changeStatusForOrder: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
