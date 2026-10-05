import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config.dart';

/// Owns both tokens and knows how to renew the access one.
///
/// It exists so the refresh logic has a single home that neither
/// [ApiClient] nor the auth notifier has to reach into: the client needs to
/// renew on a 401, while the notifier needs to know when renewing failed.
/// Having both depend on this class instead of on each other is what keeps
/// that from becoming a cycle.
class SessionStore {
  SessionStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'memoir_access_token';
  static const _refreshKey = 'memoir_refresh_token';

  /// Read on every outgoing request by the client's interceptor.
  String? accessToken;
  String? refreshToken;

  /// Notified when the session cannot be recovered, so the app can log out.
  void Function()? onSessionLost;

  /// Guards against a refresh stampede: several requests can hit a 401 at the
  /// same time, and they must share one refresh rather than each start their
  /// own.
  Future<bool>? _inFlight;

  Future<String?> readAccess() => _storage.read(key: _accessKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> write(String access, String? refresh) async {
    accessToken = access;
    await _storage.write(key: _accessKey, value: access);
    if (refresh != null && refresh.isNotEmpty) {
      refreshToken = refresh;
      await _storage.write(key: _refreshKey, value: refresh);
    }
  }

  Future<void> setAccess(String access) async {
    accessToken = access;
    await _storage.write(key: _accessKey, value: access);
  }

  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    _inFlight = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  /// Exchange the refresh token for a new access token.
  ///
  /// Uses a bare [Dio] rather than `ApiClient`: this call sits inside the
  /// client's error interceptor, and going through it again would make a
  /// failed refresh retry itself forever.
  Future<bool> refreshAccessToken() {
    // Reuse the call already running so parallel 401s do not each refresh.
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  Future<bool> _doRefresh() async {
    final token = refreshToken;
    if (token == null || token.isEmpty) return false;
    try {
      final dio = Dio();
      final res = await dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/auth/refresh',
        data: {'refresh_token': token},
      );
      final fresh = res.data?['access_token'] as String?;
      if (fresh == null || fresh.isEmpty) return false;
      await setAccess(fresh);
      return true;
    } on DioException {
      // A rejected refresh token cannot be recovered from.
      return false;
    }
  }

  /// Called by the client when a retry after refreshing still failed.
  void sessionLost() => onSessionLost?.call();
}

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SessionStore(const FlutterSecureStorage()),
);

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

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(sessionStoreProvider)),
);

/// Sends the bearer token and transparently renews it once on a 401.
class ApiClient {
  ApiClient(this._session) : _dio = Dio() {
    // Every request must carry the bearer token, otherwise FastAPI answers 401
    // for the whole protected API. Doing it in an interceptor covers GET, POST,
    // PUT, DELETE and the multipart upload with one place to keep correct.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final current = _session.accessToken;
          if (current != null && current.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $current';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // One retry, and never for the refresh call itself (it uses its own
          // Dio), so a failing refresh cannot recurse.
          final alreadyRetried = error.requestOptions.extra['retried'] == true;
          if (error.response?.statusCode == 401 && !alreadyRetried) {
            final renewed = await _session.refreshAccessToken();
            if (renewed) {
              final options = error.requestOptions;
              options.extra['retried'] = true;
              options.headers['Authorization'] =
                  'Bearer ${_session.accessToken}';
              try {
                final retry = await _dio.fetch(options);
                return handler.resolve(retry);
              } on DioException catch (e) {
                // The retry failed too: the session is genuinely gone.
                _session.sessionLost();
                return handler.next(e);
              }
            }
            _session.sessionLost();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final SessionStore _session;

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

    // Checked before the `detail` branch on purpose: FastAPI sends a plain
    // "Could not validate credentials" for an expired token, which says nothing
    // useful to the reader, while the generic 401 message does.
    if (status == 401) return 'Phiên đăng nhập đã hết hạn. Hãy đăng nhập lại.';

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