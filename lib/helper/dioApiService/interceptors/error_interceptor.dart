import 'package:bizreh_admin/helper/exceptions/app_exception.dart';
import 'package:dio/dio.dart';

/// Interceptor for handling HTTP errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = TimeoutException(
          message: 'Connection timeout. Please check your internet connection.',
        );
        break;

      case DioExceptionType.badResponse:
        exception = _handleHttpError(err.response);
        break;

      case DioExceptionType.cancel:
        exception = RequestCancelledException(message: 'Request was cancelled');
        break;

      case DioExceptionType.connectionError:
        exception = NetworkException(
          message: 'No internet connection. Please check your network.',
        );
        break;

      case DioExceptionType.badCertificate:
        exception = CertificateException(
          message: 'Certificate verification failed',
        );
        break;

      default:
        exception = UnknownException(
          message: 'Something went wrong. Please try again.',
        );
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  /// Handle HTTP response errors
  AppException _handleHttpError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    // Extract error message from response
    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(
          message: message,
          errors: data is Map ? data['errors'] : null,
        );
      case 500:
        return ServerException(
          message: 'Server error. Please try again later.',
        );
      case 503:
        return ServiceUnavailableException(
          message: 'Service temporarily unavailable',
        );
      default:
        return UnknownException(message: message);
    }
  }
}
