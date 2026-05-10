import 'package:bizreh_admin/helper/di/token_provider.dart';
import 'package:dio/dio.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final ITokenProvider _tokenProvider;

  AuthInterceptor(this._tokenProvider);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from storage and attach to headers if present
    try {
      final token = _tokenProvider.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle response if needed
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Handle token expiration
      // e.g., redirect to login page or refresh token
    }
    return handler.next(err);
  }
}
