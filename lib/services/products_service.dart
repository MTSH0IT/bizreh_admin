import 'dart:developer';

import 'package:bizreh_admin/features/products/models/product_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class ProductsService {
  final DioClient _dioClient = DioClient();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getProducts);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
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
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'products service AppException getProducts : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('products service DioException getProducts : ${e.message}');
      throw Exception(e.message);
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
        'brand_id': brandId,
        'sub_category_id': subCategoryId,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.post(
        ApiEndpoint.createProducts,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to create product');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'products service AppException createProduct : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('products service DioException createProduct : ${e.message}');
      throw Exception(e.message);
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
        'brand_id': brandId,
        'sub_category_id': subCategoryId,
        'is_active': isActive,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      };

      final formData = FormData.fromMap(map);

      final response = await _dioClient.put(
        ApiEndpoint.updateProducts(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update product');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'products service AppException updateProduct : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('products service DioException updateProduct : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('products service catch updateProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteProducts(id));

      final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete product');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          'products service AppException deleteProduct : ${err.message}${err.statusCode}',
        );
        throw err;
      }
      log('products service DioException deleteProduct : ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      log('products service catch deleteProduct : ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
