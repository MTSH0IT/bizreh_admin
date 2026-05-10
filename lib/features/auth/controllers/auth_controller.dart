// Placeholder AuthController
import 'dart:developer';

import 'package:bizreh_admin/features/auth/models/auth_response.dart';
import 'package:bizreh_admin/features/auth/views/login_view.dart';
import 'package:bizreh_admin/features/main_view/views/main_view.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/auth_service.dart';
import 'package:bizreh_admin/utils/consts/const_key.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static String? token;

  final AuthService _authService = sl<AuthService>();
  final StorageService _storage = sl<StorageService>();

  final TextEditingController loginEmailCtrl = TextEditingController();
  final TextEditingController loginPasswordCtrl = TextEditingController();
  final TextEditingController forgetPasswordEmailCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isForgettingPassword = false.obs;
  final RxBool isPasswordVisible = false.obs;

  String get loginEmail => loginEmailCtrl.text.trim();
  String get loginPassword => loginPasswordCtrl.text.trim();

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    forgetPasswordEmailCtrl.dispose();
    super.onClose();
  }

  Future<void> forgetPassword() async {
    final email = forgetPasswordEmailCtrl.text.trim();
    if (email.isEmpty) {
      showMassage('Please enter email', false);
      return;
    }

    isForgettingPassword.value = true;
    try {
      await _authService.forgetPassword(email: email);
      showMassage('Password reset email sent', true);
      forgetPasswordEmailCtrl.clear();
      Get.back();
    } on AppException catch (e) {
      log("auth controller AppException forgetPassword : ${e.toString()}");
      showMassage(e.message, false);
    } catch (e) {
      log("auth controller catch forgetPassword : ${e.toString()}");
      showMassage("Failed to send reset email", false);
    } finally {
      isForgettingPassword.value = false;
    }
  }

  Future<void> login({required bool rememberMe}) async {
    isLoading.value = true;
    try {
      final AuthResponse res = await _authService.login(
        email: loginEmail,
        password: loginPassword,
      );
      await _persistAuth(res);
      if (rememberMe) {
        await _storage.setBool(StorageKey.rememberMe, true);
        await _storage.setString(StorageKey.email, loginEmail);
        await _storage.setString(StorageKey.password, loginPassword);
      } else {
        await _storage.remove(StorageKey.rememberMe);
        await _storage.remove(StorageKey.email);
        await _storage.remove(StorageKey.password);
      }
      Get.offAll(() => mainView());
      clearCtrl();
      Get.snackbar(
        'مرحبًا',
        'تم تسجيل الدخول بنجاح',
        snackPosition: SnackPosition.TOP,
      );
    } on AppException catch (e) {
      log("auth controller AppException sign in : ${e.toString()}");
      showMassage(e.message, false);
    } catch (e) {
      log("auth controller catch sign in : ${e.toString()}");
      showMassage("حدث خطأ ما حاول مرة اخرى", false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> tryAutoLogin() async {
    isLoading.value = true;
    try {
      final remember = _storage.getBool(StorageKey.rememberMe) ?? false;
      if (!remember) return false;

      final savedEmail = _storage.getString(StorageKey.email);
      final savedPassword = _storage.getString(StorageKey.password);

      if (savedEmail == null || savedEmail.isEmpty) return false;
      if (savedPassword == null || savedPassword.isEmpty) return false;

      final AuthResponse res = await _authService.login(
        email: savedEmail,
        password: savedPassword,
      );
      await _persistAuth(res);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persistAuth(AuthResponse res) async {
    log("persistAuth token:\n ${res.token}");
    token = res.token;

    log("persistAuth user:\n ${res.user.toString()}");
    await _storage.setJson(StorageKey.user, res.user.toJson());
  }

  void clearCtrl() {
    loginEmailCtrl.clear();
    loginPasswordCtrl.clear();
  }

  Future<void> logout() async {
    try {
      token = null;
      await _storage.remove(StorageKey.token);
      await _storage.remove(StorageKey.user);
      await _storage.remove(StorageKey.email);
      await _storage.remove(StorageKey.password);
      await _storage.remove(StorageKey.rememberMe);
    } catch (e) {
      log('AuthController logout error: $e');
    } finally {
      clearCtrl();
      Get.offAll(() => const LoginView());
    }
  }
}
