/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final Pagination? pagination;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.pagination,
  });

  /// Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final data = json['data'];

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: data != null && fromJsonT != null ? fromJsonT(data) : data,
      errors: json['errors'],
      pagination: data is Map<String, dynamic> && data['pagination'] != null
          ? Pagination.fromJson(data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      'pagination': pagination?.toJson(),
    };
  }

  /// Success response
  factory ApiResponse.success({
    String? message,
    T? data,
    Pagination? pagination,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      pagination: pagination,
    );
  }

  /// Error response
  factory ApiResponse.error({String? message, Map<String, dynamic>? errors}) {
    return ApiResponse<T>(success: false, message: message, errors: errors);
  }
}

/// Pagination data
class Pagination {
  final int page;
  final int limit;
  final int totalPages;
  final int total;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }

  bool get hasMore => page < totalPages;
}
