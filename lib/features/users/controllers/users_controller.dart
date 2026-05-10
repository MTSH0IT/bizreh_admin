import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bizreh_admin/features/users/models/user_model.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:bizreh_admin/services/users_service.dart';
import 'package:bizreh_admin/services/notification_service.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';

class UsersController extends GetxController {
  final UsersService _usersService = sl<UsersService>();
  final NotificationService _notificationService = sl<NotificationService>();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isUpdatingStatus = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isSendingNotification = false.obs;
  final RxBool isSendingAllNotification = false.obs;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController notificationTitleController =
      TextEditingController();
  final TextEditingController notificationMessageController =
      TextEditingController();

  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    notificationTitleController.dispose();
    notificationMessageController.dispose();
    super.onClose();
  }

  Future<void> getUsers() async {
    try {
      isLoading.value = true;

      final fetchedUsers = await _usersService.getUsers();
      users.assignAll(fetchedUsers);

      log('Successfully fetched ${fetchedUsers.length} users');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getUsers: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch users', false);
      log('Error in getUsers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser() async {
    if (!_validateForm(requirePassword: true)) return;

    try {
      isCreating.value = true;

      await _usersService.createUser(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      await getUsers();
      clearForm();
      showMassage('User created successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createUser: ${e.message}');
    } catch (e) {
      showMassage('Failed to create user', false);
      log('Error in createUser: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateUser() async {
    if (selectedUser.value == null || !_validateForm(requirePassword: false)) {
      return;
    }

    try {
      isUpdating.value = true;

      await _usersService.updateUser(
        id: selectedUser.value!.id!,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await getUsers();
      clearForm();
      showMassage('User updated successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateUser: ${e.message}');
    } catch (e) {
      showMassage('Failed to update user', false);
      log('Error in updateUser: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      isDeleting.value = true;

      await _usersService.deleteUser(userId);
      await getUsers();

      showMassage('User deleted successfully', true);
      log('Successfully deleted user with ID: $userId');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteUser: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete user', false);
      log('Error in deleteUser: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> changeStatus({
    required int userId,
    required int isActive,
  }) async {
    try {
      isUpdatingStatus.value = true;
      await _usersService.changeUserStatus(id: userId, isActive: isActive);
      await getUsers();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in changeStatus: ${e.message}');
    } catch (e) {
      showMassage('Failed to change user status', false);
      log('Error in changeStatus: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  Future<void> sendNotificationToUser(int userId) async {
    final title = notificationTitleController.text.trim();
    final message = notificationMessageController.text.trim();
    if (title.isEmpty || message.isEmpty) {
      showMassage('Please enter title and message', false);
      return;
    }

    try {
      isSendingNotification.value = true;
      await _notificationService.sendToUser(
        userId: userId,
        title: title,
        message: message,
      );
      showMassage('Notification sent successfully', true);
      clearNotificationForm();
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in sendNotificationToUser: ${e.message}');
    } catch (e) {
      showMassage('Failed to send notification', false);
      log('Error in sendNotificationToUser: $e');
    } finally {
      isSendingNotification.value = false;
    }
  }

  Future<void> sendNotificationToAllUsers() async {
    final title = notificationTitleController.text.trim();
    final message = notificationMessageController.text.trim();
    if (title.isEmpty || message.isEmpty) {
      showMassage('Please enter title and message', false);
      return;
    }

    try {
      isSendingAllNotification.value = true;
      await _notificationService.sendToAllUsers(title: title, message: message);
      showMassage('Notification sent to all users successfully', true);
      clearNotificationForm();
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in sendNotificationToAllUsers: ${e.message}');
    } catch (e) {
      showMassage('Failed to send notification to all users', false);
      log('Error in sendNotificationToAllUsers: $e');
    } finally {
      isSendingAllNotification.value = false;
    }
  }

  bool _validateForm({required bool requirePassword}) {
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
      showMassage('Please enter phone number', false);
      return false;
    }
    if (requirePassword && passwordController.text.trim().isEmpty) {
      showMassage('Please enter password', false);
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
    selectedUser.value = null;
  }

  void clearNotificationForm() {
    notificationTitleController.clear();
    notificationMessageController.clear();
  }

  void setUserForEdit(UserModel user) {
    selectedUser.value = user;
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
    passwordController.clear();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<UserModel> get filteredUsers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return users.toList();

    return users.where((u) {
      final firstName = (u.firstName ?? '').toLowerCase();
      final lastName = (u.lastName ?? '').toLowerCase();
      final email = (u.email ?? '').toLowerCase();
      final phone = (u.phone ?? '').toLowerCase();
      return firstName.contains(q) ||
          lastName.contains(q) ||
          email.contains(q) ||
          phone.contains(q);
    }).toList();
  }

  bool get isEditing => selectedUser.value != null;
  UserModel? get currentUser => selectedUser.value;
}
