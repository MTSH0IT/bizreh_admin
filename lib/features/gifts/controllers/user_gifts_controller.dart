import 'dart:developer';

import 'package:bizreh_admin/features/gifts/models/user_gifts_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/user_gifts_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class UserGiftsController extends GetxController {
  final UserGiftsService _service = sl<UserGiftsService>();

  final RxList<UserGiftsModel> userGifts = <UserGiftsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isChangingStatus = false.obs;
  final RxInt? changingId = RxInt(-1);

  // 'pending', 'redeemed', 'expired'
  final RxString selectedStatus = 'pending'.obs;

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserGifts();
  }

  Future<void> getUserGifts() async {
    try {
      isLoading.value = true;

      final fetched = await _service.getUserGifts(status: selectedStatus.value);
      userGifts.assignAll(fetched);

      log('Fetched ${fetched.length} user gifts');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getUserGifts: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch user gifts', false);
      log('Error in getUserGifts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setStatusFilter(String value) {
    if (selectedStatus.value == value) return;
    selectedStatus.value = value;
    getUserGifts();
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  List<UserGiftsModel> get filteredUserGifts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return userGifts.toList();

    return userGifts.where((g) {
      final giftTitle = (g.giftTitle ?? '').toLowerCase();
      final giftArTitle = (g.giftArTitle ?? '').toLowerCase();

      final fullName = ('${g.firstName ?? ''} ${g.lastName ?? ''}')
          .toLowerCase();
      final userEmail = (g.email ?? '').toLowerCase();
      return giftTitle.contains(q) ||
          giftArTitle.contains(q) ||
          fullName.contains(q) ||
          userEmail.contains(q);
    }).toList();
  }

  Future<void> changeStatus({
    required UserGiftsModel model,
    required String status,
  }) async {
    final id = model.id;
    if (id == null) return;

    try {
      isChangingStatus.value = true;
      changingId?.value = id;

      await _service.changeUserGiftStatus(userGiftId: id, status: status);

      await getUserGifts();
      showMassage('User gift status updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in changeStatus: ${e.message}');
    } catch (e) {
      showMassage('Failed to change user gift status', false);
      log('Error in changeStatus: $e');
    } finally {
      isChangingStatus.value = false;
      changingId?.value = -1;
    }
  }
}
