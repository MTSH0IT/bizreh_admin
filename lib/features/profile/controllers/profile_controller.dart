import 'dart:developer';

import 'package:bizreh_admin/features/profile/models/profile_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/profile_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  final RxBool isLoading = false.obs;
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxString errorMessage = ''.obs;

  Future<void> getProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      profile.value = await _profileService.getProfile();
    } on AppException catch (e) {
      log('ProfileController AppException: ${e.toString()}');
      errorMessage.value = e.message;
      showMassage(e.message, false);
    } catch (e) {
      log('ProfileController catch: ${e.toString()}');
      errorMessage.value = 'فشل تحميل الملف الشخصي';
      showMassage('فشل تحميل الملف الشخصي', false);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
