import 'dart:developer';

import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/services/collections_service.dart';
import 'package:bizreh_admin/utils/func/show_massage_snacbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionsController extends GetxController {
  final CollectionsService _service = CollectionsService();

  final RxList<CollectionModel> collections = <CollectionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  final RxString searchQuery = ''.obs;

  final Rx<CollectionModel?> selectedCollection = Rx<CollectionModel?>(null);
  final RxInt selectedParentId = 0.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController arTitleController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController tagInputController = TextEditingController();
  final TextEditingController customProductsController =
      TextEditingController();
  final RxList<String> formTags = <String>[].obs;

  final RxString conditionType = 'and'.obs;
  final RxString type = 'collections'.obs;
  final RxInt status = 1.obs;
  final RxString selectedImagePath = ''.obs;

  final RxBool isParentApi = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCollections();
  }

  @override
  void onClose() {
    titleController.dispose();
    arTitleController.dispose();
    brandController.dispose();
    subCategoryController.dispose();
    tagInputController.dispose();
    customProductsController.dispose();
    super.onClose();
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

  void clearForm() {
    titleController.clear();
    arTitleController.clear();
    brandController.clear();
    subCategoryController.clear();
    tagInputController.clear();
    formTags.clear();
    customProductsController.clear();
    conditionType.value = 'and';
    type.value = 'collections';
    status.value = 1;
    selectedImagePath.value = '';
    isParentApi.value = false;
    selectedCollection.value = null;
    selectedParentId.value = 0;
  }

  void setImagePath(String path) {
    selectedImagePath.value = path;
  }

  void setForCreate({int? parentId}) {
    clearForm();
    selectedParentId.value = parentId ?? 0;
  }

  void setForCreateParent({int? parentId}) {
    setForCreate(parentId: parentId);
    isParentApi.value = true;
  }

  void setForEdit(CollectionModel model) {
    selectedCollection.value = model;
    titleController.text = model.title ?? '';
    arTitleController.text = model.arTitle ?? '';
    brandController.text = model.conditions?.brand?.toString() ?? '';
    subCategoryController.text =
        model.conditions?.subCategory?.toString() ?? '';
    formTags.assignAll(model.conditions?.tags ?? const <String>[]);
    tagInputController.clear();
    customProductsController.text = _extractCustomProducts(model);
    conditionType.value = (model.conditionType ?? 'and').toString();
    type.value = (model.type ?? 'collections').toString();
    status.value = model.status ?? 1;
    selectedImagePath.value = '';
    isParentApi.value = false;
    selectedParentId.value = model.parentCollectionId ?? 0;
  }

  Future<void> createParentCollection() async {
    try {
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
      isCreating.value = true;

      final parent = selectedParentId.value;
      await _service.createCollection(
        title: _trimmedOrNull(titleController.text) ?? '',
        arTitle: _trimmedOrNull(arTitleController.text) ?? '',
        parentCollectionId: parent == 0 ? null : parent,
        conditionType: conditionType.value,
        type: type.value,
        status: status.value,
        imagePath: selectedImagePath.value,
        brand: _trimmedOrNull(brandController.text),
        subCategory: _trimmedOrNull(subCategoryController.text),
        tags: _effectiveTagsOrNull,
        customProducts: _trimmedOrNull(customProductsController.text),
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
      isUpdating.value = true;

      final parent = selectedParentId.value;
      await _service.updateCollection(
        id: model!.id!,
        title: _trimmedOrNull(titleController.text),
        arTitle: _trimmedOrNull(arTitleController.text),
        parentCollectionId: parent == 0 ? null : parent,
        conditionType: conditionType.value,
        type: type.value,
        status: status.value,
        imagePath: selectedImagePath.value.isEmpty
            ? null
            : selectedImagePath.value,
        brand: _trimmedOrNull(brandController.text),
        subCategory: _trimmedOrNull(subCategoryController.text),
        tags: _effectiveTagsOrNull,
        customProducts: _trimmedOrNull(customProductsController.text),
      );

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

  String? get _effectiveTagsOrNull {
    final fromChips = tagsApiValue.trim();
    if (fromChips.isNotEmpty) return fromChips;
    return null;
  }

  String? _trimmedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _extractCustomProducts(CollectionModel model) {
    final list = model.customProductsArray;
    if (list != null && list.isNotEmpty) {
      return list.map((e) => e.toString()).join(',');
    }
    return model.customProducts ?? '';
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
    final prefix = depth <= 0 ? '' : '${'  ' * depth}- ';
    return '$prefix$title';
  }
}
