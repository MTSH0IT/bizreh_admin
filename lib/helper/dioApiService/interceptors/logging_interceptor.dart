import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      dynamic requestData = options.data;
      if (requestData is FormData) {
        final fields = requestData.fields
            .map((e) => '${e.key}: ${e.value}')
            .join(', ');
        final files = requestData.files
            .map((e) => '${e.key}: ${e.value.filename}')
            .join(', ');
        requestData = 'FormData(fields: {$fields}, files: {$files})';
      }

      _logger.i(
        '📤 REQUEST[${options.method}] => PATH: ${options.path}\n'
        'Headers: ${options.headers}\n'
        'Query Parameters: ${options.queryParameters}\n'
        'Data: $requestData',
      );
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        '📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n'
        'Data: ${response.data}',
      );
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n'
        'Message: ${err.message}\n'
        'Error: ${err.error}\n'
        'Response: ${err.response?.data}',
      );
    }
    return handler.next(err);
  }
}
