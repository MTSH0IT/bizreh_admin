import 'dart:developer';

import 'package:bizreh_admin/features/gifts/models/gifts_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/gifts_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class GiftsController extends GetxController {
  final GiftsService _giftsService = sl<GiftsService>();

  final RxList<GiftsModel> gifts = <GiftsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final TextEditingController pointsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final RxString selectedImagePath = ''.obs;
  final RxInt isActive = 1.obs;

  final Rx<GiftsModel?> selectedGift = Rx<GiftsModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getGifts();
  }

  @override
  void onClose() {
    pointsController.dispose();
    titleController.dispose();
    arTitleController.dispose();
    super.onClose();
  }

  Future<void> getGifts() async {
    try {
      isLoading.value = true;

      final fetched = await _giftsService.getGifts();
      gifts.assignAll(fetched);

      log('Successfully fetched ${fetched.length} gifts');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getGifts: ${e.message}');
    } catch (e) {
      showMassage('Failed to fetch gifts', false);
      log('Error in getGifts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGift() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;

      await _giftsService.createGift(
        points: int.parse(pointsController.text.trim()),
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        imagePath: selectedImagePath.value,
        isActive: isActive.value,
      );

      await getGifts();
      clearForm();
      showMassage('Gift created successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createGift: ${e.message}');
    } catch (e) {
      showMassage('Failed to create gift', false);
      log('Error in createGift: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateGift() async {
    final gift = selectedGift.value;
    if (gift?.id == null) return;

    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;

      await _giftsService.updateGift(
        id: gift!.id!,
        points: int.parse(pointsController.text.trim()),
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
        isActive: isActive.value,
      );

      await getGifts();
      clearForm();
      showMassage('Gift updated successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateGift: ${e.message}');
    } catch (e) {
      showMassage('Failed to update gift', false);
      log('Error in updateGift: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteGift(int giftId) async {
    try {
      isDeleting.value = true;

      await _giftsService.deleteGift(giftId);
      await getGifts();

      showMassage('Gift deleted successfully', true);
      log('Successfully deleted gift with ID: $giftId');
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteGift: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete gift', false);
      log('Error in deleteGift: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  bool _validateForm({required bool requireImage}) {
    if (pointsController.text.trim().isEmpty) {
      showMassage('Please enter points', false);
      return false;
    }

    final points = int.tryParse(pointsController.text.trim());
    if (points == null) {
      showMassage('Points must be a valid number', false);
      return false;
    }

    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter title', false);
      return false;
    }
    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic title', false);
      return false;
    }
    if (requireImage && selectedImagePath.value.trim().isEmpty) {
      showMassage('Please select an image', false);
      return false;
    }
    return true;
  }

  void clearForm() {
    pointsController.clear();
    titleController.clear();
    arTitleController.clear();
    selectedImagePath.value = '';
    isActive.value = 1;
    selectedGift.value = null;
  }

  void setGiftForEdit(GiftsModel gift) {
    selectedGift.value = gift;
    pointsController.text = gift.points?.toString() ?? '';
    titleController.text = gift.title ?? '';
    arTitleController.text = gift.arTitle ?? '';
    selectedImagePath.value = '';
    isActive.value = (gift.isActive ?? 1);
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<GiftsModel> get filteredGifts {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return gifts.toList();

    return gifts.where((g) {
      final title = (g.title ?? '').toLowerCase();
      final arTitle = (g.arTitle ?? '').toLowerCase();
      return title.contains(q) || arTitle.contains(q);
    }).toList();
  }

  bool get isEditing => selectedGift.value != null;
  GiftsModel? get currentGift => selectedGift.value;
}
