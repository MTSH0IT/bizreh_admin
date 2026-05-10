import 'dart:developer';

import 'package:bizreh_admin/features/ads/models/ads_model.dart';
import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/ads_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  final AdsService _adsService = sl<AdsService>();
  final ProductsService _productsService = sl<ProductsService>();

  final RxList<AdsModel> ads = <AdsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isUpdatingStatus = false.obs;

  final RxBool isMetaLoading = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController arDescriptionController = TextEditingController();

  final RxString selectedImagePath = ''.obs;
  //final RxInt selectedProductId = 0.obs;
  final RxInt isActive = 1.obs;

  final Rx<AdsModel?> selectedAd = Rx<AdsModel?>(null);
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAds();
    getMeta();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    descriptionController.dispose();
    arDescriptionController.dispose();
    super.onClose();
  }

  Future<void> getAds() async {
    try {
      isLoading.value = true;
      final fetched = await _adsService.getAds();
      ads.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getAds: ${e.message}');
    } catch (e) {
      showMassage('Failed to load ads', false);
      log('Error in getAds: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMeta() async {
    final productsController = Get.isRegistered<ProductsController>()
        ? Get.find<ProductsController>()
        : null;

    if (productsController != null && productsController.products.isNotEmpty) {
      products.assignAll(productsController.products);
      return;
    }

    if (products.isNotEmpty) {
      return;
    }

    try {
      isMetaLoading.value = true;
      final list = await _productsService.getProducts();
      products.assignAll(list);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getMeta(products): ${e.message}');
    } catch (e) {
      showMassage('Failed to load products', false);
      log('Error in getMeta(products): $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  void setSearchQuery(String q) => searchQuery.value = q;

  List<AdsModel> get filteredAds {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return ads.toList();

    return ads.where((a) {
      final t = (a.title ?? '').toLowerCase();
      final at = (a.arTitle ?? '').toLowerCase();
      return t.contains(q) || at.contains(q);
    }).toList();
  }

  bool get isEditing => selectedAd.value != null;
  AdsModel? get currentAd => selectedAd.value;

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    descriptionController.clear();
    arDescriptionController.clear();
    selectedImagePath.value = '';
    //selectedProductId.value = 0;
    isActive.value = 1;
    selectedAd.value = null;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  // void setProductId(int? id) {
  //   selectedProductId.value = id ?? 0;
  // }

  void setAdForEdit(AdsModel ad) {
    selectedAd.value = ad;
    titleController.text = ad.title ?? '';
    arTitleController.text = ad.arTitle ?? '';
    descriptionController.text = ad.description ?? '';
    arDescriptionController.text = ad.arDescription ?? '';
    selectedImagePath.value = '';
    //selectedProductId.value = ad.productId ?? 0;
    isActive.value = ad.isActive ?? 1;
  }

  bool _validateForm({required bool requireImage}) {
    if (titleController.text.trim().isEmpty) {
      showMassage('Please enter title', false);
      return false;
    }
    if (arTitleController.text.trim().isEmpty) {
      showMassage('Please enter Arabic title', false);
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      showMassage('Please enter description', false);
      return false;
    }
    if (arDescriptionController.text.trim().isEmpty) {
      showMassage('Please enter Arabic description', false);
      return false;
    }
    // if (selectedProductId.value == 0) {
    //   showMassage('Please select product', false);
    //   return false;
    // }
    if (requireImage && selectedImagePath.value.trim().isEmpty) {
      showMassage('Please select an image', false);
      return false;
    }
    return true;
  }

  Future<void> createAd() async {
    if (!_validateForm(requireImage: true)) return;

    try {
      isCreating.value = true;
      await _adsService.createAd(
        imagePath: selectedImagePath.value,
        //productId: selectedProductId.value,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        description: descriptionController.text.trim(),
        arDescription: arDescriptionController.text.trim(),
        isActive: isActive.value,
      );
      await getAds();
      clearForm();
      showMassage('Ad created successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createAd: ${e.message}');
    } catch (e) {
      showMassage('Failed to create ad', false);
      log('Error in createAd: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateAd() async {
    final ad = selectedAd.value;
    if (ad?.id == null) return;
    if (!_validateForm(requireImage: false)) return;

    try {
      isUpdating.value = true;
      await _adsService.updateAd(
        id: ad!.id!,
        imagePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
        // productId: selectedProductId.value,
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        description: descriptionController.text.trim(),
        arDescription: arDescriptionController.text.trim(),
        isActive: isActive.value,
      );
      await getAds();
      clearForm();
      showMassage('Ad updated successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateAd: ${e.message}');
    } catch (e) {
      showMassage('Failed to update ad', false);
      log('Error in updateAd: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      isDeleting.value = true;
      await _adsService.deleteAd(id);
      await getAds();
      showMassage('Ad deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteAd: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete ad', false);
      log('Error in deleteAd: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> changeStatus({required int adId, required int isActive}) async {
    try {
      isUpdatingStatus.value = true;
      await _adsService.changeAdStatus(id: adId, isActive: isActive);
      await getAds();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in changeStatus: ${e.message}');
    } catch (e) {
      showMassage('Failed to change ad status', false);
      log('Error in changeStatus: $e');
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
