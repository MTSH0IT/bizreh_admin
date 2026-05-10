import 'dart:developer';

import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class CollectionsService {
  final IApiClient _apiClient;

  CollectionsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CollectionModel>> getCollections() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getCollections);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<CollectionModel>;
      }
      throw Exception(apiResponse.message ?? 'Failed to load collections');
    } on AppException {
      rethrow;
    } catch (e) {
      log('collections service catch getCollections : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createParentCollection({
    required String title,
    required String arTitle,
    int? parentCollectionId,
    required int status,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        'status': status,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.post(
        ApiEndpoint.createParentCollection,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create parent collection',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('collections service catch createParentCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createCollection({
    required String title,
    required String arTitle,
    int? parentCollectionId,
    String? conditionType,
    required int status,
    required String imagePath,
    String? brand,
    String? subCategory,
    String? tags,
    String? customProducts,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (conditionType != null) 'condition_type': conditionType,
        'status': status,
        'image': await MultipartFile.fromFile(imagePath),
        if (brand != null) 'brand': brand,
        if (subCategory != null) 'sub_category': subCategory,
        if (tags != null) 'tags': tags,
        if (customProducts != null) 'custom_products': customProducts,
      });

      final data = await _apiClient.post(
        ApiEndpoint.createCollection,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create collection');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('collections service catch createCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateParentCollection({
    required int id,
    String? title,
    String? arTitle,
    int? parentCollectionId,
    int? status,
    String? imagePath,
  }) async {
    try {
      final map = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        // if (parentCollectionId != null)
        'parent_collection_id': parentCollectionId,
        if (status != null) 'status': status,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final data = await _apiClient.put(
        ApiEndpoint.updateParentCollection(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update collection');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('collections service catch updateParentCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateProductsCollection({
    required int id,
    String? title,
    String? arTitle,
    int? parentCollectionId,
    String? conditionType,
    int? status,
    String? imagePath,
    String? brand,
    String? subCategory,
    String? tags,
    String? customProducts,
  }) async {
    try {
      final map = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        // if (parentCollectionId != null)
        'parent_collection_id': parentCollectionId,
        if (conditionType != null) 'condition_type': conditionType,
        if (status != null) 'status': status,
        if (brand != null) 'brand': brand,
        if (subCategory != null) 'sub_category': subCategory,
        if (tags != null) 'tags': tags,
        if (customProducts != null) 'custom_products': customProducts,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final data = await _apiClient.put(
        ApiEndpoint.updateProductsCollection(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update collection');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log(
        'collections service catch updateProductsCollection : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
      final data = await _apiClient.delete(
        ApiEndpoint.deleteCollection(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete collection');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('collections service catch deleteCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
