import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model/product_model.dart';
import 'package:bizreh_admin/helper/dioApiService/i_api_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ProductsService {
  final IApiClient _apiClient;

  ProductsService({required IApiClient apiClient}) : _apiClient = apiClient;

  Future<ProductModel?> getProductById(int id) async {
    try {
      final data = await _apiClient.get('${ApiEndpoint.getProducts}/$id');

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final productWrapper = json['product']['product'];
        return ProductModel.fromJson(productWrapper as Map<String, dynamic>);
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as ProductModel;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products service catch getProductById : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final data = await _apiClient.get(ApiEndpoint.getProducts);

      final apiResponse = ApiResponse.fromJson(data, (json) {
        final productsWrapper = json['products'];
        final List list =
            (productsWrapper?['products'] as List?) ?? <dynamic>[];
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ProductModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products service catch getProducts : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> createProduct({
    required String title,
    required String arTitle,
    required String position,
    required String description,
    required String arDescription,
    required String tags,
    required int brandId,
    required int subCategoryId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'description': description,
        'ar_description': arDescription,
        'tags': tags,
        'brand_id': brandId,
        'sub_category_id': subCategoryId,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final data = await _apiClient.post(
        ApiEndpoint.createProducts,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create product');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products service catch createProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateProduct({
    required int id,
    required String title,
    required String arTitle,
    required String position,
    required String description,
    required String arDescription,
    required String tags,
    required int brandId,
    required int subCategoryId,
    required int isActive,
    String? imagePath,
  }) async {
    try {
      final map = <String, dynamic>{
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'description': description,
        'ar_description': arDescription,
        'tags': tags,
        'brand_id': brandId,
        'sub_category_id': subCategoryId,
        'is_active': isActive,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final data = await _apiClient.put(
        ApiEndpoint.updateProducts(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update product');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products service catch updateProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final data = await _apiClient.delete(ApiEndpoint.deleteProducts(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete product');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      log('products service catch deleteProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
