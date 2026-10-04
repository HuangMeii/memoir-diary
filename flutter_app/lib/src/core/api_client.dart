import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'config.dart';

/// Thrown for any non-2xx API response, carrying a message fit for the UI.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;
  bool get isConflict => statusCode == 409;

  @override
  String toString() => message;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  // Attach the bearer token to every request while authenticated.
  ref.listen<String?>(authTokenProvider, (_, token) {
    client.token = token;
  });
  client.token = ref.read(authTokenProvider);
  return client;
});

class ApiClient {
  ApiClient() : _dio = Dio();

  final Dio _dio;
  String? token;

  String get baseUrl => AppConfig.apiBaseUrl;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get('$baseUrl$path', queryParameters: query));

  Future<dynamic> post(
    String path, {
    Object? data,
    Options? options,
  }) =>
      _send(() => _dio.post('$baseUrl$path', data: data, options: options));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put('$baseUrl$path', data: data));

  Future<dynamic> delete(String path) => _send(() => _dio.delete('$baseUrl$path'));

  /// Uploads an image as multipart/form-data.
  Future<dynamic> uploadImage(String path, String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return _send(() => _dio.post('$baseUrl$path', data: form));
  }

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (error) {
      throw ApiException(_messageOf(error), statusCode: error.response?.statusCode);
    }
  }

  /// Turn FastAPI error bodies into a single readable line.
  String _messageOf(DioException error) {
    final status = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      final detail = data['detail'];
      // FastAPI validation errors: detail is a list of field problems.
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map) {
          final field = (first['loc'] is List && first['loc'].length > 1)
              ? first['loc'][1]
              : '';
          return '$field: ${first['msg']}';
        }
      }
      return detail.toString();
    }

    if (status == 401) return 'Chưa đăng nhập hoặc phiên đã hết hạn.';
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Máy chủ phản hồi quá chậm. Kiểm tra backend đã chạy chưa?';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Không kết nối được tới $baseUrl.\nHãy chạy backend và kiểm tra API_BASE_URL.';
    }
    return 'Lỗi không xác định${status == null ? '' : ' ($status)'}';
  }
}