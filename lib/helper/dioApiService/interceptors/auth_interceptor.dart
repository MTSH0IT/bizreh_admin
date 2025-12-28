// import 'package:bizreh_admin/features/auth/controllers/auth_controller.dart';
// import 'package:dio/dio.dart';

// /// Interceptor for adding authentication token to requests
// class AuthInterceptor extends Interceptor {
//   // final StorageService _storageService = StorageService();

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // Get access token from storage and attach to headers if present
//     try {
//       final token = AuthController.token;
//       if (token != null && token.isNotEmpty) {
//         options.headers['Authorization'] = 'Bearer $token';
//       }
//     } catch (_) {}

//     return handler.next(options);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     // Handle response if needed
//     return handler.next(response);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     // Handle 401 Unauthorized - Token expired
//     if (err.response?.statusCode == 401) {
//       // Handle token expiration
//       // e.g., redirect to login page or refresh token
//     }
//     return handler.next(err);
//   }
// }
