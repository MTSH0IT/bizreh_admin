import 'dart:developer';

import 'package:bizreh_admin/features/Brands/controllers/brands_controler.dart';
import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/features/products/controllers/products_controller.dart';
import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/features/sub_category/controllers/all_sub_category_crud_controller.dart';
import 'package:bizreh_admin/features/sub_category/models/all_sub_category_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/brands_service.dart';
import 'package:bizreh_admin/services/collections_service.dart';
import 'package:bizreh_admin/services/products_service.dart';
import 'package:bizreh_admin/services/sub_category_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionsController extends GetxController {
  final CollectionsService _service;
  final ProductsService _productsService;
  final BrandsService _brandsService;
  final SubCategoryService _subCategoryService;

  CollectionsController({
    required CollectionsService collectionsService,
    required ProductsService productsService,
    required BrandsService brandsService,
    required SubCategoryService subCategoryService,
  }) : _service = collectionsService,
       _productsService = productsService,
       _brandsService = brandsService,
       _subCategoryService = subCategoryService;

  final RxList<CollectionModel> collections = <CollectionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final RxBool isMetaLoading = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<BrandsModel> brands = <BrandsModel>[].obs;
  final RxList<AllSubCategoryModel> subCategories = <AllSubCategoryModel>[].obs;

  final RxString searchQuery = ''.obs;

  final Rx<CollectionModel?> selectedCollection = Rx<CollectionModel?>(null);
  final RxInt selectedParentId = 0.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController tagInputController = TextEditingController();
  final RxList<String> formTags = <String>[].obs;

  final RxList<int> selectedBrandIds = <int>[].obs;
  final RxList<int> selectedSubCategoryIds = <int>[].obs;
  final RxList<int> selectedCustomProductIds = <int>[].obs;

  final RxString conditionType = 'and'.obs;
  final RxInt status = 1.obs;
  final RxString selectedImagePath = ''.obs;

  final RxBool isParentApi = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCollections();
    getMeta();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    tagInputController.dispose();
    super.onClose();
  }

  Future<void> getMeta() async {
    final productsController = Get.isRegistered<ProductsController>()
        ? Get.find<ProductsController>()
        : null;
    final brandsController = Get.isRegistered<BrandsController>()
        ? Get.find<BrandsController>()
        : null;
    final subCategoriesController =
        Get.isRegistered<AllSubCategoryCrudController>()
        ? Get.find<AllSubCategoryCrudController>()
        : null;

    if (productsController != null && productsController.products.isNotEmpty) {
      products.assignAll(productsController.products);
    }

    if (brandsController != null && brandsController.brands.isNotEmpty) {
      brands.assignAll(brandsController.brands);
    }

    if (subCategoriesController != null &&
        subCategoriesController.allSubCategories.isNotEmpty) {
      subCategories.assignAll(subCategoriesController.allSubCategories);
    }

    if (products.isNotEmpty && brands.isNotEmpty && subCategories.isNotEmpty) {
      return;
    }

    try {
      isMetaLoading.value = true;

      final futures = <Future<dynamic>>[];
      final keys = <String>[];

      if (products.isEmpty) {
        futures.add(_productsService.getProducts());
        keys.add('products');
      }
      if (brands.isEmpty) {
        futures.add(_brandsService.getBrands());
        keys.add('brands');
      }
      if (subCategories.isEmpty) {
        futures.add(_subCategoryService.getAllSubCategories());
        keys.add('subCategories');
      }

      final results = await Future.wait(futures);

      for (var i = 0; i < results.length; i++) {
        switch (keys[i]) {
          case 'products':
            products.assignAll(results[i] as List<ProductModel>);
            break;
          case 'brands':
            brands.assignAll(results[i] as List<BrandsModel>);
            break;
          case 'subCategories':
            subCategories.assignAll(results[i] as List<AllSubCategoryModel>);
            break;
        }
      }
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getMeta: ${e.message}');
    } catch (e) {
      showMassage('Failed to load products/brands/sub categories', false);
      log('Error in getMeta: $e');
    } finally {
      isMetaLoading.value = false;
    }
  }

  void setSelectedBrands(List<int> ids) {
    selectedBrandIds.assignAll(ids);
  }

  void setSelectedSubCategories(List<int> ids) {
    selectedSubCategoryIds.assignAll(ids);
  }

  void setSelectedCustomProducts(List<int> ids) {
    selectedCustomProductIds.assignAll(ids);
  }

  Future<void> getCollections() async {
    try {
      isLoading.value = true;
      final fetched = await _service.getCollections();
      collections.assignAll(fetched);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in getCollections: ${e.message}');
    } catch (e) {
      showMassage('Failed to load collections', false);
      log('Error in getCollections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  List<CollectionModel> get filteredCollections {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return collections.toList();

    bool matchCollection(CollectionModel model) {
      final title = (model.title ?? '').toLowerCase();
      final arTitle = (model.arTitle ?? '').toLowerCase();
      if (title.contains(q) || arTitle.contains(q)) return true;
      final children = model.subCollections ?? const <CollectionModel>[];
      return children.any(matchCollection);
    }

    return collections.where(matchCollection).toList();
  }

  List<CollectionParentOption> get parentOptions {
    final result = <CollectionParentOption>[
      const CollectionParentOption(id: 0, title: 'None', depth: 0),
    ];

    void addNode(CollectionModel model, int depth) {
      if (model.id != null) {
        final label = (model.title?.trim().isNotEmpty == true)
            ? model.title!
            : (model.arTitle?.trim().isNotEmpty == true)
            ? model.arTitle!
            : 'Collection #${model.id}';

        result.add(
          CollectionParentOption(id: model.id!, title: label, depth: depth),
        );
      }
      for (final child in model.subCollections ?? const <CollectionModel>[]) {
        addNode(child, depth + 1);
      }
    }

    for (final c in collections) {
      addNode(c, 0);
    }

    return result;
  }

  bool get isEditing => selectedCollection.value != null;
  bool get isEditingProductsType =>
      (selectedCollection.value?.type ?? '').toLowerCase() == 'products';

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    tagInputController.clear();
    formTags.clear();
    selectedBrandIds.clear();
    selectedSubCategoryIds.clear();
    selectedCustomProductIds.clear();
    conditionType.value = 'and';
    status.value = 1;
    selectedImagePath.value = '';
    isParentApi.value = false;
    selectedCollection.value = null;
    selectedParentId.value = 0;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setForCreateParent({int? parentId}) {
    clearForm();
    selectedParentId.value = parentId ?? 0;
    isParentApi.value = true;
  }

  void setForEdit(CollectionModel model) {
    selectedCollection.value = model;
    titleController.text = model.title ?? '';
    arTitleController.text = model.arTitle ?? '';
    selectedBrandIds.assignAll(model.conditions?.brand ?? []);
    selectedSubCategoryIds.assignAll(model.conditions?.subCategory ?? []);
    formTags.assignAll(model.conditions?.tags ?? const <String>[]);
    selectedCustomProductIds.assignAll(model.customProductsArray ?? []);
    conditionType.value = (model.conditionType ?? 'and').toString();
    status.value = model.status ?? 1;
    selectedParentId.value = model.parentCollectionId ?? 0;
  }

  Future<void> createParentCollection() async {
    try {
      if (!_validateForm(requireImage: true)) return;
      isCreating.value = true;

      final parent = selectedParentId.value;
      await _service.createParentCollection(
        title: titleController.text.trim(),
        arTitle: arTitleController.text.trim(),
        parentCollectionId: parent == 0 ? null : parent,
        status: status.value,
        imagePath: selectedImagePath.value,
      );

      await getCollections();
      clearForm();
      showMassage('Collection created successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createParentCollection: ${e.message}');
    } catch (e) {
      showMassage('Failed to create collection', false);
      log('Error in createParentCollection: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> createCollection() async {
    try {
      if (!_validateForm(requireImage: true)) return;
      isCreating.value = true;
      final parent = selectedParentId.value;
      await _service.createCollection(
        title: _trimmedOrNull(titleController.text) ?? '',
        arTitle: _trimmedOrNull(arTitleController.text) ?? '',
        parentCollectionId: parent == 0 ? null : parent,
        conditionType: conditionType.value,
        status: status.value,
        imagePath: selectedImagePath.value,
        brand: _idsCsvOrNull(selectedBrandIds),
        subCategory: _idsCsvOrNull(selectedSubCategoryIds),
        tags: _trimmedOrNull(tagsApiValue),
        customProducts: _idsCsvOrNull(selectedCustomProductIds),
      );

      await getCollections();
      clearForm();
      showMassage('Collection created successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in createCollection: ${e.message}');
    } catch (e) {
      showMassage('Failed to create collection', false);
      log('Error in createCollection: $e');
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateCollection() async {
    final model = selectedCollection.value;
    if (model?.id == null) return;

    try {
      final hasExistingImage = (model?.image ?? '').trim().isNotEmpty;
      if (!_validateForm(requireImage: !hasExistingImage)) return;
      isUpdating.value = true;

      final parent = selectedParentId.value;
      final isProductsType = (model!.type ?? '').toLowerCase() == 'products';

      if (isProductsType) {
        await _service.updateProductsCollection(
          id: model.id!,
          title: _trimmedOrNull(titleController.text),
          arTitle: _trimmedOrNull(arTitleController.text),
          parentCollectionId: parent == 0 ? null : parent,
          conditionType: conditionType.value,
          status: status.value,
          imagePath: selectedImagePath.value.isEmpty
              ? null
              : selectedImagePath.value,
          brand: selectedBrandIds.join(','),
          subCategory: selectedSubCategoryIds.join(','),
          tags: _trimmedOrNull(tagsApiValue) ?? '',
          customProducts: selectedCustomProductIds.join(','),
        );
      } else {
        await _service.updateParentCollection(
          id: model.id!,
          title: _trimmedOrNull(titleController.text),
          arTitle: _trimmedOrNull(arTitleController.text),
          parentCollectionId: parent == 0 ? null : parent,
          status: status.value,
          imagePath: selectedImagePath.value.isEmpty
              ? null
              : selectedImagePath.value,
        );
      }

      await getCollections();
      clearForm();
      showMassage('Collection updated successfully', true);
      Get.back();
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in updateCollection: ${e.message}');
    } catch (e) {
      showMassage('Failed to update collection', false);
      log('Error in updateCollection: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
      isDeleting.value = true;
      await _service.deleteCollection(id);
      await getCollections();
      showMassage('Collection deleted successfully', true);
    } on AppException catch (e) {
      showMassage(e.message, false);
      log('AppException in deleteCollection: ${e.message}');
    } catch (e) {
      showMassage('Failed to delete collection', false);
      log('Error in deleteCollection: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  List<String> _parseTagsFromText(String raw) {
    final tags = <String>[];
    for (final part in raw.split(RegExp(r'[,\n\u060C]'))) {
      final tag = part.trim();
      if (tag.isEmpty) continue;
      tags.add(tag);
    }
    return tags;
  }

  String get tagsApiValue => formTags.join(',');

  String? _trimmedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _idsCsvOrNull(RxList<int> ids) {
    if (ids.isEmpty) return null;
    return ids.join(',');
  }

  void addTagFromInput([String? value]) {
    final input = (value ?? tagInputController.text).trim();
    if (input.isEmpty) return;
    final incoming = _parseTagsFromText(input);
    if (incoming.isEmpty) return;
    formTags.addAll(incoming);
    tagInputController.clear();
  }

  void removeTag(String tag) {
    formTags.removeWhere((t) => t.toLowerCase() == tag.toLowerCase());
  }

  bool _validateForm({required bool requireImage}) {
    final titleError = _validateTitle(titleController.text);
    if (titleError != null) {
      showMassage(titleError, false);
      return false;
    }

    final arTitleError = _validateArTitle(arTitleController.text);
    if (arTitleError != null) {
      showMassage(arTitleError, false);
      return false;
    }

    final imageError = _validateImagePath(
      selectedImagePath.value,
      requireImage: requireImage,
    );
    if (imageError != null) {
      showMassage(imageError, false);
      return false;
    }

    return true;
  }

  String? _validateTitle(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Title is required';
    return null;
  }

  String? _validateArTitle(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Arabic title is required';
    return null;
  }

  String? _validateImagePath(String value, {required bool requireImage}) {
    final v = value.trim();
    if (requireImage && v.isEmpty) return 'Image is required';
    return null;
  }
}

class CollectionParentOption {
  final int id;
  final String title;
  final int depth;

  const CollectionParentOption({
    required this.id,
    required this.title,
    required this.depth,
  });

  String get displayTitle {
    final prefix = depth <= 0 ? '' : '${'  ' * depth}|_ ';
    return '$prefix$title';
  }
}
