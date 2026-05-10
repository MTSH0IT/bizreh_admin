import 'dart:developer';

import 'package:bizreh_admin/features/offers_cart/models/offers_cart_model/offers_cart_model.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/offers_cart_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:bizreh_admin/helper/di/service_locator.dart';
import 'package:get/get.dart';

import '../../products/controllers/products_controller.dart';

class OffersCartItemInput {
  final RxnInt selectedOptionPackagingId;
  final TextEditingController quantityController;

  OffersCartItemInput({int? optionPackagingId, int? quantity})
    : selectedOptionPackagingId = RxnInt(optionPackagingId),
      quantityController = TextEditingController(
        text: quantity?.toString() ?? '',
      );

  void dispose() {
    quantityController.dispose();
  }
}

class OffersCartController extends GetxController {
  final OffersCartService _service = sl<OffersCartService>();
  final ProductsService _productsService = sl<ProductsService>();

  final RxList<OffersCartModel> offers = <OffersCartModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxBool isMetaLoading = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isToggling = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController arNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController arDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final RxInt selectedIsActive = 1.obs;

  final Rx<OffersCartModel?> selectedOffer = Rx<OffersCartModel?>(null);

  final RxList<OffersCartItemInput> items = <OffersCartItemInput>[].obs;

  final RxString searchQuery = ''.obs;

  List<DropdownMenuItem<int>> get optionPackagingItems {
    final seen = <int>{};
    final out = <DropdownMenuItem<int>>[];

    for (final p in products) {
      final productLabel = (p.title?.isNotEmpty == true
          ? p.title!
          : (p.arTitle ?? '-'));
      final options = p.options ?? const [];

      for (final opt in options) {
        final optLabel = (opt.optionName?.isNotEmpty == true
            ? opt.optionName!
            : (opt.arOptionName ?? '-'));
        final mappings = opt.packagingOptions ?? const [];

        for (final m in mappings) {
          final id = m.id;
          if (id == null || !seen.add(id)) continue;
          final pkgLabel = (m.packagingTitle?.isNotEmpty == true
              ? m.packagingTitle!
              : (m.arPackagingTitle ?? '-'));
          final skuLabel = m.optionSku?.isNotEmpty == true ? m.optionSku! : '-';
          final mainLine = '$productLabel / $optLabel / $pkgLabel';
          final metaLine = 'SKU: $skuLabel  |  #$id';
          out.add(
            DropdownMenuItem<int>(
              value: id,
              child: Text(
                '$mainLine\n$metaLine',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(height: 1.25),
              ),
            ),
          );
        }
      }
    }

    return out;
  }

