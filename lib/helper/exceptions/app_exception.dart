/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  AppException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException({required super.message});
}

/// Timeout exception
class TimeoutException extends AppException {
  TimeoutException({required super.message});
}

/// Request cancelled exception
class RequestCancelledException extends AppException {
  RequestCancelledException({required super.message});
}

/// Certificate verification exception
class CertificateException extends AppException {
  CertificateException({required super.message});
}

/// Bad request (400)
class BadRequestException extends AppException {
  BadRequestException({required super.message}) : super(statusCode: 400);
}

/// Unauthorized (401)
class UnauthorizedException extends AppException {
  UnauthorizedException({required super.message}) : super(statusCode: 401);
}

/// Forbidden (403)
class ForbiddenException extends AppException {
  ForbiddenException({required super.message}) : super(statusCode: 403);
}

/// Not found (404)
class NotFoundException extends AppException {
  NotFoundException({required super.message}) : super(statusCode: 404);
}

/// Validation error (422)
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({required super.message, this.errors})
    : super(statusCode: 422, data: errors);
}

/// Internal server error (500)
class ServerException extends AppException {
  ServerException({required super.message}) : super(statusCode: 500);
}

/// Service unavailable (503)
class ServiceUnavailableException extends AppException {
  ServiceUnavailableException({required super.message})
    : super(statusCode: 503);
}

/// Unknown exception
class UnknownException extends AppException {
  UnknownException({required super.message});
}

/// Cache exception
class CacheException extends AppException {
  CacheException({required super.message});
}
