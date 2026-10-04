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

/// Holds the token that outgoing requests should send.
///
/// Kept separately from [AuthState] so a token obtained by `/auth/login` is
/// available to the `/auth/me` call that runs before the auth state is updated.
final tokenHolderProvider = Provider<TokenHolder>((ref) => TokenHolder());

class TokenHolder {
  String? _token;

  String? get value => _token;

  void set(String? token) => _token = token;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final holder = ref.watch(tokenHolderProvider);
  return ApiClient(tokenResolver: () => holder.value);
});

/// Supplies the bearer token for outgoing requests.
///
/// The client never caches the token itself: it asks for the current value on
/// every request. Caching it meant a token received by `/auth/login` was not
/// attached to the `/auth/me` call that immediately followed, because the auth
/// state was only updated after that call returned.
typedef TokenResolver = String? Function();

class ApiClient {
  ApiClient({TokenResolver? tokenResolver})
      : _dio = Dio(),
        _tokenResolver = tokenResolver ?? (() => null) {
    // Every request must carry the bearer token, otherwise FastAPI answers 401
    // for the whole protected API. Doing it in an interceptor covers GET, POST,
    // PUT, DELETE and the multipart upload with one place to keep correct.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final current = _tokenResolver();
          if (current != null && current.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $current';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenResolver _tokenResolver;

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