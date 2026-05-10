import 'dart:developer';

import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/orders/views/order_details_view.dart';
import 'package:bizreh_admin/features/points/models/user_point_history/history.dart';
import 'package:bizreh_admin/features/points/models/user_point_history/summary.dart';
import 'package:bizreh_admin/features/points/models/user_point_history/user_point_history.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class UserPointsHistoryController extends GetxController {
  final int userId;

  UserPointsHistoryController({required this.userId});

  final PointsService _pointsService = sl<PointsService>();
  final OrdersService _ordersService = sl<OrdersService>();

  final Rx<UserPointHistory?> pointHistory = Rx<UserPointHistory?>(null);
  final RxList<History> history = <History>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isOpeningOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final h = await _pointsService.getUserPointsHistory(userId);
      pointHistory.value = h;
      history.assignAll(h.history ?? const <History>[]);
    } on AppException catch (e) {
      errorMessage.value = e.message;
      showMassage(e.message, false);
      log('AppException in load user points: ${e.message}');
    } catch (e) {
      errorMessage.value = e.toString();
      showMassage('Failed to load points', false);
      log('Error in load user points: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Summary? get summary => pointHistory.value?.summary;
  
  @override
  Future<void> refresh() async {
    await load();
  }

  Future<void> openOrderDetails(int orderId) async {
    if (isOpeningOrder.value) return;

    try {
      isOpeningOrder.value = true;
      final order = await _ordersService.getOrder(orderId);

      Get.find<MainNavController>().push(
        MainNavEntry(
          title: 'Order #${order.orderNumber ?? orderId}',
          page: OrderDetailsView(order: order),
        ),
      );
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in openOrderDetails: ${e.message}');
    } catch (e) {
      showMassage('Failed to load order', false);
      log('Error in openOrderDetails: $e');
    } finally {
      isOpeningOrder.value = false;
    }
  }
}
