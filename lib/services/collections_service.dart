import 'dart:developer';

import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class CollectionsService {
  final DioClient _dioClient = DioClient();

  void _logRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? payload,
  }) {
    final hasPayload = payload != null && payload.isNotEmpty;
    log(
      '[CollectionsService] $method $endpoint${hasPayload ? ' | payload: $payload' : ''}',
    );
  }

  Future<List<CollectionModel>> getCollections() async {
    try {
      _logRequest('GET', ApiEndpoint.getCollections);
      final response = await _dioClient.get(ApiEndpoint.getCollections);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json as List?) ?? <dynamic>[];
        return list
            .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<CollectionModel>;
      }
      throw Exception(apiResponse.message ?? 'Failed to load collections');
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException getCollections : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('collections service DioException getCollections : ${e.message}');
      throw Exception(e.message);
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
      final payloadForLog = <String, dynamic>{
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        'status': status,
        'image_path': imagePath,
      };
      _logRequest(
        'POST',
        ApiEndpoint.createParentCollection,
        payload: payloadForLog,
      );

      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        'status': status,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.post(
        ApiEndpoint.createParentCollection,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Failed to create parent collection',
        );
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException createParentCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'collections service DioException createParentCollection : ${e.message}',
      );
      throw Exception(e.message);
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
      final payloadForLog = <String, dynamic>{
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (conditionType != null) 'condition_type': conditionType,
        'status': status,
        'image_path': imagePath,
        if (brand != null) 'brand': brand,
        if (subCategory != null) 'sub_category': subCategory,
        if (tags != null) 'tags': tags,
        if (customProducts != null) 'custom_products': customProducts,
      };
      _logRequest('POST', ApiEndpoint.createCollection, payload: payloadForLog);

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

      final response = await _dioClient.post(
        ApiEndpoint.createCollection,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create collection');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException createCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('collections service DioException createCollection : ${e.message}');
      throw Exception(e.message);
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
      final payloadForLog = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (status != null) 'status': status,
        if (imagePath != null) 'image_path': imagePath,
      };
      _logRequest(
        'PUT',
        ApiEndpoint.updateParentCollection(id),
        payload: payloadForLog,
      );

      final map = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (status != null) 'status': status,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final response = await _dioClient.put(
        ApiEndpoint.updateParentCollection(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update collection');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException updateParentCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'collections service DioException updateParentCollection : ${e.message}',
      );
      throw Exception(e.message);
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
      final payloadForLog = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (conditionType != null) 'condition_type': conditionType,
        if (status != null) 'status': status,
        if (brand != null) 'brand': brand,
        if (subCategory != null) 'sub_category': subCategory,
        if (tags != null) 'tags': tags,
        if (customProducts != null) 'custom_products': customProducts,
        if (imagePath != null) 'image_path': imagePath,
      };
      _logRequest(
        'PUT',
        ApiEndpoint.updateProductsCollection(id),
        payload: payloadForLog,
      );

      final map = <String, dynamic>{
        if (title != null) 'title': title,
        if (arTitle != null) 'ar_title': arTitle,
        if (parentCollectionId != null)
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

      final response = await _dioClient.put(
        ApiEndpoint.updateProductsCollection(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update collection');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException updateProductsCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log(
        'collections service DioException updateProductsCollection : ${e.message}',
      );
      throw Exception(e.message);
    } catch (e) {
      log(
        'collections service catch updateProductsCollection : ${e.toString()}',
      );
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
      _logRequest('DELETE', ApiEndpoint.deleteCollection(id));
      final response = await _dioClient.delete(
        ApiEndpoint.deleteCollection(id),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);
      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete collection');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'collections service AppException deleteCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('collections service DioException deleteCollection : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('collections service catch deleteCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
