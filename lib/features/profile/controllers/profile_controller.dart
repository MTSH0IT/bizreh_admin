import 'dart:developer';

import 'package:bizreh_admin/features/profile/models/profile_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/profile_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService;

  ProfileController({required ProfileService profileService})
    : _profileService = profileService;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingChangePassword = false.obs;
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxString errorMessage = ''.obs;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

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

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showMassage("يرجى ملء جميع الحقول", false);
      return;
    }

    if (newPassword != confirmPassword) {
      showMassage("كلمة المرور الجديدة غير متطابقة", false);
      return;
    }

    if (newPassword.length < 6) {
      showMassage("كلمة المرور يجب أن تكون 6 أحرف على الأقل", false);
      return;
    }

    isLoadingChangePassword.value = true;
    try {
      await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      Get.back();
      showMassage("تم تحديث كلمة المرور بنجاح", true);
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } on AppException catch (e) {
      log("ProfileController AppException changePassword : ${e.message}");
      showMassage(e.message, false);
    } catch (e) {
      log("ProfileController catch changePassword : ${e.toString()}");
      showMassage("حدث خطأ أثناء تغيير كلمة المرور، حاول مرة أخرى", false);
    } finally {
      isLoadingChangePassword.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
