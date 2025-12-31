import 'dart:developer';

import 'package:bizreh_admin/features/Brands/models/brands_model.dart';
import 'package:bizreh_admin/helper/dioApiService/dio_client.dart';
import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:bizreh_admin/utils/consts/api_endpoint.dart';
import 'package:bizreh_admin/utils/models/api_response.dart';
import 'package:dio/dio.dart';

class BrandsService {
  final DioClient _dioClient = DioClient();

  Future<List<BrandsModel>> getBrands() async {
    try {
      final response = await _dioClient.get(ApiEndpoint.getBrands);

      final apiResponse = ApiResponse.fromJson(response.data, (json) {
        final List list = (json['brands'] as List?) ?? [];
        return list
            .map((e) => BrandsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      });

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<BrandsModel>;
      } else {
        throw Exception(apiResponse.message ?? 'Something went wrong');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "brands service AppException getBrands : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("brands service DioException getBrands : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("brands service catch featured brands : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> createBrand({
    required String title,
    required String arTitle,
    required String position,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.post(
        ApiEndpoint.createBrand,
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.success) {
        log("${apiResponse.message}");
      } else {
        throw Exception(apiResponse.message ?? 'Failed to create brand');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "brands service AppException createBrand : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("brands service DioException createBrand : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("brands service catch createBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> updateBrand({
    required int id,
    required String title,
    required String arTitle,
    required String position,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'ar_title': arTitle,
        'position': position,
        if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dioClient.put(
        ApiEndpoint.updateBrand(id),
        data: formData,
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to update brand');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "brands service AppException updateBrand : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("brands service DioException updateBrand : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("brands service catch updateBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBrand(int id) async {
    try {
      final response = await _dioClient.delete(ApiEndpoint.deleteBrand(id));

      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Failed to delete brand');
      }
    } on DioException catch (e) {
      final err = e.error;
      if (err is AppException) {
        log(
          "brands service AppException deleteBrand : ${err.message}${err.statusCode}",
        );
        throw err;
      }
      log("brands service DioException deleteBrand : ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("brands service catch deleteBrand : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Future<List<dynamic>> getBrandProducts(int brandId) async {
  //   try {
  //     final response = await _dioClient.get(
  //       ApiEndpoint.getBrandProducts(brandId),
  //     );

  //     final apiResponse = ApiResponse.fromJson(response.data, (json) {
  //       final List list = (json['products'] as List?) ?? [];
  //       return list.map((e) => e).toList();
  //     });

  //     if (apiResponse.success && apiResponse.data != null) {
  //       return apiResponse.data as List<dynamic>;
  //     } else {
  //       throw Exception(apiResponse.message ?? 'Failed to get brand products');
  //     }
  //   } on DioException catch (e) {
  //     final err = e.error;
  //     if (err is AppException) {
  //       log(
  //         "brands service AppException getBrandProducts : ${err.message}${err.statusCode}",
  //       );
  //       throw err;
  //     }
  //     log("brands service DioException getBrandProducts : ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log("brands service catch getBrandProducts : ${e.toString()}");
  //     throw Exception(e.toString());
  //   }
  // }
}
