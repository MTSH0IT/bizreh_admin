import 'dart:developer';

import 'package:bizreh_admin/features/collections/models/collection_model/collection_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class CollectionsService {
  final DioClient _dioClient = DioClient();

  Future<List<CollectionModel>> getCollections() async {
    try {
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
    String? type,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        if (parentCollectionId != null)
          'parent_collection_id': parentCollectionId,
        if (conditionType != null) 'condition_type': conditionType,
        if (type != null) 'type': type,
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

  Future<void> updateCollection({
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
    String? type,
  }) async {
    try {
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
        if (type != null) 'type': type,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final response = await _dioClient.put(
        ApiEndpoint.updateCollection(id),
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
          'collections service AppException updateCollection : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('collections service DioException updateCollection : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('collections service catch updateCollection : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
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