  @override
  void onInit() {
    super.onInit();
    getOffers();
    getMeta();
    if (items.isEmpty) {
      addItemRow();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    arNameController.dispose();
    descriptionController.dispose();
    arDescriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();

    for (final i in items) {
      i.dispose();
    }

    super.onClose();
  }

  @override
  Future<void> refresh() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getOffersCart();
      offers.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getOffers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load offers', false);
      log('Error in getOffers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOffers() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getOffersCart();
      offers.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getOffers: ${e.message}');
    } catch (e) {
      showMassage('Failed to load offers', false);
      log('Error in getOffers: $e');
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

    if (products.isNotEmpty) return;

    try {
      isMetaLoading.value = true;
      final data = await _productsService.getProducts();
      products.assignAll(data);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getMeta: ${e.message}');
    } catch (e) {
      showMassage('Failed to load products meta', false);
      log('Error in getMeta: $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  void setSearchQuery(String q) => searchQuery.value = q;

  List<OffersCartModel> get filteredOffers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return offers.toList();
    return offers.where((o) {
      final name = (o.name ?? '').toLowerCase();
      final arName = (o.arName ?? '').toLowerCase();
      return name.contains(q) || arName.contains(q);
    }).toList();
  }

  bool get isEditing => selectedOffer.value != null;

  void addItemRow({int? optionPackagingId, int? quantity}) {
    items.add(
      OffersCartItemInput(
        optionPackagingId: optionPackagingId,
        quantity: quantity,
      ),
    );
  }

  void removeItemRow(int index) {
    if (index < 0 || index >= items.length) return;
    final removed = items.removeAt(index);
    removed.dispose();
    if (items.isEmpty) {
      addItemRow();
    }
  }

  void clearForm() {
    nameController.clear();
    arNameController.clear();
    descriptionController.clear();
    arDescriptionController.clear();
    priceController.clear();
    quantityController.clear();

    selectedIsActive.value = 1;
    selectedOffer.value = null;

    for (final i in items) {
      i.dispose();
    }
    items.clear();
    addItemRow();
  }

  void setOfferForEdit(OffersCartModel offer) {
    selectedOffer.value = offer;

    nameController.text = offer.name ?? '';
    arNameController.text = offer.arName ?? '';
    descriptionController.text = offer.description ?? '';
    arDescriptionController.text = offer.arDescription ?? '';
    priceController.text = offer.price ?? '';
    quantityController.text = offer.quantity?.toString() ?? '';

    selectedIsActive.value = offer.isActive ?? 1;

    for (final i in items) {
      i.dispose();
    }
    items.clear();

    final currentItems = offer.items ?? const [];
    if (currentItems.isEmpty) {
      addItemRow();
    } else {
      for (final item in currentItems) {
        addItemRow(
          optionPackagingId: item.optionPackagingId,
          quantity: item.quantity,
        );
      }
    }
  }

  void setIsActive(int? v) {
    if (v == null) return;
    selectedIsActive.value = v;
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      showMassage('Please enter name', false);
      return false;
    }
    if (arNameController.text.trim().isEmpty) {
      showMassage('Please enter Arabic name', false);
      return false;
    }
    final String price = priceController.text.trim();
    if (price.isEmpty) {
      showMassage('Please enter valid price', false);
      return false;
    }
    final qty = int.tryParse(quantityController.text.trim());
    if (qty == null || qty <= 0) {
      showMassage('Please enter valid quantity', false);
      return false;
    }

    final nonEmptyItems = items.where((i) {
      final id = i.selectedOptionPackagingId.value;
      final q = int.tryParse(i.quantityController.text.trim());
      return id != null && id > 0 && q != null && q > 0;
    }).toList();

    if (nonEmptyItems.isEmpty) {
      showMassage('Please add at least one item', false);
      return false;
    }

    return true;
  }

  Map<String, dynamic> _buildBody() {
    final itemsBody = <Map<String, dynamic>>[];

    for (final i in items) {
      final id = i.selectedOptionPackagingId.value;
      final q = int.tryParse(i.quantityController.text.trim());
      if (id == null || id <= 0 || q == null || q <= 0) continue;
      itemsBody.add({'option_packaging_id': id, 'quantity': q});
    }

    return {
      'name': nameController.text.trim(),
      'ar_name': arNameController.text.trim(),
      'description': descriptionController.text.trim(),
      'ar_description': arDescriptionController.text.trim(),
      'price': priceController.text.trim(),
      'quantity':
          int.tryParse(quantityController.text.trim()) ??
          quantityController.text.trim(),
      'items': itemsBody,
      'is_active': selectedIsActive.value,
    };
  }

  Future<void> createOffer() async {
    if (!_validateForm()) return;

    try {
      isCreating.value = true;
      await _service.createOffer(body: _buildBody());
      await getOffers();
      clearForm();
      Get.back();
      showMassage('Offer created successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to create offer', false);
      log('Error in createOffer: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateOffer() async {
    final current = selectedOffer.value;
    if (current?.id == null) return;
    if (!_validateForm()) return;

    try {
      isUpdating.value = true;
      await _service.updateOffer(id: current!.id!, body: _buildBody());
      await getOffers();
      clearForm();
      Get.back();
      showMassage('Offer updated successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to update offer', false);
      log('Error in updateOffer: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteOffer(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteOffer(id);
      await getOffers();
      showMassage('Offer deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteOffer: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete offer', false);
      log('Error in deleteOffer: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> toggleStatus(int id, {required int currentIsActive}) async {
    try {
      isToggling.value = true;
      final newActive = currentIsActive == 1 ? 0 : 1;

      await _service.toggleOfferStatus(id: id, isActive: newActive);

      await getOffers();
      showMassage('Offer status updated', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in toggleStatus: ${e.message}');
    } catch (e) {
      showMassage('Failed to toggle status', false);
      log('Error in toggleStatus: $e');
    } finally {
      isToggling.value = false;
    }
  }
}
