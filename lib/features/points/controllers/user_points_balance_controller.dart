import 'dart:developer';

import 'package:bizreh_admin/features/main_view/controllers/main_nav_controller.dart';
import 'package:bizreh_admin/features/orders/views/order_details_view.dart';
import 'package:bizreh_admin/features/points/models/user_point_histoy_model.dart';
import 'package:bizreh_admin/features/points/models/user_points_balance_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/orders_service.dart';
import 'package:bizreh_admin/services/points_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class UserPointsBalanceController extends GetxController {
  final int userId;

  UserPointsBalanceController({required this.userId});

  final PointsService _pointsService = PointsService();
  final OrdersService _ordersService = OrdersService();

  final Rx<UserPointsBalanceModel?> balance = Rx<UserPointsBalanceModel?>(null);
  final RxList<UserPointHistoyModel> history = <UserPointHistoyModel>[].obs;

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

      final b = await _pointsService.getUserPointsBalance(userId);
      final h = await _pointsService.getUserPointsHistory(userId);

      balance.value = b;
      history.assignAll(h);
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
